//
//  SCEFeedViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SCECategoryPickerDelegate.h"
#import "SCEFeedViewDataSource.h"
#import "SCEFeedViewDelegate.h"
#import "SCEMapViewDataSource.h"

@class SCEFeedView, SCEMapView, SCEResultsInfoBar, SCECategoryPickerDialog;

@interface SCEFeedViewController : UIViewController <UISearchBarDelegate,
                                                        UITableViewDataSource,
                                                        UITableViewDelegate,
                                                        SCEMapViewDataSource,
                                                        MKMapViewDelegate,
                                                        UIPickerViewDataSource,
                                                        UIPickerViewDelegate>
{
    // subviews
    UISearchBar *searchBar;
    
    // parent container for feed content subviews
    UIView *contentView;
    UIView *contentSubview; // convenient alias to hold current subview of contentView
    
    // these two feed content subviews displayed mutually-exclusively
    UITableView *tableView;
    SCEMapView *mapView;    // TODO: will probably subview once map mode development happens

    SCECategoryPickerDialog *categoryPickerDialog;
    
    // semi-transparent tappable layer to disable user input when search bar is first responder
    UIControl *contentMaskView;
    
    @protected
    SCEResultsInfoBar *resultsInfoBar;
}

enum {
    SCEContentMaskSourcePicker = 2330,
    SCEContentMaskSourceSearch = 2331
};
typedef NSUInteger SCEContentMaskSource;


enum {
    SCEFeedViewModeTable = 0,
    SCEFeedViewModeMap = 1
};
typedef NSUInteger SCEFeedViewMode;

@property (nonatomic, assign) SCEFeedViewMode viewMode;
@property (nonatomic, weak) id <SCEFeedViewDataSource> dataSource;
@property (nonatomic, weak) id <SCEFeedViewDelegate> delegate;

// NOTE: this must be set before view is loaded
// TODO: fix this behavior?
@property (nonatomic, assign) BOOL showResultsBar;

// see note in SCEFeedView.h
@property (nonatomic, readonly) SCEFeedView *feedViewContainer;

+ (MKCoordinateRegion)defaultDisplayRegion;

- (void)toggleViewMode:(id)sender;

- (void)addViewToggleButton;
- (void)addSearchButton;

// responders to search related events
- (void)enableSearchBar:(id)sender;
- (void)displayPickerDialog:(id)sender;

- (void)disableInterface;
- (void)enableInterface;

- (void)disableContentMask;
- (void)enableContentMask:(NSInteger)viewTag;


@end
