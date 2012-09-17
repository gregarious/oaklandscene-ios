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
    NSArray *feedItems; // the currently displayed feed items
}

@property (nonatomic, strong) SCEPlaceStore *contentStore;

- (void)resetFeedContent;
- (void)filterFeedContentByCategoryId:(NSInteger)categoryId;

@end
