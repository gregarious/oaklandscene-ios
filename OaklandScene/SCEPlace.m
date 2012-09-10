//
//  SCEPlace.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlace.h"

@implementation SCEPlace

@synthesize description, phone, url, facebookId, twitterUsername;
@synthesize imageKey;
@synthesize categories;
@synthesize events, specials;

- (CLLocationCoordinate2D *)location
{
    return self.location;
}

@end
