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
#import "SCEMapView.h"

@implementation SCESpecialFeedViewController

- (id)init
{
    self = [super init];
    if (self) {
        // set up the tab bar entry
        [self setTitle:@"Specials"];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"specials.png"]];
        
        // configure nav bar
        [self addViewToggleButton];
        
        [self setShowResultsBar:NO];    // disable results bar (no categories)
        
        contentStore = [SCESpecialStore sharedStore];
        feedSource = [[SCEFeedSource alloc] initWithStore:contentStore];
        
        [feedSource setItemSource:[[SCESpecialItemSource alloc] init]];
        
        [self setDelegate:feedSource];
        [self setDataSource:feedSource];
        
        [self disableInterface];
        [feedSource syncWithCompletion:^(NSError *err) {
            [self enableInterface];
            [tableView reloadData];
            [mapView reloadDataAndAutoresize:YES];
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // if the store hasn't been loaded, try again now
    if (![contentStore isLoaded]) {
        [self disableInterface];
        [contentStore syncContentWithCompletion:^(NSArray *items, NSError *err) {
            [feedSource syncWithCompletion:^(NSError *err) {
                [self enableInterface];
                [tableView reloadData];
                [mapView reloadDataAndAutoresize:YES];
            }];
        }];
    }
}

@end
