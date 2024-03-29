//
//  SCENewsFeedViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEFeedViewController.h"
#import "SCEFeedViewDataSource.h"

@class SCENewsStore, SCEFeedSource;

@interface SCENewsFeedViewController : SCEFeedViewController
{
    SCENewsStore *contentStore;
    SCEFeedSource *feedSource;
}

@end
