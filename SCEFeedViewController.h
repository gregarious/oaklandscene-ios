//
//  SCEFeedViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCESearchDialogDelegate.h"

@class SCEFeedTableViewController;
@class SCEFeedMapViewController;
@class SCEContentStore;

@interface SCEFeedViewController : UIViewController <SCESearchDialogDelegate>
{
    UIView *contentView;
    UITableView *tableView;
    // generic UIView until map mode development happens
    UIView *mapView;
}

enum {
    SCEFeedViewModeTable = 0,
    SCEFeedViewModeMap = 1
};
typedef NSUInteger SCEFeedViewMode;

@property (nonatomic, assign) SCEFeedViewMode viewMode;

- (void)searchFeed:(id)sender;
- (void)toggleViewMode:(id)sender;

- (void)addViewToggleButton;
- (void)addSearchButton;

@end
