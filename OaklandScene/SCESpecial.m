//
//  SCESpecial.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCESpecial.h"
#import "SCEPlace.h"
#import "SCEPlaceStore.h"
#import "ISO8601DateFormatter.h"

@implementation SCESpecial

@synthesize title, description, resourceId;
@synthesize startDate, expiresDate;
@synthesize place, placeStore;

- (id)init
{
    self = [super init];
    if (self) {
        [self setPlaceStore:[SCEPlaceStore sharedStore]];
    }
    return self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    [self setResourceId:[d objectForKey:@"id"]];
    
    [self setTitle:[d objectForKey:@"title"]];
    [self setDescription:[d objectForKey:@"description"]];
    
    // process dates
    // TODO: error handling
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    NSDate *start = [formatter dateFromString:[d objectForKey:@"dstart"]];
    [self setStartDate:start];
    NSDate *expires = [formatter dateFromString:[d objectForKey:@"dexpires"]];
    [self setExpiresDate:expires];
    
    id placeDict = [d objectForKey:@"place"];
    if (placeDict != [NSNull null]) {
        if ([self placeStore]) {
            NSString *rId = [placeDict objectForKey:@"id"];
            [self setPlace:[[self placeStore] itemFromResourceId:rId]];
        }
    }
}

// to conform to SCEGeocoded
- (CLLocationCoordinate2D)location
{
    if ([self place]) {
        return [[self place] location];
    }
    return CLLocationCoordinate2DMake(0.0, 0.0);
}

@end
