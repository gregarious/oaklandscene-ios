//
//  SCEEventStore.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/19/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEEventStore.h"

@implementation SCEEventStore

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

@end
