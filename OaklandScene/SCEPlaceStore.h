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
@class SCECategory;

@interface SCEPlaceStore : NSObject
{
    NSMutableDictionary* idPlaceMap;
    NSMutableDictionary* queryResultMap;
}
@property (nonatomic, copy) NSMutableArray* places;
@property (nonatomic, readonly) NSDate* lastPlacesSet;
@property (nonatomic, readonly) NSArray* categories;

+ (SCEPlaceStore *)sharedStore; // overrides base return type

- (void)fetchContentWithCompletion:(void (^)(NSArray *items, NSError *err))block;

// could cause a delay if query needs to defer to server, hence return block
- (void)findPlacesMatchingQuery:(NSString *)query
                       category:(SCECategory *)category
                       onReturn:(void (^)(NSArray* places, NSError* err))block;

@end
