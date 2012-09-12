//
//  SCESpecial.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCESpecial.h"
#import "SCEPlace.h"

@implementation SCESpecial

@synthesize title, description;
@synthesize totalAvailable, totalSold;
@synthesize startDate, expiresDate;
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
