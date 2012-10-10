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

@implementation SCESpecial

@synthesize title, description, resourceId;
@synthesize startDate, expiresDate;
@synthesize place, placeStore;

static NSMutableArray *generatedPlaces = nil;

- (id)init
{
    self = [super init];
    if (self) {
        [self setPlaceStore:[SCEPlaceStore sharedStore]];
    }
    if (!generatedPlaces) {
        generatedPlaces = [NSMutableArray array];
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
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"YYYY-MM-dd"];
    
    id data = [d objectForKey:@"dstart"];
    if (data != [NSNull null]) {
        [self setStartDate:[fmt dateFromString:data]];
    }
    
    data = [d objectForKey:@"dexpires"];
    if (data != [NSNull null]) {
        [self setExpiresDate:[fmt dateFromString:data]];
    }
    
    id placeDict = [d objectForKey:@"place"];
    if (placeDict != [NSNull null]) {
        // try to retreive the place from a shared store
        // if that fails, create one on the spot from the given information
        SCEPlace *p;
        if ([self placeStore]) {
            NSString *rId = [placeDict objectForKey:@"id"];
            p = [[self placeStore] itemFromResourceId:rId];
        }
        if (!p) {
            p = [[SCEPlace alloc] init];
            [p readFromJSONDictionary:placeDict];
            [generatedPlaces addObject:p];  // rescue this new object from ARC
        }
        [self setPlace:p];
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
