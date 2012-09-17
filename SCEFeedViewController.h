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

@interface SCEFeedViewController : UIViewController
{
    UIView *contentView;
    UITableView *tableView;
    UIView *mapView;    // generic UIView until map mode development happens
}

enum {
    SCEFeedViewModeTable = 0,
    SCEFeedViewModeMap = 1
};
typedef NSUInteger SCEFeedViewMode;

@property (nonatomic, assign) SCEFeedViewMode viewMode;

- (void)displaySearchDialog:(id)sender;
- (void)toggleViewMode:(id)sender;

- (void)addViewToggleButton;
- (void)addSearchButton;

@end
