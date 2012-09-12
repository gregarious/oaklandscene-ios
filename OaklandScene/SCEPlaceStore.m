//
//  SCEPlaceStore.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlaceStore.h"
#import "SCEPlace.h"
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

- (void)fetchContentWithCompletion:(void (^)(NSArray *, NSError *))block
{
    NSURL *url = [NSURL URLWithString:@"https://www.scenable.com/api/v1/place/?format=json&listed=true"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    SCEAPIConnection *connection = [[SCEAPIConnection alloc] initWithRequest:req];
    [connection setCompletionBlock:block];

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

@end
