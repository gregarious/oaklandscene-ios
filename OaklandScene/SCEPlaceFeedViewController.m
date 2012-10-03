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
#import "SCECategoryList.h"
#import "SCEFeedSource.h"
#import "SCEFeedView.h"

#import "SCEPlaceItemSource.h"

@implementation SCEPlaceFeedViewController

- (id)init
{
    self = [super init];
    
    if (self) {
        // set up the tab bar entry
        [self setTitle:@"Places"];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"second"]];
        
        // configure nav bar
        [self addViewToggleButton];
        [self addSearchButton];
        
        contentStore = [SCEPlaceStore sharedStore];
        SCEFeedSource *feedSource = [[SCEFeedSource alloc] initWithStore:contentStore];
        
        [feedSource setItemSource:[[SCEPlaceItemSource alloc] init]];
        
        [self setDelegate:feedSource];
        [self setDataSource:feedSource];
        
        [feedSource syncWithCompletion:^(NSError *err) {
            [tableView reloadData];
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // register the NIBs for cell reuse
    [tableView registerNib:[UINib nibWithNibName:@"SCEPlaceTableCell" bundle:nil]
        forCellReuseIdentifier:@"SCEPlaceTableCell"];

    // TODO: need to figure out how to handle this
    // if the main store is loaded, reset the feed
//    if ([contentStore isLoaded]) {
//        [self resetFeedFilters];
//    }
//    else {
//        [self addStaticMessageToFeed:@"Places could not be loaded"];
//        [[[self navigationItem] rightBarButtonItem] setEnabled:FALSE];
//    }
}

@end
