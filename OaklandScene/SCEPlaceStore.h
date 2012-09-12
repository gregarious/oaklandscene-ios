//
//  SCEPlaceStore.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface SCEPlaceStore : NSObject

@property (nonatomic, copy) NSArray* places;

// wait for cache support to implement this
//@property (nonatomic, readonly) NSDate* lastSuccessfulFetch;

+ (SCEPlaceStore *)sharedStore; // overrides base return type
- (void)fetchContentWithCompletion:(void (^)(NSArray *items, NSError *err))block;

@end
