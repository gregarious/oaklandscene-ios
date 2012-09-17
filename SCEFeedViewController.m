//
//  SCEFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEFeedViewController.h"
#import "SCEFeedSearchDialogController.h"

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

-(void)loadView
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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setView:nil];
    tableView = nil;
    mapView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setViewMode:(SCEFeedViewMode)mode
{
    viewMode = mode;
//    UIView *old = contentView;
    
    if (viewMode == SCEFeedViewModeTable) {
        contentView = tableView;
    }
    else if (viewMode == SCEFeedViewModeMap) {
        contentView = mapView;
    }
    else {
        [NSException exceptionWithName:@"Invalid view mode"
                                reason:@"supplied mode constant is unsupported"
                              userInfo:nil];
    }
    [self setView:contentView];
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
                                                    action:@selector(displaySearchDialog:)];
    [[self navigationItem] setRightBarButtonItem:btn];
}

- (void)displaySearchDialog:(id)sender
{
    SCEFeedSearchDialogController *dialog = [[SCEFeedSearchDialogController alloc] init];
    [self presentModalViewController:dialog animated:YES];
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
