//
//  SCEEvent.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEEvent.h"
#import "SCEPlace.h"

@implementation SCEEvent

@synthesize name, description, url;
@synthesize startTime, endTime;
@synthesize imageKey;
@synthesize place;

// to conform to SCEGeocoded
- (CLLocationCoordinate2D)location
{
    if ([self place]) {
        return [[self place] location];
    }
    return CLLocationCoordinate2DMake(0.0, 0.0);
}

@end