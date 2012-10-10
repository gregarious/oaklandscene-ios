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

@interface SCEPlaceStore ()
+ (NSArray *)filter:(NSArray *)objects byCategory:(SCECategory *)category;
@end

@implementation SCEPlaceStore

@synthesize items, lastSynced, categories, syncInProgress;

+ (SCEPlaceStore *)sharedStore
{
    static SCEPlaceStore* staticStore = nil;
    if (!staticStore) {
        staticStore = [[SCEPlaceStore alloc] init];
    }
    return staticStore;
}

- (BOOL)isLoaded
{
    return ([self lastSynced] != nil);
}

// "private" method for filtering categories
+ (NSArray *)filter:(NSArray *)objects byCategory:(SCECategory *)category
{
    if (category) {
        NSInteger filterValue = [category value];
        NSMutableArray* filteredPlaces = [[NSMutableArray alloc] init];
        for (SCEPlace* place in objects) {
            for (SCECategory* c in [place categories]) {
                if ([c value] == filterValue) {
                    [filteredPlaces addObject:place];
                    break;
                }
            }
        }
        return [NSArray arrayWithArray:filteredPlaces];
    }
    else {
        return objects;
    }
}

- (void)setItems:(NSMutableArray *)places
{
    items = [[NSMutableArray alloc] initWithArray:places];
    
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

- (void)syncContentWithCompletion:(void (^)(NSArray *, NSError *))block
{
    syncInProgress = YES;
    
    // Disabled API-based Place fetching. Just shipping with bundled content.
    // See 61258b0aa70be0111a337b6e566fde96d3cda390 for old version
    
    // read in raw JSON data and hand it off to a SCEAPIResponse instance to interpret
    // TODO: error handling for NSData and/or JSON read?
    
    NSString* filename = [[NSBundle mainBundle] pathForResource:@"places-10032012"
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
    [self setItems:newPlaces];
    lastSynced = [NSDate date];
    
    queryResultMap = [[NSMutableDictionary alloc] init];

    if (block) {
        block([self items], nil);
        syncInProgress = NO;
    }
}

- (void)findItemsMatchingQuery:(NSString *)query
                      category:(SCECategory *)category
                      onReturn:(void (^)(NSArray *, NSError *))returnBlock
{
    // first ensure that the places content exists, otherwise this can't be done
    if (!lastSynced) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:@"Place store not initialized" forKey:@"localizedDescription"];
        returnBlock(nil, [NSError errorWithDomain:@"Store not synced"
                                             code:1
                                         userInfo:nil]);
        return;
    }
    
    NSArray *matchingObjects = nil;

    // if query is nil,
    if (!query) {
        matchingObjects = [self items];
    }
    else if([queryResultMap objectForKey:query]) {
        matchingObjects = [SCEPlaceStore filter:[queryResultMap objectForKey:query]
                                     byCategory:category];
    }
    
    // if we have matching objects already, no API search query was necessary
    if (matchingObjects) {
        matchingObjects = [SCEPlaceStore filter:matchingObjects
                                     byCategory:category];
        if (returnBlock) {
            returnBlock(matchingObjects, nil);
        }
        return;
    }
    
    // otherwise, we need to make an API request to get the search results
    // set up and initiate the API request
    NSString* urlString = [NSString stringWithFormat:@"http://www.scenable.com/api/v1/place/?format=json&listed=true&q=%@&idonly=true&limit=0", query];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    SCEAPIConnection *connection = [[SCEAPIConnection alloc] initWithRequest:req];
    
    // after fetch, process the results before calling the onReturn block
    [connection setCompletionBlock:^(SCEAPIResponse* resp, NSError *err) {
        NSArray *finalPlaces = nil;
        
        // if we get a valid response, take the ids returned and return a places list with only those ids
        if(resp) {
            NSLog(@"Found %d results", [[resp objects] count]);
            NSMutableArray *matchingPlaces = [[NSMutableArray alloc] init];
            // create a new array of places from the ids returned (in order returned)
            for (NSDictionary* idObject in [resp objects]) {
                NSString* rId = [idObject objectForKey:@"id"];
                SCEPlace* place = [idPlaceMap objectForKey:rId];
                if (place) {
                    [matchingPlaces addObject:place];
                }
            }
            
            // cache these results before returning
            [queryResultMap setObject:[matchingPlaces copy] forKey:query];
            
            // do the category filtering after the caching
            finalPlaces = [SCEPlaceStore filter:matchingPlaces byCategory:category];
        }
        if(returnBlock) {
            returnBlock(finalPlaces, err);
            NSLog(@"%@", err);
        }
    }];
    
    // connection will let this response object interpret the JSON
    SCEAPIResponse *rootJSONObj = [[SCEAPIResponse alloc] init];
    [connection setJsonRootObject:rootJSONObj];
    [connection start];
    
}

- (SCEPlace *)itemFromResourceId:(NSString *)rId
{
    return [idPlaceMap objectForKey:rId];
}



@end
