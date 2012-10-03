//
//  SCEEventsFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEEventFeedViewController.h"
#import "SCEEventViewController.h"
#import "SCEEventStore.h"
#import "SCEFeedSource.h"
#import "SCEFeedView.h"
#import "SCEEventItemSource.h"

@implementation SCEEventFeedViewController

- (id)init
{
    self = [super init];
    if (self) {
        // set up the tab bar entry
        [self setTitle:@"Events"];
        // TODO: add tab bar image
        
        // configure nav bar
//        [[self navigationItem] setTitle:@"Upcoming Events"];
        [self addViewToggleButton];
        [self addSearchButton];
        
        contentStore = [SCEEventStore sharedStore];
        SCEFeedSource *feedSource = [[SCEFeedSource alloc] initWithStore:contentStore];
        
        [feedSource setItemSource:[[SCEEventItemSource alloc] init]];
        
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
    [tableView registerNib:[UINib nibWithNibName:@"SCEEventTableCell" bundle:nil]
           forCellReuseIdentifier:@"SCEEventTableCell"];

    // TODO: need to figure out how to handle this
    // if the main store is loaded, reset the feed
    //    if ([contentStore isLoaded]) {
    //        [self resetFeedFilters];
    //    }
    //    else {
    //        [self addStaticMessageToFeed:@"Events could not be loaded"];
    //        [[[self navigationItem] rightBarButtonItem] setEnabled:FALSE];
    //    }
}

@end
