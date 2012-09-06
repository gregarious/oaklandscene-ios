//
//  SCEFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEFeedViewController.h"
#import "SCEFeedTableViewController.h"
#import "SCEFeedMapViewController.h"

@implementation SCEFeedViewController

@synthesize viewMode, tableViewController, mapViewController;

// Designated
// Extend this in child classes to also set the cell and annotation Nib names
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // default to table mode
        viewMode = SCEFeedViewModeTable;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up the sub view controllers
    [self setTableViewController:[[SCEFeedTableViewController alloc]
                                  initWithCellNibName:tableCellNibName
                                  feedController:self]];
    [self setMapViewController:[[SCEFeedMapViewController alloc] init]];
    
#warning This is a temporary hack to get the default table mode to register (does nothing in init)
    [self setViewMode:SCEFeedViewModeTable];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setViewMode:(SCEFeedViewMode)mode
{
    if (mode == [self viewMode] && contentViewController) {
        return;
    }
    viewMode = mode;

    UIViewController *oldContentViewController = contentViewController;

    if (viewMode == SCEFeedViewModeTable) {
        contentViewController = [self tableViewController];
    }
    else if (viewMode == SCEFeedViewModeMap) {
        contentViewController = [self mapViewController];
    }
    else {
        [NSException exceptionWithName:@"Invalid view mode"
                                reason:@"supplied mode constant is unsupported"
                              userInfo:nil];
    }

#warning Pretty ugly stuff here. Look into combining both descendant settings as well as the TODO notes
    NSArray *origSubviews = [[self view] subviews]; // should only be one
    
    // replace the view controllers
    // TODO: Could be better to just have both on the stack and show/hide?
    [self addChildViewController:contentViewController];

    // add the new content view and remove the old
    // TODO: probably better to handle this with view tags (especially if we put in a header subview)
    [[self view] addSubview:[contentViewController view]];

    // remove the old subview, if it exists
    [oldContentViewController removeFromParentViewController];
    for (UIView *subview in origSubviews) {
        [subview setHidden:YES];
        [subview removeFromSuperview];
    }
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
                                                    action:@selector(searchFeed:)];
    [[self navigationItem] setRightBarButtonItem:btn];
}

// TODO: customize in subviews
- (void)searchFeed:(id)sender
{
    NSLog(@"Search!");
}

- (void)toggleViewMode:(id)sender
{
    NSLog(@"Toggling!");
    if (viewMode == SCEFeedViewModeMap) {
        [self setViewMode:SCEFeedViewModeTable];
        // TODO: also toggle button title
    }
    else {
        // TODO: also toggle button title
        [self setViewMode:SCEFeedViewModeMap];
    }
}


@end
