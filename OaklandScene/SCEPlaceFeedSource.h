//
//  SCEPlaceFeedSource.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/9/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEFeedSource.h"

@class SCEPlace;
@class SCECategory;

@interface SCEAnchoredPlaceItem : NSObject

@property (nonatomic) SCEPlace *place;
@property (nonatomic) CLLocationDistance distance;

- initWithPlace:(SCEPlace *)place anchor:(CLLocationCoordinate2D)coordinate;

@end


@interface SCEPlaceFeedSource : SCEFeedSource

@property (nonatomic, assign) CLLocationCoordinate2D anchorCoordinate;

- (void)sortItems;

@end
