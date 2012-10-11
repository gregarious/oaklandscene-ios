//
//  SCEPlace.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlace.h"
#import "SCECategory.h"
#import "SCEURLImage.h"

@implementation SCEPlaceHours

@synthesize days, hours;
- (id)initWithDays:(NSString *)d hours:(NSString *)h
{
    self = [self init];
    if (self) {
        [self setDays:d];
        [self setHours:h];
    }
    return self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    [self setDays:[d objectForKey:@"days"]];
    [self setHours:[d objectForKey:@"hours"]];
}

@end

@implementation SCEPlace

@synthesize resourceId;
@synthesize name, description, phone, url, facebookId, twitterUsername;
@synthesize streetAddress, postalCode, location;
@synthesize imageUrl;
@synthesize categories;
@synthesize events, specials;

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    [self setResourceId:[d objectForKey:@"id"]];

    [self setName:[d objectForKey:@"name"]];
    [self setDescription:[d objectForKey:@"description"]];
    [self setFacebookId:[d objectForKey:@"fb_id"]];
    [self setTwitterUsername:[d objectForKey:@"twitter_username"]];
    [self setPhone:[d objectForKey:@"phone"]];
    [self setUrl:[d objectForKey:@"url"]];
    
    // set up location-related properties
    NSDictionary *locationDict = [d objectForKey:@"location"];
    if (locationDict) {
        [self setStreetAddress:[locationDict objectForKey:@"address"]];
        [self setTown:[locationDict objectForKey:@"town"]];
        [self setPostalCode:[locationDict objectForKey:@"postcode"]];
        [self setState:[locationDict objectForKey:@"state"]];
        [self setCountry:[locationDict objectForKey:@"country"]];
        
        // lat/lng parsing
        id latDec = [locationDict objectForKey:@"latitude"];
        id lngDec = [locationDict objectForKey:@"longitude"];

        if (latDec != [NSNull null] || lngDec != [NSNull null]) {
            [self setLocation:CLLocationCoordinate2DMake([latDec doubleValue], [lngDec doubleValue])];
        }
    }
    
    NSArray *hoursArray = [d objectForKey:@"hours"];
    if (hoursArray) {
        NSMutableArray *hoursObjArray = [NSMutableArray arrayWithCapacity:[hoursArray count]];
        for (NSDictionary *entry in hoursArray) {
            SCEPlaceHours* h = [[SCEPlaceHours alloc] init];
            [h readFromJSONDictionary:entry];
            [hoursObjArray addObject:h];
        }
        [self setHours:hoursObjArray];
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
        if ([self imageUrl]) {
            // fetch into store now (will have no effect if image already stored)
            [[SCEURLImageStore sharedStore] fetchImageWithURLString:[self imageUrl]
                                                       onCompletion:nil];
        }
    }
}

- (NSString *)daddr
{
    NSString *daddr = nil;
    if ([self streetAddress]) {
        if ([self postalCode]) {
            daddr = [NSString stringWithFormat:@"%@, %@",
                     [self streetAddress], [self postalCode]];
        }
        else {
            daddr = [self streetAddress];
        }
    }
    else if ([self location].latitude != 0 && [self location].longitude != 0) {
        daddr = [NSString stringWithFormat:@"(%f,%f)",
                 [self location].latitude, [self location].longitude];
    }
    return daddr;
}

@end
