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
#import "SCEFeedSource.h"
#import "SCEFeedItemContainer.h"
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
        displayedItems = [NSMutableArray array];

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
    [SCEUtils logRect:[[self view] frame] withLabel:@"feed view frame"];
    
    // set up resultsInfoBar
    // TODO: set to be in sync with item store
    UIBarButtonItem *categoryButton = [[UIBarButtonItem alloc] initWithTitle:@"All Places"
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

    [SCEUtils logRect:[contentView frame] withLabel:@"content view frame"];
    [SCEUtils logRect:[contentView bounds] withLabel:@"content view bounds"];
    
    // now load the tble & map subviews
    tableView = [[UITableView alloc] initWithFrame:[contentView bounds]
                                             style:UITableViewStylePlain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    mapView = [[UIView alloc] init];
    [mapView addSubview:[[MKMapView alloc] initWithFrame:[contentView bounds]]];
    
    // ensure primary view is in sync with the viewMode variable
    [self setViewMode:[self viewMode]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // REFACTOR: more weird
    [[self feedSource] setDelegate:self];
    
    // ensure feed in synced up
    [[self feedSource] sync];
    
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

/*** Feed management ****/

- (void)addNextPageToFeed
{
    if ([[self feedSource] hasPage:pagesDisplayed]) {     // hasPage is 0-index based, pagesDisplayed is a count
        // add the next pages to displayedItems
        NSArray *nextPageItems = [[self feedSource] getPage:pagesDisplayed];
        for (SCEPlace *p in nextPageItems) {
            [displayedItems addObject:[[SCEFeedItemContainer alloc]
                                       initWithContent:p
                                       type:SCEFeedItemTypeObject]];
        }
        
        // increment the internal page count and display "Show More" item if relevant
        pagesDisplayed++;
        if ([[self feedSource] hasPage:pagesDisplayed])
        {
            [displayedItems addObject:[[SCEFeedItemContainer alloc] initWithContent:@"Show More"
                                                                               type:SCEFeedItemTypeAction]];
        }
    }
}

- (void)emptyFeed
{
    displayedItems = [NSMutableArray array];
    pagesDisplayed = 0;
}


- (void)addLoadingMessageToFeed
{
    [displayedItems addObject:[[SCEFeedItemContainer alloc] initWithContent:nil
                                                                       type:SCEFeedItemTypeLoading]];
}

- (void)addStaticMessageToFeed:(NSString *)message
{
    [displayedItems addObject:[[SCEFeedItemContainer alloc] initWithContent:message
                                                                       type:SCEFeedItemTypeStatic]];
    
}

/**** SCEFeedSourceDelegate methods ****/
- (void)feedSourceContentReady:(id)incomingFS
{
    // if some old feed source floating around out there is calling back, ignore it
    if (incomingFS != [self feedSource]) {
        return;
    }
    
    [self emptyFeed];
    if (![[self feedSource] hasPage:0]) {
        [self addStaticMessageToFeed:@"No places found"];
    }
    else {
        [self addNextPageToFeed];
    }
    
    [tableView reloadData];
    // scroll back to top of screen
    if ([displayedItems count] > 0) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                             inSection:0]
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:NO];
    }
}

- (void)feedSource:(id)incomingFS syncError:(NSError *)err
{
    NSLog(@"In feedSource:syncError:");
    
    // if some old feed source floating around out there is calling back, ignore it
    if (incomingFS != [self feedSource]) {
        return;
    }
    
    // on error, alert the user via an alert, and fill the table with a "no places" message
    [[[UIAlertView alloc] initWithTitle:@"Connection Problem"
                                message:[err localizedDescription]
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
    
    [self emptyFeed];
    [self addStaticMessageToFeed:@"No places found"];
    [tableView reloadData];
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
    
    NSString *queryString = [sb text];
    // if query is blank, don't do a keyword search
    if ([queryString length] > 0) {
        [[self feedSource] setFilterKeyword:queryString];
        [[self feedSource] sync];
    }
}

// removes the search view from the title bar.
- (void)searchBarCancelButtonClicked:(UISearchBar *)sb
{
    [self disableSearchFocus];
    searchBar = nil;
    
    // restore the simple text-based title and put the search button back
    [[self navigationItem] setTitleView:nil];
    [self addSearchButton];
    
    // remove search query from feed source
    [[self feedSource] setFilterKeyword:nil];
    [[self feedSource] sync];
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
    // parse the category out of the category row chosen
    // if category is 0, it means no filter
    SCECategory *category = nil;
    if (categoryRow != 0) {
        category = [[[self feedSource] categories] objectAtIndex:categoryRow-1];
    }
    
    [[self feedSource] setFilterCategory:category];
    [[self feedSource] sync];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"All Places";
    }
    return [[[[self feedSource] categories] objectAtIndex:row-1] label];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [[[self feedSource] categories] count] + 1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

/**** UITableViewDataSource & UITableViewDelegate methods ****/

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return [displayedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCEFeedItemContainer* item = [displayedItems objectAtIndex:[indexPath row]];
    return [[self delegate] tableView:tableView cellForItem:item];
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCEFeedItemContainer* item = [displayedItems objectAtIndex:[indexPath row]];
    return [[self delegate] tableView:tv heightForItem:item];
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCEFeedItemContainer* item = [displayedItems objectAtIndex:[indexPath row]];
    [[self delegate] tableView:tableView didSelectItem:item];
}


@end
