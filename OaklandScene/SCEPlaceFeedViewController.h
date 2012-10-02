//
//  SCEPlacesFeedViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

@class SCEPlaceStore;

#import "SCEFeedViewDelegate.h"
#import "SCEFeedViewController.h"

// TODO: look into combining the TableViewDataSourceDelegate and the
//       FeedSourceDelegate together as some kind of DI object
@interface SCEPlaceFeedViewController : SCEFeedViewController <SCEFeedViewDelegate>
{
    SCEPlaceStore *contentStore;
}

@property (nonatomic, strong) SCEFeedSource *feedSource;

@end
