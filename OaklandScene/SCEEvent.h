//
//  SCEEvent.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCEGeocoded.h"
#import "JSONSerializable.h"

@class SCEPlace, SCEPlaceStore;

@interface SCEEvent : NSObject <SCEGeocoded, JSONSerializable>

// id of event object on server
@property (nonatomic, copy) NSString *resourceId;

// simple string-based properties
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* description;
@property (nonatomic, copy) NSString* url;

// start and end date/time for event
@property (nonatomic, copy) NSDate* startTime;
@property (nonatomic, copy) NSDate* endTime;

// url-backed image
@property (nonatomic, strong) NSString *imageUrl;

// One or the other will be non-nil	
@property (nonatomic, copy) NSString *placePrimitive;
@property (nonatomic, weak) SCEPlace *place;

// used to resolve place id references
@property (nonatomic, weak) SCEPlaceStore *placeStore;

// array of SCECategory objects
@property (nonatomic, strong) NSArray *categories;

@end
