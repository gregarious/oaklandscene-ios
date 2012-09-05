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

// Designated constructor
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTableViewController:[[SCEFeedTableViewController alloc]
                                      initWithStyle:UITableViewStylePlain
                                      cellNibName:@"SCEPlaceTableCell"]];
        [self setMapViewController:[[SCEFeedMapViewController alloc] init]];

        // default to table mode
        [self setViewMode:SCEFeedViewModeTable];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

// TODO: customize in subviews
- (void)searchFeed:(id)sender
{
    NSLog(@"Search!");
}

- (void)toggleViewMode:(id)sender
{
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
