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
#import "SCEPlaceFeedSource.h"
#import "SCEFeedView.h"
#import "SCEMapView.h"
#import "SCEResultsInfoBar.h"
#import "SCEPlaceItemSource.h"

@interface SCEPlaceFeedViewController ()
- (void)refreshResultsBarLabel;
@end

@implementation SCEPlaceFeedViewController

- (id)init
{
    self = [super init];
    
    if (self) {
        // set up the tab bar entry
        [self setTitle:@"Places"];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"places.png"]];
        
        // configure nav bar
        [self addViewToggleButton];
        [self addSearchButton];
        
        // set up the location services
        if ([CLLocationManager locationServicesEnabled]) {
            locationManager = [[CLLocationManager alloc] init];
            [locationManager setDelegate:self];
            [locationManager setDistanceFilter:250];
            [locationManager startUpdatingLocation];
        }
        
        contentStore = [SCEPlaceStore sharedStore];
        // start with store centered at default center point
        
        feedSource = [[SCEPlaceFeedSource alloc] initWithStore:contentStore];
        [feedSource setItemSource:[[SCEPlaceItemSource alloc] init]];
        [feedSource setAnchorCoordinate:[SCEPlaceFeedViewController defaultDisplayRegion].center];

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
    [tableView registerNib:[UINib nibWithNibName:@"SCEPlaceTableCell" bundle:nil]
        forCellReuseIdentifier:@"SCEPlaceTableCell"];

    // set up the labels that will be in the results info bar
    mapResultsBarLabel = @"";
    tableResultsBarLabel = @"closest to you";
    [self refreshResultsBarLabel];
    
    [[resultsInfoBar reloadButton] setTarget:self];
    [[resultsInfoBar reloadButton] setAction:@selector(refreshMapResults:)];
    
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

- (void)setViewMode:(SCEFeedViewMode)viewMode
{
    // first set the reload button visibility
    if (viewMode == SCEFeedViewModeTable) {
        // if showing table mode, be sure it's centered on user's location
        if ([locationManager location]) {
            [self refreshFeedWithCenter:[[locationManager location] coordinate]];
        }
        else {
            [self refreshFeedWithCenter:[SCEFeedViewController defaultDisplayRegion].center];
        }
        
        // also hide reload button
        [resultsInfoBar setShowReloadButton:NO];
        
        // reload data to account for recent resort
        [tableView reloadData];
        
    }
    else {        
        // if map mode, show reload button on toolbar
        [resultsInfoBar setShowReloadButton:YES];
        
        // reload data to ensure we're in sync with the list view
        [mapView reloadDataAndAutoresize:YES];
    }

    [super setViewMode:viewMode];
    
    [self refreshResultsBarLabel];
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

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
//    if (![resultsInfoBar showReloadButton]) {
//        [resultsInfoBar setShowReloadButton:YES];
//    }
}

-(void)refreshMapResults:(id)sender
{
    [self refreshFeedWithCenter:[mapView centerCoordinate]];
    [mapView reloadDataAndAutoresize:YES];
}

-(void)refreshFeedWithCenter:(CLLocationCoordinate2D)coord
{
    [feedSource setAnchorCoordinate:coord];
    [feedSource sortItems];
}

-(void)refreshResultsBarLabel
{
    if([self viewMode] == SCEFeedViewModeTable) {
        [[resultsInfoBar infoLabel] setText:tableResultsBarLabel];
    }
    else {
        [[resultsInfoBar infoLabel] setText:mapResultsBarLabel];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)sb
{
    [super searchBarCancelButtonClicked:sb];
    mapResultsBarLabel = @"";
    tableResultsBarLabel = @"closest to you";
    [self refreshResultsBarLabel];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)sb
{
    [super searchBarSearchButtonClicked:sb];
    mapResultsBarLabel = tableResultsBarLabel = @"matching seach query";
    [self refreshResultsBarLabel];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    NSLog(@"Location update occurred");
    [feedSource setAnchorCoordinate:[[locations lastObject] coordinate]];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//    NSLog(@"locationManager didFailWithError: %@", error);
}

@end
