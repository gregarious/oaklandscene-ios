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
        [[self tabBarItem] setImage:[UIImage imageNamed:@"news.png"]];
        
        [self setShowResultsBar:NO];    // disable results bar (no categories)
        
        contentStore = [SCENewsStore sharedStore];
        feedSource = [[SCEFeedSource alloc] initWithStore:contentStore];
        
        [feedSource setItemSource:[[SCENewsItemSource alloc] init]];
        
        [self setDelegate:feedSource];
        [self setDataSource:feedSource];
        
        [self disableInterface];
        [feedSource syncWithCompletion:^(NSError *err) {
            [self enableInterface];
            [tableView reloadData];
        }];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // register the NIBs for cell reuse
    [tableView registerNib:[UINib nibWithNibName:@"SCENewsTableCell" bundle:nil]
           forCellReuseIdentifier:@"SCENewsTableCell"];
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
            }];
        }];
    }
}

@end
