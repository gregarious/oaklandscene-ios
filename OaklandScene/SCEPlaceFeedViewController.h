//
//  SCEPlacesFeedViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

@class SCEPlaceStore;

#import "SCEFeedViewController.h"
#import "SCEFeedSearchDelegate.h"

@interface SCEPlaceFeedViewController : SCEFeedViewController
            <UITableViewDataSource, UITableViewDelegate, SCEFeedSearchDelegate>
{
    NSMutableArray *displayedItems; // the currently displayed feed items
    NSArray *feedPlaces; // all items in feed (could be hidden behind "Load more" prompts
}

@property (nonatomic, strong) SCEPlaceStore *contentStore;

- (void)resetFeedContent;

- (void)resetPaging;
- (void)showNextPage;

- (void)filterFeedContentByCategoryId:(NSInteger)categoryId;
- (void)emptyFeedWithLoadingMessage:(BOOL)loadingMessage;

@end
