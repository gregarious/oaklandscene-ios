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

@synthesize viewMode;
@synthesize tableViewController, mapViewController;

// Designated
// Extend this in child classes to also set the cell and annotation Nib names
- (id)initWithTableCellNibName:(NSString *)cellNibNameOrNil
          mapAnnotationNibName:(NSBundle *)nibBundleOrNil
{
    self = [super init];
    if (self) {
        // set up the child view controllers
#warning Container functionality removed for the moment -- needs more research (see notes)
        [self setTableViewController:[[SCEFeedTableViewController alloc]
                                      initWithCellNibName:cellNibNameOrNil
                                      feedController:self]];
//        [self addChildViewController:[self tableViewController]];
//        [tableViewController didMoveToParentViewController:self];
        
        [self setMapViewController:[[SCEFeedMapViewController alloc] init]];
//        [self addChildViewController:[self mapViewController]];
//        [mapViewController didMoveToParentViewController:self];

        [self setViewMode:SCEFeedViewModeTable];
    }
    
    return self;
}

-(void)loadView
{
    [contentViewController loadView];
    [contentViewController viewDidLoad];
    
    // TODO: is this the best way to get the frame?
    CGRect frame = [[[self parentViewController] view] bounds];
    
    UIView *v = [[UIView alloc] initWithFrame:frame];
    [v addSubview:[contentViewController view]];
    [self setView:v];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setView:nil];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setViewMode:(SCEFeedViewMode)mode
{
    viewMode = mode;

    UIViewController *old = contentViewController;
    UIViewController *new = nil;
    
    if (viewMode == SCEFeedViewModeTable) {
        new = [self tableViewController];
    }
    else if (viewMode == SCEFeedViewModeMap) {
        new = [self mapViewController];
    }
    else {
        [NSException exceptionWithName:@"Invalid view mode"
                                reason:@"supplied mode constant is unsupported"
                              userInfo:nil];
    }
    contentViewController = new;
    
    if (old && old != new) {
//        [self transitionFromViewController:old
//                          toViewController:new
//                                  duration:0
//                                   options:UIViewAnimationTransitionNone
//                                animations:nil
//                                completion:nil];
        if ([self isViewLoaded]) {
            // reload the view if it's already been loaded
            [self loadView];
        }
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
    if (viewMode == SCEFeedViewModeMap) {
        [self setViewMode:SCEFeedViewModeTable];
        [[[self navigationItem] leftBarButtonItem] setTitle:@"Map"];
    }
    else {
        [self setViewMode:SCEFeedViewModeMap];
        [[[self navigationItem] leftBarButtonItem] setTitle:@"List"];
    }
}

- (void)itemSelected
{
    @throw [NSException exceptionWithName:@"Pure virtual method called"
                                   reason:@"itemSelected must be implemented by a subclass of SCEFeedViewController"
                                 userInfo:nil];
}

@end
