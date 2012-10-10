//
//  SCEItemStore.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/3/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCECategory;

@protocol SCEItemStore <NSObject>

@property (nonatomic, copy) NSMutableArray* items;
@property (nonatomic, readonly) NSDate* lastSynced;
@property (nonatomic, readonly) BOOL syncInProgress;
@property (nonatomic, readonly) NSArray* categories;

+ (id)sharedStore;

- (void)syncContentWithCompletion:(void (^)(NSArray *items, NSError *err))block;

// could cause a delay if query needs to defer to server, hence return block
- (void)findItemsMatchingQuery:(NSString *)query
                      category:(SCECategory *)category
                      onReturn:(void (^)(NSArray* items, NSError* err))block;

- (BOOL)isLoaded;

- (id)itemFromResourceId:(NSString *)rId;


@end
