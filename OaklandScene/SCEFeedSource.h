//
//  SCEFeedSource.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/19/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO: make this a more general store object
#import "SCEPlaceStore.h"
#import "SCECategory.h"

@interface SCEFeedSource : NSObject

@property (nonatomic) SCEPlaceStore* store;
@property (nonatomic, readonly) NSArray* items;
@property (nonatomic, readonly) BOOL syncInProgress;

@property (nonatomic) SCECategory* filterCategory;
@property (nonatomic) NSString* filterKeyword;

@property (nonatomic) NSInteger pageLength;

@property (nonatomic, copy) void (^completionBlock)(NSError *);

- (id)initWithStore:(SCEPlaceStore*)s;

- (void)sync;

// returns the 0-indexes page of results (depends on pageLength)
- (NSArray*)getPage:(NSInteger)pageNum;

- (BOOL)hasPage:(NSInteger)pageNum;

@end
