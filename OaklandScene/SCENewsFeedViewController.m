//
//  SCENewsFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCENewsFeedViewController.h"
#import "SCENewsViewController.h"
#import "SCENewsStub.h"
#import "SCEFeedView.h"
#import "SCENewsStore.h"
#import "SCENewsItemSource.h"
#import "SCEFeedSource.h"
#import "SCEFeedItemSource.h"

@implementation SCENewsFeedViewController

- (id)init
{
    self = [super init];
    
    if (self) {        
        // set up the tab bar entry
        [self setTitle:@"News"];
        // TODO: add tab bar image
        
        [self setShowResultsBar:NO];    // disable results bar (no categories)
        
        contentStore = [SCENewsStore sharedStore];
        SCEFeedSource *feedSource = [[SCEFeedSource alloc] initWithStore:contentStore];
        
        [feedSource setItemSource:[[SCENewsItemSource alloc] init]];
        
        [feedSource syncWithCompletion:^(NSError *err) {
            [tableView reloadData];
        }];
        
        [self setDelegate:feedSource];
        [self setDataSource:feedSource];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // register the NIBs for cell reuse
    [tableView registerNib:[UINib nibWithNibName:@"SCENewsTableCell" bundle:nil]
           forCellReuseIdentifier:@"SCENewsTableCell"];
    
    // TODO: need to figure out how to handle this
    // if the main store is loaded, reset the feed
    //    if ([contentStore isLoaded]) {
    //        [self resetFeedFilters];
    //    }
    //    else {
    //        [self addStaticMessageToFeed:@"News could not be loaded"];
    //        [[[self navigationItem] rightBarButtonItem] setEnabled:FALSE];
    //    }
}

@end
