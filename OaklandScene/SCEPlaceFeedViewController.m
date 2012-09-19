//
//  SCEPlaceFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlaceFeedViewController.h"
#import "SCEPlaceViewController.h"
#import "SCEPlace.h"
#import "SCEPlaceStore.h"
#import "SCECategory.h"
#import "SCEFeedSearchDialogController.h"
#import "SCEFeedItemContainer.h"

#import "SCEPlaceTableCell.h"
#import "SCEFeedStaticCell.h"

@implementation SCEPlaceFeedViewController

- (id)init
{
    self = [super init];
    if (self) {
        // set up the tab bar entry
        [self setTitle:@"Places"];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"second"]];
        
        // configure nav bar
//        [[self navigationItem] setTitle:@"Places Near You"];
        [self addViewToggleButton];
        [self addSearchButton];

        // initialize the data store
        [self setContentStore:[SCEPlaceStore sharedStore]];
        [self resetFeedContent];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // self will handle all UITableView delegation
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    // register the NIBs for cell reuse
    [tableView registerNib:[UINib nibWithNibName:@"SCEPlaceTableCell" bundle:nil]
        forCellReuseIdentifier:@"PlaceTableCell"];
    
    [tableView registerNib:[UINib nibWithNibName:@"SCEFeedLoadingCell" bundle:nil]
        forCellReuseIdentifier:@"FeedLoadingCell"];
    
    [tableView registerNib:[UINib nibWithNibName:@"SCEFeedStaticCell" bundle:nil]
    forCellReuseIdentifier:@"FeedStaticCell"];
}

-(void)resetFeedContent
{
    // if a successful fetch EVER happened, use the data
    // TODO: make this time sensitive
    if ([[self contentStore] lastSuccessfulFetch]) {
        feedPlaces = [[self contentStore] places];
        [self resetPaging];
    }
    else {
        [[self contentStore] fetchContentWithCompletion:
         ^void(NSArray *places, NSError* err) {
             if (places) {
                 feedPlaces = places;
                 [self resetPaging];
                 NSLog(@"Fetched %d places.", [places count]);
             }
             if (err) {
                 NSLog(@"Error! %@", err);
             }
         }];
    }
}

- (void)resetPaging
{
    displayedItems = [[NSMutableArray alloc] init];
    [self showNextPage];
}
- (void)showNextPage
{
    NSInteger feedIndex = [displayedItems count];
    // TODO: make page length a constant
    for (NSInteger i = 0; i < 10; i++) {
        if (feedIndex >= [feedPlaces count]) {
            break;
        }
        SCEFeedItemContainer* item =
        [[SCEFeedItemContainer alloc] initWithContent:[feedPlaces objectAtIndex:feedIndex]
                                                 type:SCEFeedItemTypeObject];
        [displayedItems addObject:item];
        feedIndex++;
    }

    if ([displayedItems count] < [feedPlaces count]) {
        NSLog(@"Next page button shown.");
        [displayedItems addObject:[[SCEFeedItemContainer alloc] initWithContent:@"Show More"
                                                                           type:SCEFeedItemTypeButton]];
    }
}

- (void)filterFeedContentByCategoryId:(NSInteger)categoryId
{
    NSMutableArray* filteredPlaces = [[NSMutableArray alloc] init];
    for (SCEPlace* place in feedPlaces) {
        for (SCECategory* c in [place categories]) {
            if ([c value] == categoryId) {
                [filteredPlaces addObject:place];
                break;
            }
        }
    }
    feedPlaces = filteredPlaces;
    [self resetPaging];
}

- (void)displaySearchDialog:(id)sender
{
    [super displaySearchDialog:sender];
    SCEFeedSearchDialogController* dialog =
        (SCEFeedSearchDialogController *)[self presentedViewController];
    [dialog setDelegate:self];
}

- (void)emptyFeedWithLoadingMessage:(BOOL)loadingMessage
{
    feedPlaces = [[NSArray alloc] init];
    if (loadingMessage) {
        SCEFeedItemContainer* item = [[SCEFeedItemContainer alloc] initWithContent:nil
                                                                              type:SCEFeedItemTypeLoading];
        displayedItems = [[NSMutableArray alloc] initWithObjects:item, nil];
    }
    else {
        displayedItems = [[NSMutableArray alloc] init];
    }
}

//// UITableViewDataSource methods ////

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return [displayedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCEFeedItemContainer* item = [displayedItems objectAtIndex:[indexPath row]];
    if ([item type] == SCEFeedItemTypeLoading) {
        return [tv dequeueReusableCellWithIdentifier:@"FeedLoadingCell"];
    }
    else if([item type] == SCEFeedItemTypeObject) {
        SCEPlace* place = [item content];
        SCEPlaceTableCell *cell = [tv dequeueReusableCellWithIdentifier:@"PlaceTableCell"];
        [[cell nameLabel] setText:[place name]];
        return cell;
    }
    else {
        SCEFeedStaticCell* cell = [tv dequeueReusableCellWithIdentifier:@"FeedStaticCell"];
        [[cell textLabel] setText:[item content]];
        return cell;
    }
}

//// UITableViewDelegate methods ////

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCEFeedItemContainer* item = [displayedItems objectAtIndex:[indexPath row]];
    if([item type] == SCEFeedItemTypeObject) {
        SCEPlace *place = [item content];
        SCEPlaceViewController *detailController = [[SCEPlaceViewController alloc] initWithPlace:place];
    
        [detailController setHidesBottomBarWhenPushed:YES];
        [[self navigationController] pushViewController:detailController animated:YES];
    }
    else if([item type] == SCEFeedItemTypeButton) {
        [displayedItems removeLastObject];
        [self showNextPage];
        [tableView reloadData];
    }
    
    UIButton* btn = [[UIButton alloc] init];
    [btn setValue:<#(id)#> forKey:<#(NSString *)#>]
}

//// SCEFeedSearchDelegate methods ////
- (void)searchDialog:(SCEFeedSearchDialogController *)dialog
    didSubmitSearchWithCategoryRow:(NSInteger)categoryRow
        keywordQuery:(NSString *)queryString
{
    // clear the feedPlaces and set the displayed items to a loading indicator
    [self emptyFeedWithLoadingMessage:YES];
    [tableView reloadData];
    
    NSNumber *categoryId = nil;
    // if category is 0, it means no filter
    if (categoryRow != 0) {
        SCECategory *category = [[[self contentStore] categories] objectAtIndex:categoryRow-1];
        categoryId = [NSNumber numberWithInteger:[category value]];
    }
    
    SCEPlaceFeedViewController* this = self;
    // define block to handle update of internal feed items after filter result is established
    void(^updateFeedPlaces)(NSArray *places, NSError* err) = ^(NSArray *places, NSError* err) {
        if (places) {
            feedPlaces = places;
        }
        else {
            // TODO: handle error conditions
            feedPlaces = [[NSArray alloc] init];
        }
        
        [self resetPaging];
        
        if (categoryId) {
            [this filterFeedContentByCategoryId:[categoryId integerValue]];
        }
        
        // TODO: turn off activity indicator
        [tableView reloadData];
    };

    if (queryString && [queryString length] > 0) {
        // if query was provided, need to let store handle query
        [[self contentStore] findPlacesMatchingQuery:queryString
                                            onReturn:updateFeedPlaces];
    }
    else {
        // otherwise, reset back to stored places
        NSArray *allPlaces = [[self contentStore] places];
        if (allPlaces) {
            updateFeedPlaces([[self contentStore] places], nil);
        }
        else {
            updateFeedPlaces(nil, [NSError errorWithDomain:@"Places not set" code:0 userInfo:nil]);
        }
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"All Places";
    }
    return [[[[self contentStore] categories] objectAtIndex:row-1] label];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
    numberOfRowsInComponent:(NSInteger)component
{
    return [[[self contentStore] categories] count] + 1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

@end
