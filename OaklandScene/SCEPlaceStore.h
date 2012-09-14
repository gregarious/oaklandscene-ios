//
//  SCEPlaceStore.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@class SCEPlace;

@interface SCEPlaceStore : NSObject
{
    NSMutableDictionary* idPlaceMap;
    NSMutableDictionary* queryResultMap;
}
@property (nonatomic, copy) NSMutableArray* places;

// wait for cache support to implement this
//@property (nonatomic, readonly) NSDate* lastSuccessfulFetch;

+ (SCEPlaceStore *)sharedStore; // overrides base return type

- (void)addPlace:(SCEPlace *)p;
- (void)fetchContentWithCompletion:(void (^)(NSArray *items, NSError *err))block;

// could cause a delay if query needs to defer to server, hence return block
- (void)findPlacesMatchingQuery:(NSString *)query
                       onReturn:(void (^)(NSArray* places, NSError* err))block;

- (NSArray *)placesWithCategory:(NSInteger)categoryId;

@end
