//
//  SCEPlaceStore.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlaceStore.h"
#import "SCEPlace.h"
#import "SCECategory.h"
#import "SCEAPIConnection.h"
#import "SCEAPIResponse.h"

@implementation SCEPlaceStore

@synthesize places, lastSuccessfulFetch, categories;

+ (SCEPlaceStore *)sharedStore
{
    static SCEPlaceStore* staticStore = nil;
    if (!staticStore) {
        staticStore = [[SCEPlaceStore alloc] init];
    }
    return staticStore;
}

- (id)init{
    self = [super init];
    if (self) {
        idPlaceMap = [[NSMutableDictionary alloc] init];
        queryResultMap = [[NSMutableDictionary alloc] init];
        places = [[NSMutableArray alloc] init];
        categories = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setPlaces:(NSArray *)ps
{
    places = [[NSMutableArray alloc] initWithArray:ps];
    
    // reset dictionary and set categories
    idPlaceMap = [[NSMutableDictionary alloc] init];
    NSMutableSet* categoryIds = [[NSMutableSet alloc] init];
    NSMutableArray* uniqueCategories = [[NSMutableArray alloc] init];
    
    for (SCEPlace* place in places) {
        [idPlaceMap setObject:place
                       forKey:[place resourceId]];

        // add any unseen categories to the list
        for (SCECategory* cat in [place categories]) {
            NSNumber *nId = [NSNumber numberWithInteger:[cat value]];
            if (![categoryIds containsObject:nId])
            {
                [categoryIds addObject:nId];
                [uniqueCategories addObject:cat];
            }
        }
    }
    categories = [NSArray arrayWithArray:uniqueCategories];
}

- (void)fetchContentWithCompletion:(void (^)(NSArray *, NSError *))block
{
    // Disabled API-based Place fetching. Just shipping with bundled content.
    // See 61258b0aa70be0111a337b6e566fde96d3cda390 for old version
    
    // read in raw JSON data and hand it off to a SCEAPIResponse instance to interpret
    // TODO: error handling for NSData and/or JSON read?
    
    NSString* filename = [[NSBundle mainBundle] pathForResource:@"places-09192012"
                                                         ofType:@"json"];
    NSData* fileData = [NSData dataWithContentsOfFile:filename];
    NSMutableDictionary *d = [NSJSONSerialization JSONObjectWithData:fileData
                                                             options:0
                                                               error:nil];
    SCEAPIResponse *response = [[SCEAPIResponse alloc] init];
    [response readFromJSONDictionary:d];

    // Run through the objects in the API response, interpretting them as Places
    NSMutableArray *newPlaces = [[NSMutableArray alloc]
                                  initWithCapacity:[[response objects] count]];
    for (NSDictionary *d in [response objects]) {
        SCEPlace *p = [[SCEPlace alloc] init];
        [p readFromJSONDictionary:d];
        [newPlaces addObject:p];
    }
    [self setPlaces:newPlaces];
    lastSuccessfulFetch = [NSDate date];
    queryResultMap = [[NSMutableDictionary alloc] init];

    if (block) {
        block([self places], nil);
    }
}

- (void)findPlacesMatchingQuery:(NSString *)query
                       onReturn:(void (^)(NSArray *, NSError *))returnBlock
{
    // look for a cached query so we can skip the API
    NSArray *matchingObjects = [queryResultMap objectForKey:query];
    if (matchingObjects) {
        if (returnBlock) {
            returnBlock(matchingObjects, nil);
        }
        return;
    }

    // otherwise, we need to make an API request to get the search results

    // first: define the block to translate API response to a list of matching places
    void (^completionBlock)(SCEAPIResponse*, NSError *) = ^(SCEAPIResponse* resp, NSError *err) {
        NSMutableArray* filteredPlaces = nil;
        // if we get a valid response, take the ids returned and return a places list with only those ids
        if(resp) {
            NSLog(@"Found %d results", [[resp objects] count]);
            filteredPlaces = [[NSMutableArray alloc] init];
            // create a new array of places from the ids returned (in order returned)
            for (NSDictionary* idObject in [resp objects]) {
                NSString* rId = [idObject objectForKey:@"id"];
                SCEPlace* place = [idPlaceMap objectForKey:rId];
                if (place) {
                    [filteredPlaces addObject:place];
                }
            }
            
            // cache these results before returning
            [queryResultMap setObject:[filteredPlaces copy] forKey:query];
        }
        if(returnBlock) {
            returnBlock(filteredPlaces, err);
            NSLog(@"%@", err);
        }
    };
    
    // finally, set up and initiate the API request
    NSString* urlString = [NSString stringWithFormat:@"http://127.0.0.1:8000/api/v1/place/?format=json&listed=true&q=%@&idonly=true&limit=0", query];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    SCEAPIConnection *connection = [[SCEAPIConnection alloc] initWithRequest:req];
    [connection setCompletionBlock:completionBlock];
    
    // connection will let this response object interpret the JSON
    SCEAPIResponse *rootJSONObj = [[SCEAPIResponse alloc] init];
    [connection setJsonRootObject:rootJSONObj];
    [connection start];
    
}

@end
