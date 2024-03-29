//
//  SCEPlace.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SCEGeocoded.h"
#import "JSONSerializable.h"

@class SCEEvent;
@class SCESpecial;

// Simple struct-like construct of a single days/hours entry
@interface SCEPlaceHours : NSObject <JSONSerializable>

@property (nonatomic) NSString* days;
@property (nonatomic) NSString* hours;

- (id) initWithDays:(NSString *)d hours:(NSString *)h;
@end

// Main Place class
@interface SCEPlace : NSObject <SCEGeocoded, JSONSerializable>

// id of place object on server
@property (nonatomic, copy) NSString *resourceId;

// basic "Scenable Location" properties
@property (nonatomic, copy) NSString *streetAddress;
@property (nonatomic, copy) NSString *town;
@property (nonatomic, copy) NSString *postalCode;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, assign) CLLocationCoordinate2D location;

// basic string-based items
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *facebookId;
@property (nonatomic, copy) NSString *twitterUsername;

// array of SCEPlaceHours
@property (nonatomic, strong) NSArray *hours;

// url-backed image
@property (nonatomic, strong) NSString *imageUrl;

// array of SCECategory objects
@property (nonatomic, strong) NSArray *categories;

// related objects
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSArray *specials;

// returns the destination address to use in a maps url
- (NSString *)daddr;

@end
