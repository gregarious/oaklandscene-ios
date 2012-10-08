//
//  SCEEvent.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEEvent.h"
#import "SCEPlace.h"
#import "SCEPlaceStore.h"
#import "SCECategory.h"
#import "SCEURLImage.h"
#import "ISO8601DateFormatter.h"

@implementation SCEEvent

// a list of places generated in-place when no instance exists in the place store
static NSMutableArray *generatedPlaces = nil;

@synthesize resourceId, name, description, url;
@synthesize startTime, endTime;
@synthesize imageUrl;
@synthesize place, placePrimitive, placeStore;

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

- (void)dealloc
{
    // if this place was generated in-place during JSON deserialization, release its reference
    if ([self place]) {
        [generatedPlaces removeObject:[self place]];
    }
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    [self setResourceId:[d objectForKey:@"id"]];
        
    [self setName:[d objectForKey:@"name"]];
    [self setDescription:[d objectForKey:@"description"]];
    [self setUrl:[d objectForKey:@"url"]];
    
    // process times
    // TODO: error handling
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    NSDate *start = [formatter dateFromString:[d objectForKey:@"dtstart"]];
    [self setStartTime:start];
    NSDate *end = [formatter dateFromString:[d objectForKey:@"dtend"]];
    [self setEndTime:end];
  
    id placeDict = [d objectForKey:@"place"];
    if (placeDict != [NSNull null]) {
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
    else {
        [self setPlacePrimitive:[d objectForKey:@"place_primitive"]];
    }
    
    // set up categories
    NSArray *categoryData = [d objectForKey:@"categories"];
    NSMutableArray *workingCategories = [[NSMutableArray alloc] initWithCapacity:[categoryData count]];
    for (NSDictionary *catDict in categoryData) {
        NSString *label = [catDict objectForKey:@"label"];
        NSString *value = [catDict objectForKey:@"id"];
        [workingCategories addObject:[[SCECategory alloc] initWithLabel:label
                                                                  value:[value integerValue]]];
    }
    [self setCategories:workingCategories];
    
    // finally the image
    id urlString = [d objectForKey:@"image"];
    if (urlString && urlString != [NSNull null]) {
        [self setImageUrl:urlString];
        // fetch into store now (will have no effect if image already stored)
        [[SCEURLImageStore sharedStore] fetchImageWithURLString:[self imageUrl]
                                                   onCompletion:nil];
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
