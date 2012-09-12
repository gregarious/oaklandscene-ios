//
//  SCEPlace.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlace.h"
#import "SCECategory.h"

@implementation SCEPlace

@synthesize name, description, phone, url, facebookId, twitterUsername;
@synthesize streetAddress, postalCode, location;
@synthesize imageKey;
@synthesize categories;
@synthesize events, specials;

- (void)readFromJSONDictionary:(NSDictionary *)d
{
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
        NSDecimalNumber *latDec = [locationDict objectForKey:@"latitude"];
        NSDecimalNumber *lngDec = [locationDict objectForKey:@"longitude"];
        [self setLocation:CLLocationCoordinate2DMake([latDec doubleValue], [lngDec doubleValue])];
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
}

@end
