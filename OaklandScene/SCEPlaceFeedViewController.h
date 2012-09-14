//
//  SCEPlacesFeedViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEFeedViewController.h"
#import "SCEPlaceStore.h"



@interface SCEPlaceFeedViewController : SCEFeedViewController
                                        <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *feedItems; // the currently displayed feed items
}

@property (nonatomic, strong) SCEPlaceStore *contentStore;

@end
