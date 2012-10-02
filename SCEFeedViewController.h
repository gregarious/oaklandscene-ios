//
//  SCEFeedViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCECategoryPickerDelegate.h"
#import "SCEFeedSourceDelegate.h"
#import "SCEFeedViewDelegate.h"

@class SCEFeedTableViewController;
@class SCEFeedMapViewController;
@class SCEContentStore;
@class SCEFeedSource;
@class SCECategoryPickerDialogController;

@interface SCEFeedViewController : UIViewController <UISearchBarDelegate,
                UITableViewDataSource, UITableViewDelegate,
                SCEFeedSourceDelegate, SCECategoryPickerDelegate>
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
    
    NSMutableArray *displayedItems; // the currently displayed feed items
    NSInteger pagesDisplayed;
}

enum {
    SCEFeedViewModeTable = 0,
    SCEFeedViewModeMap = 1
};
typedef NSUInteger SCEFeedViewMode;

@property (nonatomic, assign) SCEFeedViewMode viewMode;
@property (nonatomic, strong) SCEFeedSource *feedSource;
@property (nonatomic, strong) id <SCEFeedViewDelegate> delegate;

// responders to search related events
- (void)enableSearchBar:(id)sender;

- (void)toggleViewMode:(id)sender;

- (void)displayFilterDialog:(id)sender;

- (void)addViewToggleButton;
- (void)addSearchButton;

// these methods add items to the displayedItems list, but DO NOT refresh the view
- (void)emptyFeed;
- (void)addNextPageToFeed;
- (void)addStaticMessageToFeed:(NSString *)message;
- (void)addLoadingMessageToFeed;


@end
