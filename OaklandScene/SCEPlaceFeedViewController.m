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
        
        [[SCEPlaceStore sharedStore] fetchContentWithCompletion:
            ^void(NSArray *places, NSError* err) {
                 if (places) {
                     feedItems = places;
                     NSLog(@"Fetched %d places.", [places count]);
                 }
                 if (err) {
                     NSLog(@"Error! %@", err);
                 }
             }
         ];
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

//// SCESearchDialogDelegate methods ////
- (void)searchDialog:(SCESearchDialogController *)controller
didSubmitSearchWithCategory:(NSInteger)categoryId
        keywordQuery:(NSString *)queryString
{
    [super searchDialog:controller
didSubmitSearchWithCategory:categoryId
           keywordQuery:queryString];
    
    // TODO: turn on activity indicator
    
    // get a filtered list of places from the query
    [[self contentStore] findPlacesMatchingQuery:queryString
                                        onReturn:^(NSArray *places, NSError* err) {
        if (places) {
            // TODO: handle category filter
            feedItems = places;
        }
        else {
            // TODO: handle error conditions
            feedItems = [[NSArray alloc] init];
        }

        // TODO: turn off activity indicator
        [tableView reloadData];
    }];
}

@end
