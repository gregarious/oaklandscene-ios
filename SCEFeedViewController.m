//
//  SCEFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SCEFeedViewController.h"
#import "SCEFeedSearchDialogController.h"
#import "SCEUtils.h"

@interface SCEFeedViewController ()

- (void)disableSearchFocus;
- (void)contentMaskTapped:(id)sender;

@end

@implementation SCEFeedViewController

@synthesize viewMode;

- (id)init
{
    self = [super init];
    if (self) {
        // default to table mode
        [self setViewMode:SCEFeedViewModeTable];
    }
    
    return self;
}

-(void)oldLoadView
{
    [super loadView];

    // TODO: is this the best way to get the frame?
    CGRect frame = [[[self parentViewController] view] bounds];

    // first load the subviews
    // IMPORTANT: These views need delegates: do it in subviews
    tableView = [[UITableView alloc] initWithFrame:frame
                                             style:UITableViewStylePlain];
    mapView = [[UIView alloc] init];

    // get primary view is in sync with the viewMode variable
    [self setViewMode:[self viewMode]];
}

-(void)loadView
{
    [super loadView];
    
    // TODO: is this the best way to get the frame? Could be a cause for the
    // problems in setting contentFrame's height below, but this is the only
    // configuration I could get working
    CGRect frame = [[[self parentViewController] view] bounds];
    [SCEUtils logRect:[[self view] frame] withLabel:@"feed view frame"];
    
    // set up resultsInfoBar
    // TODO: set to be in sync with item store
    UIBarButtonItem *categoryButton = [[UIBarButtonItem alloc] initWithTitle:@"All Places"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:nil
                                                                      action:nil];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
    [statusLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [statusLabel setTextColor:[UIColor whiteColor]];
    [statusLabel setBackgroundColor:[UIColor clearColor]];
    [statusLabel setText:@"nearby"];
    UIBarButtonItem *statusLabelButton = [[UIBarButtonItem alloc] initWithCustomView:statusLabel];
    
    resultsInfoBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
    [resultsInfoBar setItems:@[categoryButton, statusLabelButton]];
    [[self view] addSubview:resultsInfoBar];
    
    // calcluate the amount of frame left
    CGRect contentFrame = frame;
    contentFrame.origin.y += [resultsInfoBar frame].size.height;

    // TODO: why do we have to add in the height of the status and tab bar
    // manually? Shouldn't tab bar controller have given us a sane height?
    contentFrame.size.height -= (20 + 49 + [resultsInfoBar frame].size.height);

    // first load up the content view container
    contentView = [[UIView alloc] initWithFrame:contentFrame];
    [[self view] addSubview:contentView];

    [SCEUtils logRect:[contentView frame] withLabel:@"content view frame"];
    [SCEUtils logRect:[contentView bounds] withLabel:@"content view bounds"];
    
    // now load the tble & map subviews
    // IMPORTANT: These views need delegates: do it in subviews
    tableView = [[UITableView alloc] initWithFrame:[contentView bounds]
                                             style:UITableViewStylePlain];
    
    mapView = [[UIView alloc] init];
    [mapView addSubview:[[MKMapView alloc] initWithFrame:[contentView bounds]]];
    
    // ensure primary view is in sync with the viewMode variable
    [self setViewMode:[self viewMode]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    resultsInfoBar = nil;
    contentView = nil;
    tableView = nil;
    mapView = nil;
    
    // search bar and mask are set to be nil when off screen
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setViewMode:(SCEFeedViewMode)mode
{
    viewMode = mode;
    [contentSubview removeFromSuperview];
    
    if (viewMode == SCEFeedViewModeTable) {
        contentSubview = tableView;
    }
    else if (viewMode == SCEFeedViewModeMap) {
        contentSubview = mapView;
    }
    else {
        [NSException exceptionWithName:@"Invalid view mode"
                                reason:@"supplied mode constant is unsupported"
                              userInfo:nil];
    }
    [contentView addSubview:contentSubview];
}

// Makes the left nav bar button a view mode selector connected to toggleViewMode:
- (void)addViewToggleButton
{
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                                initWithTitle:@"Map"
                                        style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(toggleViewMode:)];
    [[self navigationItem] setLeftBarButtonItem:btn];
}

// Makes the right nav bar button a search icon connected to searchFeed:
- (void)addSearchButton
{
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                    target:self
                                                    action:@selector(enableSearchBar:)];
    [[self navigationItem] setRightBarButtonItem:btn];
}

/*** Search-related code ***/
// enables the search bar
- (void)enableSearchBar:(id)sender
{
    // paste over the basic title text with a blank view
    [[self navigationItem] setTitleView:[[UIView alloc] init]];

    // configure the search bar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 240, 44)];
    [searchBar setPlaceholder:@"Search"];
    [searchBar becomeFirstResponder];
    [searchBar setShowsCancelButton:YES];
    [searchBar setDelegate:self];
    
    // set the right NavBar "button" to be this search bar view
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    [[self navigationItem] setRightBarButtonItem:bbi];
    
    // set a mask view up to disable content interaction
    contentMaskView = [[UIControl alloc] initWithFrame:[contentView frame]];
    [contentMaskView setBackgroundColor:[UIColor blackColor]];
    [contentMaskView setAlpha:0.67];
    [[self view] insertSubview:contentMaskView aboveSubview:contentView];
    [contentView setUserInteractionEnabled:NO];
    
    // allow mask to be tappable for easy cancelling of search
    [contentMaskView addTarget:self
                        action:@selector(contentMaskTapped:)
              forControlEvents:UIControlEventTouchUpInside];
}

// special action method to cancel search via content mask tapping
- (void)contentMaskTapped:(id)sender
{
    [self searchBarCancelButtonClicked:searchBar];
}

// internal method to handle the cleanup involved with giving up search focus
- (void)disableSearchFocus
{
    [searchBar resignFirstResponder];
    [contentMaskView removeFromSuperview];
    contentMaskView = nil;
    [contentView setUserInteractionEnabled:YES];
}

// Removes the search view from the title bar. Child classes should use this
// as a hook to clear search results.
- (void)searchBarCancelButtonClicked:(UISearchBar *)s
{
    [self disableSearchFocus];
    searchBar = nil;
    
    // restore the simple text-based title and put the search button back
    [[self navigationItem] setTitleView:nil];
    [self addSearchButton];
}

// Child classes should extend this with actual search logic/results display
- (void)searchBarSearchButtonClicked:(UISearchBar *)s
{
    [self disableSearchFocus];
    NSLog(@"Search with query: %@", [s text]);
}

- (void)displaySearchDialog:(id)sender
{
//    SCEFeedSearchDialogController *dialog = [[SCEFeedSearchDialogController alloc] init];
//    [self presentModalViewController:dialog animated:YES];
}

- (void)toggleViewMode:(id)sender
{
    if (viewMode == SCEFeedViewModeMap) {
        [self setViewMode:SCEFeedViewModeTable];
        [[[self navigationItem] leftBarButtonItem] setTitle:@"Map"];
    }
    else {
        [self setViewMode:SCEFeedViewModeMap];
        [[[self navigationItem] leftBarButtonItem] setTitle:@"List"];
    }
}

@end
