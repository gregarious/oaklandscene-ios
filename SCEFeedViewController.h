//
//  SCEFeedViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCEFeedTableViewController;
@class SCEFeedMapViewController;
@class SCEContentStore;

@interface SCEFeedViewController : UIViewController <UISearchBarDelegate>
{
    // subviews
    UISearchBar *searchBar;
    UIToolbar *resultsInfoBar;
    
    // parent container for feed content subviews
    UIView *contentView;
    UIView *contentSubview; // convenient alias to hold current subview of contentView
    
    // these two feed content subviews displayed mutually-exclusively
    UITableView *tableView;
    UIView *mapView;    // TODO: will probably subview once map mode development happens

    // semi-transparent tappable layer to disable user input when search bar is first responder
    UIControl *contentMaskView;
}

enum {
    SCEFeedViewModeTable = 0,
    SCEFeedViewModeMap = 1
};
typedef NSUInteger SCEFeedViewMode;

@property (nonatomic, assign) SCEFeedViewMode viewMode;

// responders to search related events
- (void)enableSearchBar:(id)sender;

- (void)toggleViewMode:(id)sender;

// TODO: to be removed
- (void)displaySearchDialog:(id)sender;

- (void)addViewToggleButton;
- (void)addSearchButton;

@end
