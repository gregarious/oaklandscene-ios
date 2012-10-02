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

@interface SCEPlaceFeedViewController : SCEFeedViewController
{
    SCEPlaceStore *contentStore;
}

@end
