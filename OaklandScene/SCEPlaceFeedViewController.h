//
//  SCEPlacesFeedViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

@class SCEPlaceStore;

#import "SCEFeedViewController.h"
#import "SCEFeedSource.h"
#import "SCEFeedSearchDelegate.h"
#import "SCEFeedSourceDelegate.h"

// TODO: look into combining the TableViewDataSourceDelegate and the
//       FeedSourceDelegate together as some kind of DI object
@interface SCEPlaceFeedViewController : SCEFeedViewController
            <UITableViewDataSource, UITableViewDelegate,
             SCEFeedSearchDelegate, SCEFeedSourceDelegate>
{
    NSMutableArray *displayedItems; // the currently displayed feed items
    SCEPlaceStore *contentStore;
    NSInteger pagesDisplayed;
}

@property (nonatomic, strong) SCEFeedSource *feedSource;

// sets up feedSource with the default settings
- (void)resetFeedSource;

// these methods add items to the displayedItems list, but DO NOT refresh the view
- (void)emptyFeed;
- (void)addNextPageToFeed;
- (void)addStaticMessageToFeed:(NSString *)message;
- (void)addLoadingMessageToFeed;


@end
