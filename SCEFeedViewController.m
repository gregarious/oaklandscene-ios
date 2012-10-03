//
//  SCEFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SCEFeedViewController.h"
#import "SCECategoryPickerDialogController.h"
#import "SCEFeedView.h"

@interface SCEFeedViewController ()

- (void)disableSearchFocus;
- (void)contentMaskTapped:(id)sender;

@end

@implementation SCEFeedViewController

@synthesize viewMode, feedViewContainer;

- (id)init
{
    self = [super init];
    if (self) {
        // default to table mode
        [self setViewMode:SCEFeedViewModeTable];
    }
    
    return self;
}

-(void)loadView
{
    [super loadView];
    
    // TODO: is this the best way to get the frame? Could be a cause for the
    // problems in setting contentFrame's height below, but this is the only
    // configuration I could get working
    CGRect frame = [[[self parentViewController] view] bounds];
    
    // set up resultsInfoBar
    NSString *defaultLabel = [[self dataSource] feedView:feedViewContainer labelForCategory:0];
    UIBarButtonItem *categoryButton = [[UIBarButtonItem alloc] initWithTitle:defaultLabel
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(displayFilterDialog:)];
    
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

    // now load the tble & map subviews
    tableView = [[UITableView alloc] initWithFrame:[contentView bounds]
                                             style:UITableViewStylePlain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    mapView = [[UIView alloc] init];
    [mapView addSubview:[[MKMapView alloc] initWithFrame:[contentView bounds]]];
    
    // ensure primary view is in sync with the viewMode variable
    [self setViewMode:[self viewMode]];
    
    // set up the container FeedView for delegate method passing
    feedViewContainer = [[SCEFeedView alloc] initWithFrame:frame];
    [feedViewContainer setSearchBar:searchBar];
    [feedViewContainer setResultsInfoBar:resultsInfoBar];
    [feedViewContainer setContentView:contentView];
    [feedViewContainer setTableView:tableView];
    [feedViewContainer setMapView:mapView];    
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
    feedViewContainer = nil;
    
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

- (void)displayFilterDialog:(id)sender
{
    SCECategoryPickerDialogController *dialog = [[SCECategoryPickerDialogController alloc] init];
    [self presentModalViewController:dialog animated:YES];
    [dialog setDelegate:self];
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

/**** UISearchBarDelegate & related methods ****/

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // set a mask view up to disable content interaction
    [contentMaskView removeFromSuperview];  // just in case it's already there
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

// on search submission, disalbe focus and update feed source
- (void)searchBarSearchButtonClicked:(UISearchBar *)sb
{
    [self disableSearchFocus];
    [[self delegate] feedView:feedViewContainer
         didSubmitSearchQuery:[sb text]];
}

// removes the search view from the title bar.
- (void)searchBarCancelButtonClicked:(UISearchBar *)sb
{
    [self disableSearchFocus];
    searchBar = nil;
    
    // restore the simple text-based title and put the search button back
    [[self navigationItem] setTitleView:nil];
    [self addSearchButton];
    
    [[self delegate] didCancelSearchForFeedView:feedViewContainer];
}

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
}

// special action method to exit search bar focus via content mask tapping
- (void)contentMaskTapped:(id)sender
{
    [self disableSearchFocus];
    [searchBar setText:@""];
}

// internal method to handle the cleanup involved with giving up search focus
- (void)disableSearchFocus
{
    [searchBar resignFirstResponder];
    [contentMaskView removeFromSuperview];
    contentMaskView = nil;
    [contentView setUserInteractionEnabled:YES];
}

/**** SCECategoryPickerDelegate methods ****/
- (void)searchDialog:(SCECategoryPickerDialogController *)dialog
didSubmitSearchWithCategoryRow:(NSInteger)categoryRow
{
    [[self delegate] feedView:feedViewContainer
       didChooseCategoryIndex:categoryRow];
    [self dismissModalViewControllerAnimated:YES];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [[self dataSource] feedView:feedViewContainer
                      labelForCategory:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [[self dataSource] numberOfCategoriesInFeedView:feedViewContainer];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

/**** UITableViewDataSource & UITableViewDelegate methods ****/

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return [[self dataSource] numberOfItemsInFeedView:feedViewContainer];
}

- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self dataSource] feedView:feedViewContainer
                      tableCellForItem:[indexPath row]];
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self delegate] feedView:feedViewContainer
              tableCellHeightForItem:[indexPath row]];
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *detailController = [[self delegate] feedView:feedViewContainer
                                         didSelectTableCellForItem:[indexPath row]];
    if (detailController) {
        [detailController setHidesBottomBarWhenPushed:YES];
        [[self navigationController] pushViewController:detailController animated:YES];
    }
}


@end
