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

@synthesize places;

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
    }
    return self;
}

// override this to add places to the dict
- (void)setPlaces:(NSArray *)ps
{
    places = [[NSMutableArray alloc] initWithArray:ps];
    
    // reset dictionary
    idPlaceMap = [[NSMutableDictionary alloc] init];
    for (SCEPlace* place in places) {
        [idPlaceMap setObject:place
                       forKey:[place resourceId]];
    }
}

- (void)addPlace:(SCEPlace *)p
{
    [places addObject:p];
    [idPlaceMap setObject:p
                   forKey:[p resourceId]];
}

- (NSArray *)placesWithCategory:(NSInteger)categoryId
{
    NSMutableArray* filteredPlaces = [[NSMutableArray alloc] init];
    for (SCEPlace* place in places) {
        for (SCECategory* c in [place categories]) {
            if ([c value] == categoryId) {
                [filteredPlaces addObject:place];
                break;
            }
        }
    }
    return filteredPlaces;
}

- (void)fetchContentWithCompletion:(void (^)(NSArray *, NSError *))block
{
    NSURL *url = [NSURL URLWithString:@"https://www.scenable.com/api/v1/place/?format=json&listed=true"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    SCEAPIConnection *connection = [[SCEAPIConnection alloc] initWithRequest:req];

    // connection will let this response object interpret the JSON
    SCEAPIResponse *rootJSONObj = [[SCEAPIResponse alloc] init];
    [connection setJsonRootObject:rootJSONObj];
    
    // on completed connection, set the internal place cache and call the given
    // block with the next array of places (or on error, just pass it through)
    [connection setCompletionBlock:
        ^void(SCEAPIResponse *response, NSError *err) {
             if (response) {
                 NSMutableArray *newPlaces = [[NSMutableArray alloc]
                                              initWithCapacity:[[response objects] count]];

                 for (NSDictionary *d in [response objects]) {
                     SCEPlace *p = [[SCEPlace alloc] init];
                     [p readFromJSONDictionary:d];
                     [newPlaces addObject:p];
                 }
                 [self setPlaces:newPlaces];
                 queryResultMap = [[NSMutableDictionary alloc] init];

                 if (block) {
                     block([self places], nil);
                 }
             }
             else {
                 if (block) {
                     block(nil, err);
                 }
             }
        }
     ];
    
    
    [connection start];
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
            filteredPlaces = [[NSMutableArray alloc] init];
            // create a new array of places from the ids returned (in order returned)
            for (NSString* rId in [resp objects]) {
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
        }
    };

    // !!!!! DEBUG: testing out mock API response !!!!!
    SCEAPIResponse* mockResponse = [[SCEAPIResponse alloc] init];
    [mockResponse setObjects:@[@"233", @"400", @"176"]];
    completionBlock(nil, [NSError errorWithDomain:@"Moocow" code:23 userInfo:nil]);
    return;
    
    // finally, set up and initiate the API request
    NSString* urlString = [NSString stringWithFormat:@"https://www.scenable.com/api/v1/place/search/?format=json&listed=true&q=%@", query];
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
