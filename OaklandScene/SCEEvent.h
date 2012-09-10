//
//  SCEEvent.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCEGeocoded.h"
@class SCEPlace;

@interface SCEEvent : NSObject <SCEGeocoded>

// simple string-based properties
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* description;
@property (nonatomic, copy) NSString* url;

// start and end date/time for event
@property (nonatomic, copy) NSDate* startTime;
@property (nonatomic, copy) NSDate* endTime;

// key to the main image store
@property (nonatomic, copy) NSString* imageKey;

// SCEPlace that event is happening at
@property (nonatomic, weak) SCEPlace* place;

// conforms to SCEGeocoded
- (CLLocation *)location;

@end
