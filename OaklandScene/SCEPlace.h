//
//  SCEPlace.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SCEGeocoded.h"

@class SCEEvent;
@class SCESpecial;

@interface SCEPlace : NSObject <SCEGeocoded>

// basic "Scenable Location" properties
@property (nonatomic, copy) NSString *streetAddress;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *postalCode;
@property (nonatomic, assign) CLLocationCoordinate2D *location;

// basic string-based items
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *facebookId;
@property (nonatomic, copy) NSString *twitterUsername;

// key to full image in image store
@property (nonatomic, copy) NSString *imageKey;

// array of SCECategory objects
@property (nonatomic, strong) NSArray *categories;

// related objects
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSArray *specials;

@end
