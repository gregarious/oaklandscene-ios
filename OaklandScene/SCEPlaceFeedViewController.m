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

@synthesize feedSource;

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
        contentStore = [SCEPlaceStore sharedStore];
        [self resetFeed];
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

-(void)resetFeed
{
    SCEFeedSource* source = [[SCEFeedSource alloc] initWithStore:contentStore];
    [source setPageLength:10];
    [self setFeedSource:source];
}

- (void)setFeedSource:(SCEFeedSource *)fs
{
    // set the loading message
    SCEFeedItemContainer* loadingItem = [[SCEFeedItemContainer alloc] initWithContent:nil
                                                                          type:SCEFeedItemTypeLoading];
    displayedItems = [[NSMutableArray alloc] initWithObjects:loadingItem, nil];
    pagesDisplayed = 0;
    
    feedSource = fs;
    [feedSource setCompletionBlock:^void(NSError *err) {
        if(err) {
            SCEFeedItemContainer* errItem = [[SCEFeedItemContainer alloc] initWithContent:[err localizedDescription]
                                                                                  type:SCEFeedItemTypeStatic];
            displayedItems = [[NSMutableArray alloc] initWithObjects:errItem, nil];
        }
        else {
            displayedItems = [NSMutableArray array];
            [self addNextPage];
        }
        [tableView reloadData];

        // scroll back to top of screen
        if ([displayedItems count] > 0) {
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                 inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:NO];
        }
    }];
    [feedSource sync];
}

- (void)addNextPage
{
    if ([feedSource hasPage:pagesDisplayed]) {     // hasPage is 0-index based, pagesDisplayed is a count
        // add the next pages to displayedItems
        NSArray *nextPageItems = [feedSource getPage:pagesDisplayed];
        for (SCEPlace *p in nextPageItems) {
            [displayedItems addObject:[[SCEFeedItemContainer alloc]
                                        initWithContent:p
                                        type:SCEFeedItemTypeObject]];
        }
        
        // increment the internal page count and display "Show More" item if relevant
        pagesDisplayed++;
        if ([feedSource hasPage:pagesDisplayed])
        {
            [displayedItems addObject:[[SCEFeedItemContainer alloc] initWithContent:@"Show More"
                                                                               type:SCEFeedItemTypeStatic]];            
        }
    }
}

- (void)displaySearchDialog:(id)sender
{
    [super displaySearchDialog:sender];
    SCEFeedSearchDialogController* dialog =
        (SCEFeedSearchDialogController *)[self presentedViewController];
    [dialog setDelegate:self];
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
    else if([item type] == SCEFeedItemTypeStatic) {
        [displayedItems removeLastObject];
        [self addNextPage];
        [tableView reloadData];
    }
}

//// SCEFeedSearchDelegate methods ////
- (void)searchDialog:(SCEFeedSearchDialogController *)dialog
    didSubmitSearchWithCategoryRow:(NSInteger)categoryRow
        keywordQuery:(NSString *)queryString
{
    // create a new source with the given options
    SCEFeedSource *source = [[SCEFeedSource alloc] initWithStore:contentStore];

    // parse the category out of the category row chosen
    // if category is 0, it means no filter
    if (categoryRow != 0) {
        SCECategory *category = [[contentStore categories] objectAtIndex:categoryRow-1];
        [source setFilterCategory:category];
    }

    // if query is blank, don't do a keyword search
    if ([queryString length] > 0) {
        [source setFilterKeyword:queryString];
    }

    [self setFeedSource:source];
    [self dismissModalViewControllerAnimated:YES];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"All Places";
    }
    return [[[contentStore categories] objectAtIndex:row-1] label];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
    numberOfRowsInComponent:(NSInteger)component
{
    return [[contentStore categories] count] + 1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

@end
