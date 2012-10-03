//
//  SCEFeedView.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/2/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

/* Note: this class is currently just a container for subviews
         defined in a FeedViewController. Needed a package to pass
         into FeedViewDelegate/FeedViewDataSource methods, but found
         it tough to figure out where to put everything (e.g. 
         search bar needs to be set up by the controller, seemingly-
         internal subviews like the mask needed to respond to 
         delegate methods). Needed to move on so am leaving it like
         this for now.
 */
@interface SCEFeedView : UIView

@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UIToolbar *resultsInfoBar;

// parent container for feed content subviews
@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *mapView;

@end
