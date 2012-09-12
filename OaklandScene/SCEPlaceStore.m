//
//  SCEPlaceStore.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlaceStore.h"
#import "SCEPlace.h"

@implementation SCEPlaceStore

@synthesize items;

+ (SCEPlaceStore *)sharedStore
{
    static SCEPlaceStore* staticStore = nil;
    if (!staticStore) {
        staticStore = [[SCEPlaceStore alloc] init];
        
        [staticStore fetchContentWithCompletion:
            ^void(NSArray *places, NSError* err) {
                if (places) {
                    [staticStore setItems:places];
                    NSLog(@"Fetched %d places.", [places count]);
                }
                if (err) {
                    NSLog(@"Error! %@", err);
                }
            }
        ];
    }
    return staticStore;
}

- (void)fetchContentWithCompletion:(void (^)(NSArray *, NSError *))block
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"places"
                                                         ofType:@"json"];

    NSData *rawJSON = [[NSData alloc] initWithContentsOfFile:filePath
                                                      options:NSUTF8StringEncoding
                                                        error:nil];
 
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:rawJSON
                                                         options:0
                                                           error:nil];
    
    NSArray *objects = [root objectForKey:@"objects"];
    if (!objects) {
        if (block) {
            block(nil, [NSError errorWithDomain:@"JSON Deserialization"
                                          code:1
                                      userInfo:nil]);
        }
        return;
    }

    NSMutableArray *places = [[NSMutableArray alloc] initWithCapacity:[objects count]];
    for (NSDictionary *placeDict in objects) {
        SCEPlace *place = [[SCEPlace alloc] init];
        [place readFromJSONDictionary:placeDict];
        [places addObject:place];
    }
    
// wait for cache support to implement these
//    // set the internal set of places and the update time to now
//    items = places;
//    lastSuccessfulFetch = [NSDate date];
    
    if (block) {
        block(places, nil);
    }

    // TODO: will need to store places in here eventually. for now just simple callback with plain data.
}

@end
