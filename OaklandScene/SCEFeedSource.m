//
//  SCEFeedSource.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/19/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEFeedSource.h"
#import "SCEFeedView.h"
#import "SCEFeedCellHandler.h"
#import "SCEPlaceStore.h"
#import "SCECategory.h"
#import "SCEFeedCellHandler.h"
#import "SCEFeedStaticCell.h"

@interface SCEFeedSource ()

enum {
    SCEFeedCellTypeStatus = 0,
    SCEFeedCellTypeItem = 1,
    SCEFeedCellTypeMore = 2
};
typedef NSUInteger SCEFeedCellType;

- (SCEFeedCellType)cellTypeForIndex:(NSInteger)index;

@end

@implementation SCEFeedSource

@synthesize store, items, pageLength;
@synthesize filterCategory, filterKeyword;

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
            [[cell textLabel] setText:[err localizedDescription]];
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

/*** SCEFeedDelegate methods ***/
- (void)feedView:(SCEFeedView *)feedView didChooseCategoryIndex:(NSInteger)categoryIndex
{
    [self setFilterCategory:[[[self store] categories] objectAtIndex:categoryIndex]];
    
    // sync feed and refresh the table upon completion
    // TODO: consider ongoing syncs
    [self syncWithCompletion:^(NSError *err) {
        [[feedView tableView] reloadData];
    }];

    // refresh the table now to show loading message
    [[feedView tableView] reloadData];
}

- (void)feedView:(SCEFeedView *)feedView didSubmitSearchQuery:(NSString *)queryString
{
    [self setFilterKeyword:queryString];

    // sync feed and refresh the table upon completion
    // TODO: consider ongoing syncs
    [self syncWithCompletion:^(NSError *err) {
        [[feedView tableView] reloadData];
    }];
    
    // refresh the table now to show loading message
    [[feedView tableView] reloadData];
}

- (void)feedView:(SCEFeedView *)feedView didSelectTableCellForItem:(NSInteger)itemIndex
{
    SCEFeedCellType cellType = [self cellTypeForIndex:itemIndex];
    if (cellType == SCEFeedCellTypeItem) {
        id item = [[self items] objectAtIndex:itemIndex];
        [[self cellHandler] feedView:feedView didSelectItem:item];
    }
    else if (cellType == SCEFeedCellTypeMore) {
        shownItemRange.length += [self pageLength];
        // if we've gone past the number of items, clip it back
        if (shownItemRange.length > [[self items] count]) {
            shownItemRange.length = [[self items] count];
        }
        [[feedView tableView] reloadData];
    }
}

- (CGFloat)feedView:(SCEFeedView *)feedView tableCellHeightForItem:(NSInteger)itemIndex
{
    SCEFeedCellType cellType = [self cellTypeForIndex:itemIndex];
    if (cellType == SCEFeedCellTypeItem) {
        id item = [[self items] objectAtIndex:itemIndex];
        return [[self cellHandler] feedView:feedView
                     tableCellHeightForItem:item];
    }
    else {
        return 44;        
    }

}

/*** SCEFeedDataSource methods ***/
- (NSString *)feedView:(SCEFeedView *)feedView labelForCategory:(NSInteger)categoryIndex
{
    return [[[[self store] categories] objectAtIndex:categoryIndex] label];
}

- (UITableViewCell *)feedView:(SCEFeedView *)feedView tableCellForItem:(NSInteger)itemIndex
{
    SCEFeedCellType cellType = [self cellTypeForIndex:itemIndex];
    if (cellType == SCEFeedCellTypeItem) {
        id item = [items objectAtIndex:itemIndex];
        return [[self cellHandler] feedView:feedView
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

- (NSInteger)numberOfCategoriesInFeedView:(SCEFeedView *)feedView
{
    return [[[self store] categories] count];
}

@end
