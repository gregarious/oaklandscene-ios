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

@synthesize resourceId, name, description, url;
@synthesize startTime, endTime;
@synthesize urlImage;
@synthesize place, placePrimitive, placeStore;

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
        if ([self placeStore]) {
            NSString *rId = [placeDict objectForKey:@"id"];
            [self setPlace:[[self placeStore] itemFromResourceId:rId]];
        }
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
    id relativePath = [d objectForKey:@"image"];
    if (relativePath && relativePath != [NSNull null]) {
        NSURL *imageUrl = [NSURL URLWithString:relativePath
                                 relativeToURL:[NSURL URLWithString:@"http://www.scenable.com"]];
        
        [self setUrlImage:[[SCEURLImage alloc] initWithUrl:imageUrl]];
        [[self urlImage] fetch];
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
