//
//  SCESpecial.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCEGeocoded.h"
#import "JSONSerializable.h"

@class SCEPlace, SCEPlaceStore, SCEURLImage;

@interface SCESpecial : NSObject <SCEGeocoded, JSONSerializable>

// simple string-based properties
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* description;

// start and end date for coupon
@property (nonatomic, copy) NSDate* startDate;
@property (nonatomic, copy) NSDate* expiresDate;

// SCEPlace that special is sponsored by
@property (nonatomic, weak) SCEPlace* place;

// used to resolve place id references
@property (nonatomic, weak) SCEPlaceStore *placeStore;

// id of resource on the server
@property (nonatomic, assign) NSString* resourceId;

- (CLLocationCoordinate2D)location;

@end
