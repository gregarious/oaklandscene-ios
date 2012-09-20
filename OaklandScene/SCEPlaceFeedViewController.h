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

@interface SCEPlaceFeedViewController : SCEFeedViewController
            <UITableViewDataSource, UITableViewDelegate, SCEFeedSearchDelegate>
{
    NSMutableArray *displayedItems; // the currently displayed feed items
    SCEPlaceStore *contentStore;
    NSInteger pagesDisplayed;
}

@property (nonatomic, strong) SCEFeedSource *feedSource;

- (void)resetFeed;
- (void)addNextPage;

@end
