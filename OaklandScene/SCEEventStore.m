//
//  SCEEventStore.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/19/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEEventStore.h"
#import "SCEEvent.h"
#import "SCECategory.h"
#import "SCEAPIConnection.h"
#import "SCEAPIResponse.h"

@interface SCEEventStore ()
+ (NSArray *)filter:(NSArray *)objects byCategory:(SCECategory *)category;
@end

@implementation SCEEventStore

@synthesize items, lastSynced, categories;

+ (SCEEventStore *)sharedStore
{
    static SCEEventStore* staticStore = nil;
    if (!staticStore) {
        staticStore = [[SCEEventStore alloc] init];
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
        NSMutableArray* filteredEvents = [[NSMutableArray alloc] init];
        for (SCEEventStore* event in objects) {
            for (SCECategory* c in [event categories]) {
                if ([c value] == filterValue) {
                    [filteredEvents addObject:event];
                    break;
                }
            }
        }
        return [NSArray arrayWithArray:filteredEvents];
    }
    else {
        return objects;
    }
}

- (void)setItems:(NSMutableArray *)events
{
    items = [[NSMutableArray alloc] initWithArray:events];
    lastSynced = [NSDate date];
    
    // reset dictionary and set categories
    idEventMap = [[NSMutableDictionary alloc] init];
    NSMutableSet* categoryIds = [[NSMutableSet alloc] init];
    NSMutableArray* uniqueCategories = [[NSMutableArray alloc] init];
    
    for (SCEEvent* event in events) {
        [idEventMap setObject:event
                       forKey:[event resourceId]];
        
        // add any unseen categories to the list
        for (SCECategory* cat in [event categories]) {
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
    // Disabled API-based Event fetching. Just shipping with bundled content.
    
    // read in raw JSON data and hand it off to a SCEAPIResponse instance to interpret
    // TODO: error handling for NSData and/or JSON read?
    
    NSString* filename = [[NSBundle mainBundle] pathForResource:@"events-10032012"
                                                         ofType:@"json"];
    
    NSData* fileData = [NSData dataWithContentsOfFile:filename];
    NSMutableDictionary *d = [NSJSONSerialization JSONObjectWithData:fileData
                                                             options:0
                                                               error:nil];
    SCEAPIResponse *response = [[SCEAPIResponse alloc] init];
    [response readFromJSONDictionary:d];
    
    // Run through the objects in the API response, interpretting them as Events
    NSMutableArray *newEvents = [[NSMutableArray alloc]
                                    initWithCapacity:[[response objects] count]];
    for (NSDictionary *d in [response objects]) {
        SCEEvent *e = [[SCEEvent alloc] init];
        [e readFromJSONDictionary:d];
        [newEvents addObject:e];
    }
    [self setItems:newEvents];
    
    queryResultMap = [[NSMutableDictionary alloc] init];
    
    if (block) {
        block([self items], nil);
    }
}

- (void)findItemsMatchingQuery:(NSString *)query
                      category:(SCECategory *)category
                      onReturn:(void (^)(NSArray *, NSError *))returnBlock
{
    // first ensure that the events content exists, otherwise this can't be done
    if (!lastSynced) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:@"Event store not initialized" forKey:@"localizedDescription"];
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
        matchingObjects = [SCEEventStore filter:[queryResultMap objectForKey:query]
                                     byCategory:category];
    }
    
    // if we have matching objects already, no API search query was necessary
    if (matchingObjects) {
        matchingObjects = [SCEEventStore filter:matchingObjects
                                     byCategory:category];
        if (returnBlock) {
            returnBlock(matchingObjects, nil);
        }
        return;
    }
    
    // otherwise, we need to make an API request to get the search results
    // set up and initiate the API request
    NSString* urlString = [NSString stringWithFormat:@"http://www.scenable.com/api/v1/event/?format=json&listed=true&q=%@&idonly=true&limit=0", query];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    SCEAPIConnection *connection = [[SCEAPIConnection alloc] initWithRequest:req];
    
    // after fetch, process the results before calling the onReturn block
    [connection setCompletionBlock:^(SCEAPIResponse* resp, NSError *err) {
        NSArray *finalEvents = nil;
        
        // if we get a valid response, take the ids returned and return an events list with only those ids
        if(resp) {
            NSLog(@"Found %d results", [[resp objects] count]);
            NSMutableArray *matchingEvents = [[NSMutableArray alloc] init];
            // create a new array of events from the ids returned (in order returned)
            for (NSDictionary* idObject in [resp objects]) {
                NSString* rId = [idObject objectForKey:@"id"];
                SCEEvent* event = [idEventMap objectForKey:rId];
                if (event) {
                    [matchingEvents addObject:event];
                }
            }
            
            // cache these results before returning
            [queryResultMap setObject:[matchingEvents copy] forKey:query];
            
            // do the category filtering after the caching
            finalEvents = [SCEEventStore filter:matchingEvents byCategory:category];
        }
        if(returnBlock) {
            returnBlock(finalEvents, err);
            NSLog(@"%@", err);
        }
    }];
    
    // connection will let this response object interpret the JSON
    SCEAPIResponse *rootJSONObj = [[SCEAPIResponse alloc] init];
    [connection setJsonRootObject:rootJSONObj];
    [connection start];
    
}

- (SCEEvent *)itemFromResourceId:(NSString *)rId
{
    return [idEventMap objectForKey:rId];
}

@end

/* From old SCEPlaceStore
- (void)fetchContentWithCompletion:(void (^)(NSArray *, NSError *))block
{
    
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8000/api/v1/place/?format=json&listed=true&limit=0"];
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
             lastSuccessfulFetch = [NSDate date];
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
*/
