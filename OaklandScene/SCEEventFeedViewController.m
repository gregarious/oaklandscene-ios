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
#import "SCEMapView.h"
#import "SCEResultsInfoBar.h"
#import "SCEEventItemSource.h"

@implementation SCEEventFeedViewController

- (id)init
{
    self = [super init];
    if (self) {
        // set up the tab bar entry
        [self setTitle:@"Events"];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"events.png"]];
        
        // configure nav bar
//        [[self navigationItem] setTitle:@"Upcoming Events"];
        [self addViewToggleButton];
        [self addSearchButton];
        
        contentStore = [SCEEventStore sharedStore];
        feedSource = [[SCEFeedSource alloc] initWithStore:contentStore];
        
        [feedSource setItemSource:[[SCEEventItemSource alloc] init]];
        
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
    [tableView registerNib:[UINib nibWithNibName:@"SCEEventTableCell" bundle:nil]
           forCellReuseIdentifier:@"SCEEventTableCell"];

    [[resultsInfoBar infoLabel] setText:@"upcoming soon"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // if the store hasn't been loaded, try again now
    if (![contentStore isLoaded]) {
        [self disableInterface];
        [contentStore syncContentWithCompletion:^(NSArray *items, NSError *err) {
            [feedSource syncWithCompletion:^(NSError *err) {
                NSLog(@"cannot sync with store");
                [self enableInterface];
                [tableView reloadData];
                [mapView reloadDataAndAutoresize:YES];
            }];
        }];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)sb
{
    [super searchBarCancelButtonClicked:sb];
    [[resultsInfoBar infoLabel] setText:@"upcoming soon"];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)sb
{
    [super searchBarSearchButtonClicked:sb];
    [[resultsInfoBar infoLabel] setText:@"matching seach query"];
}

@end
