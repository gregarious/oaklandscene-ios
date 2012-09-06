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

@interface SCEFeedViewController : UIViewController
{
    UIViewController *contentViewController;
}

// designated constructor for this class
-(id)initWithTableCellNibName:(NSString *)cellNibNameOrNil
         mapAnnotationNibName:(NSBundle *)nibBundleOrNil;

enum {
    SCEFeedViewModeTable = 0,
    SCEFeedViewModeMap = 1
};
typedef NSUInteger SCEFeedViewMode;

@property (nonatomic, assign) SCEFeedViewMode viewMode;
@property (nonatomic, strong) SCEFeedTableViewController *tableViewController;
@property (nonatomic, strong) SCEFeedMapViewController *mapViewController;


- (void)searchFeed:(id)sender;
- (void)toggleViewMode:(id)sender;

- (void)addViewToggleButton;
- (void)addSearchButton;

// TODO: decide what the message parameter should be here
- (void)itemSelected;   // Abstract: MUST be implemented in derived class

@end
