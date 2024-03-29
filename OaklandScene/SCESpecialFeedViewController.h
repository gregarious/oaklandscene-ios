//
//  SCESpecialsFeedViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEFeedViewController.h"

@class SCESpecialStore, SCEFeedSource;

@interface SCESpecialFeedViewController : SCEFeedViewController
{
    SCESpecialStore *contentStore;
    SCEFeedSource *feedSource;
}

@end
