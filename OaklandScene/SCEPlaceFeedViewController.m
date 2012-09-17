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
#import "SCEPlaceTableCell.h"
#import "SCECategory.h"
#import "SCEFeedSearchDialogController.h"

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
    
    // register the NIB for cell reuse
    UINib *nib = [UINib nibWithNibName:@"SCEPlaceTableCell" bundle:nil];
    [tableView registerNib:nib
        forCellReuseIdentifier:@"PlaceTableCell"];
}

-(void)resetFeedContent
{
    // if a successful fetch EVER happened, use the data
    // TODO: make this time sensitive
    if ([[self contentStore] lastSuccessfulFetch]) {
        feedItems = [[self contentStore] places];
    }
    else {
        [[self contentStore] fetchContentWithCompletion:
         ^void(NSArray *places, NSError* err) {
             if (places) {
                 feedItems = places;
                 NSLog(@"Fetched %d places.", [places count]);
             }
             if (err) {
                 NSLog(@"Error! %@", err);
             }
         }];
    }
}

- (void)filterFeedContentByCategoryId:(NSInteger)categoryId
{
    NSMutableArray* filteredPlaces = [[NSMutableArray alloc] init];
    for (SCEPlace* place in feedItems) {
        for (SCECategory* c in [place categories]) {
            if ([c value] == categoryId) {
                [filteredPlaces addObject:place];
                break;
            }
        }
    }
    feedItems = filteredPlaces;
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
    return [feedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCEPlace* place = [feedItems objectAtIndex:[indexPath row]];
    SCEPlaceTableCell *cell = [tv dequeueReusableCellWithIdentifier:@"PlaceTableCell"];
    [[cell nameLabel] setText:[place name]];
    return cell;
}

//// UITableViewDelegate methods ////

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCEPlace *place = [feedItems objectAtIndex:[indexPath row]];
    SCEPlaceViewController *detailController = [[SCEPlaceViewController alloc] initWithPlace:place];
    
    [detailController setHidesBottomBarWhenPushed:YES];
    [[self navigationController] pushViewController:detailController animated:YES];
}

//// SCEFeedSearchDelegate methods ////
- (void)searchDialog:(SCEFeedSearchDialogController *)dialog
    didSubmitSearchWithCategoryRow:(NSInteger)categoryRow
        keywordQuery:(NSString *)queryString
{
    // TODO: turn on activity indicator
    NSNumber *categoryId = nil;
    // if category is 0, it means no filter
    if (categoryRow != 0) {
        SCECategory *category = [[[self contentStore] categories] objectAtIndex:categoryRow-1];
        categoryId = [NSNumber numberWithInteger:[category value]];
    }
    
    SCEPlaceFeedViewController* this = self;
    // define block to handle update of internal feed items after filter result is established
    void(^updateFeedItems)(NSArray *places, NSError* err) = ^(NSArray *places, NSError* err) {
        if (places) {
            // TODO: handle category filter
            feedItems = places;
        }
        else {
            // TODO: handle error conditions
            feedItems = [[NSArray alloc] init];
        }
        
        if (categoryId) {
            [this filterFeedContentByCategoryId:[categoryId integerValue]];
        }
        
        // TODO: turn off activity indicator
        [tableView reloadData];
    };

    if (queryString && [queryString length] > 0) {
        // if query was provided, need to let store handle query
        [[self contentStore] findPlacesMatchingQuery:queryString
                                            onReturn:updateFeedItems];
    }
    else {
        // otherwise, reset back to stored places
        NSArray *allPlaces = [[self contentStore] places];
        if (allPlaces) {
            updateFeedItems([[self contentStore] places], nil);
        }
        else {
            updateFeedItems(nil, [NSError errorWithDomain:@"Places not set" code:0 userInfo:nil]);
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
