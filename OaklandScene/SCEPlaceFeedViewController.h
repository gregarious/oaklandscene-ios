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
    SCEPlaceFeedSource *feedSource;
    CLLocationManager *locationManager;
    NSString *mapResultsBarLabel;
    NSString *tableResultsBarLabel;
}


-(void)refreshMapResults:(id)sender;
-(void)refreshFeedWithCenter:(CLLocationCoordinate2D)coord;

@end
