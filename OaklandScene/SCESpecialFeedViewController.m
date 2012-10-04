//
//  SCESpecialsFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCESpecialFeedViewController.h"
#import "SCESpecialViewController.h"
#import "SCESpecialStore.h"
#import "SCEFeedSource.h"
#import "SCESpecialItemSource.h"
#import "SCEFeedView.h"
#import "SCEResultsInfoBar.h"
#import "SCEUtils.h"

@implementation SCESpecialFeedViewController

- (id)init
{
    self = [super init];
    if (self) {
        // set up the tab bar entry
        [self setTitle:@"Specials"];
        // TODO: add tab bar image
        
        // configure nav bar
//        [[self navigationItem] setTitle:@"Available Specials"];
        [self addViewToggleButton];
        
        [self setShowResultsBar:NO];    // disable results bar (no categories)
        
        // TODO: set up feed source
        contentStore = [SCESpecialStore sharedStore];
        SCEFeedSource *feedSource = [[SCEFeedSource alloc] initWithStore:contentStore];
        
        [feedSource setItemSource:[[SCESpecialItemSource alloc] init]];
        
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
    [tableView registerNib:[UINib nibWithNibName:@"SCESpecialTableCell" bundle:nil]
           forCellReuseIdentifier:@"SCESpecialTableCell"];
    
    
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
