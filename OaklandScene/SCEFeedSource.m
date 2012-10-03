//
//  SCEFeedSource.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/19/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEFeedSource.h"
#import "SCEFeedView.h"
#import "SCEResultsInfoBar.h"
#import "SCEFeeditemSource.h"
#import "SCEPlaceStore.h"
#import "SCECategory.h"
#import "SCEFeeditemSource.h"
#import "SCEFeedStaticCell.h"

@interface SCEFeedSource ()

enum {
    SCEFeedCellTypeStatus = 0,
    SCEFeedCellTypeItem = 1,
    SCEFeedCellTypeMore = 2
};
typedef NSUInteger SCEFeedCellType;

- (SCEFeedCellType)cellTypeForIndex:(NSInteger)index;
- (void)resetTable:(UITableView *)tableView;

@end

@implementation SCEFeedSource

@synthesize store, items, pageLength;
@synthesize filterCategory, filterKeyword;
@synthesize itemSource;

- (id)init
{
    return [self initWithStore:nil];
}

- (id)initWithStore:(SCEPlaceStore *)s
{
    self = [super init];
    if (self) {
        [self setPageLength:10];
        syncInProgress = false;
        
        // setup fixed static cells
        loadingCell = [[NSBundle mainBundle] loadNibNamed:@"SCEFeedLoadingCell"
                                                    owner:self options:nil][0];
        showMoreCell = [[NSBundle mainBundle] loadNibNamed:@"SCEFeedStaticCell"
                                                    owner:self options:nil][0];
        [[showMoreCell textLabel] setText:@"Show More"];
        
        [self setStore:s];
    }
    return self;
}

- (void)syncWithCompletion:(void (^)(NSError *err))block
{
    syncInProgress = true;
    statusCell = loadingCell;
    
    // clear items until sync is finished
    items = nil;
    shownItemRange.length = shownItemRange.location = 0;

    // once the proper items have been retreived, store them and call the completion block
    void (^onSyncComplete)(NSArray *, NSError *) = ^void (NSArray *matches, NSError *err) {
        items = matches;
        
        if (items) {
            NSLog(@"Sync complete: %d matches", [items count]);
            if ([items count] == 0) {
                // TODO: make this more efficient?
                SCEFeedStaticCell *cell = [[NSBundle mainBundle] loadNibNamed:@"SCEFeedStaticCell"
                                                                       owner:self
                                                                     options:nil][0];
                [[cell textLabel] setText:@"No results found"];
                statusCell = cell;
            }
            else {
                shownItemRange.location = 0;
                shownItemRange.length = MIN([self pageLength], [matches count]);
                statusCell = nil;
            }
        }
        else {
            NSLog(@"Sync failed: %@", err);
            // TODO: make this more efficient?
            SCEFeedStaticCell *cell = [[NSBundle mainBundle] loadNibNamed:@"SCEFeedStaticCell"
                                                                    owner:self
                                                                  options:nil][0];

            // on error, alert the user via an alert, and fill the table with a "no places" message
            [[[UIAlertView alloc] initWithTitle:@"Connection Problem"
                                        message:[err localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil] show];
            [[cell textLabel] setText:@"No results found"];
            statusCell = cell;
        }
        
        block(err);
        syncInProgress = false;
    };
    
    // if no filtering, don't bother with asking the store anything special
    if (![self filterCategory] && ![self filterKeyword]) {
        // "sync" never needs to happen, just call directly
        onSyncComplete([[self store] places], nil);
    }
    else {
        // otherwise
        [store findPlacesMatchingQuery:[self filterKeyword]
                              category:[self filterCategory]
                              onReturn:onSyncComplete];
    }
}

// conveinence function
- (SCEFeedCellType)cellTypeForIndex:(NSInteger)index
{
    NSInteger endIndex = (shownItemRange.location + shownItemRange.length);
    if (shownItemRange.length == 0 && index == 0) {
        // if no items, it's a status message cell
        return SCEFeedCellTypeStatus;
    }
    else if (index >= shownItemRange.location && index < endIndex) {
        // if index is in the range of shown items, it's an item cell
        return SCEFeedCellTypeItem;
    }
    else if (index == endIndex) {
        // if the index is one past the range, it's a "Show More" cell
        return SCEFeedCellTypeMore;
    }
    else {
        // should never happen
        @throw [NSException exceptionWithName:@"Inconsistent internal state"
                                       reason:@"Invalid cell index referenced"
                                     userInfo:nil];
    }
}

- (void)resetTable:(UITableView *)tableView
{
    [tableView reloadData];
    if (shownItemRange.length > 0) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                        inSection:0]
                                    atScrollPosition:UITableViewScrollPositionTop
                                            animated:NO];
    }
}

/*** SCEFeedDelegate methods ***/
- (void)feedView:(SCEFeedView *)feedView didChooseCategoryIndex:(NSInteger)categoryIndex
{
    SCECategory* newCategory;
    if (categoryIndex == 0) {
        // 0 is code for no category
        newCategory = nil;
    }
    else {
        // if > 0, ask the store. decrement first since store categories are 0-indexed
        newCategory = [[[self store] categories] objectAtIndex:categoryIndex-1];
    }
    
    // only make changes if category is actually different
    if ([newCategory value] != [[self filterCategory] value]) {
        [self setFilterCategory:newCategory];
        
        // sync feed and refresh the table upon completion
        // TODO: consider ongoing syncs
        [self syncWithCompletion:^(NSError *err) {
            [self resetTable:[feedView tableView]]; // handles reload and scroll to top
        }];

        // refresh the table now to show loading message
        [[feedView tableView] reloadData];
        
        // TODO: better to update category button title here maybe?
    }
}

- (void)feedView:(SCEFeedView *)feedView didSubmitSearchQuery:(NSString *)queryString
{
    [self setFilterKeyword:queryString];

    // sync feed and refresh the table upon completion
    // TODO: consider ongoing syncs
    [self syncWithCompletion:^(NSError *err) {
        [self resetTable:[feedView tableView]]; // handles reload and scroll to top
    }];
    
    // refresh the table now to show loading message
    [[feedView tableView] reloadData];
    
    // update the info bar text
    [[[feedView resultsInfoBar] infoLabel] setText:@"matching custom search"];
}

- (void)didCancelSearchForFeedView:(SCEFeedView *)feedView
{
    // don't do anything if user never submitted a search in the first place
    if (filterKeyword != nil) {
        [self setFilterKeyword:nil];
        
        // sync feed and refresh the table upon completion
        // TODO: consider ongoing syncs
        [self syncWithCompletion:^(NSError *err) {
            [self resetTable:[feedView tableView]]; // handles reload and scroll to top
        }];
    
        // refresh the table now to show loading message
        [[feedView tableView] reloadData];
        
        // update the info bar text
        [[[feedView resultsInfoBar] infoLabel] setText:@"closest to you"];
    }
}

- (UIViewController *)feedView:(SCEFeedView *)feedView didSelectTableCellForItem:(NSInteger)itemIndex
{
    SCEFeedCellType cellType = [self cellTypeForIndex:itemIndex];
    if (cellType == SCEFeedCellTypeItem) {
        id item = [[self items] objectAtIndex:itemIndex];
        return [[self itemSource] feedView:feedView didSelectItem:item];
    }
    else if (cellType == SCEFeedCellTypeMore) {
        shownItemRange.length += [self pageLength];
        // if we've gone past the number of items, clip it back
        if (shownItemRange.length > [[self items] count]) {
            shownItemRange.length = [[self items] count];
        }
        [[feedView tableView] reloadData];
        // scroll down so new item is at top of list
        [[feedView tableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:itemIndex
                                                                        inSection:0]
                                    atScrollPosition:UITableViewScrollPositionTop
                                            animated:YES];
    }
    return nil;
}

- (CGFloat)feedView:(SCEFeedView *)feedView tableCellHeightForItem:(NSInteger)itemIndex
{
    SCEFeedCellType cellType = [self cellTypeForIndex:itemIndex];
    if (cellType == SCEFeedCellTypeItem) {
        id item = [[self items] objectAtIndex:itemIndex];
        return [[self itemSource] feedView:feedView
                     tableCellHeightForItem:item];
    }
    else {
        return 44;        
    }

}

/*** SCEFeedDataSource methods ***/
- (UITableViewCell *)feedView:(SCEFeedView *)feedView tableCellForItem:(NSInteger)itemIndex
{
    SCEFeedCellType cellType = [self cellTypeForIndex:itemIndex];
    if (cellType == SCEFeedCellTypeItem) {
        id item = [items objectAtIndex:itemIndex];
        return [[self itemSource] feedView:feedView
                           tableCellForItem:item];
    }
    else if (cellType == SCEFeedCellTypeStatus) {
        return statusCell;
    }
    else {
        return showMoreCell;
    }
}

- (NSInteger)numberOfItemsInFeedView:(SCEFeedView *)feedView
{
    if (shownItemRange.length < [[self items] count]) {
        return shownItemRange.length + 1;   // leave room for "Show More"
    }
    else {
        return shownItemRange.length;
    }
}

- (NSString *)feedView:(SCEFeedView *)feedView labelForCategory:(NSInteger)categoryIndex
{
    if (categoryIndex == 0) {
        // 0 is code for no category, or default category. defer to itemSource.
        return [[self itemSource] defaultCategoryLabelForFeedView:feedView];
    }
    else {
        // if the category index is > 0, can get it direct from the store
        return [[[[self store] categories] objectAtIndex:categoryIndex-1] label];
    }
}

- (NSInteger)numberOfCategoriesInFeedView:(SCEFeedView *)feedView
{
    return [[[self store] categories] count] + 1;
}

- (NSNumber *)activeCategoryIndexInFeedView:(SCEFeedView *)feedView
{
    if (filterCategory) {
        NSArray* categories = [[self store] categories];
        for (int i = 0; i < [categories count]; i++) {
            SCECategory* cat = [categories objectAtIndex:i];
            if ([cat value] == [filterCategory value]) {
                return [NSNumber numberWithInt:i];
            }
        }
    }
    // if no category, or couldn't be found in store (which should never happen!), return nil
    return nil;
}

@end
