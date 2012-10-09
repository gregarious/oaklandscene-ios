//
//  SCEPlacesFeedViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SCEFeedViewController.h"

@class SCEPlaceStore, SCEPlaceFeedSource;

@interface SCEPlaceFeedViewController : SCEFeedViewController <CLLocationManagerDelegate>
{
    SCEPlaceStore *contentStore;
    CLLocationManager *locationManager;
}

@end
