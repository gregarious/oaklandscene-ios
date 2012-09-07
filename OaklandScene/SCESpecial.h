//
//  SCESpecial.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCEGeocoded.h"

@class SCEPlace;

@interface SCESpecial : NSObject <SCEGeocoded>

// simple string-based properties
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* description;

// coupon availability
@property (nonatomic, assign) NSInteger totalAvailable;
@property (nonatomic, assign) NSInteger totalSold;

// start and end date for coupon
@property (nonatomic, copy) NSDate* startDate;
@property (nonatomic, copy) NSDate* expiresDate;

// SCEPlace that special is sponsored by
@property (nonatomic, weak) SCEPlace* place;

- (CLLocation *)location;

@end
