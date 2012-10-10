//
//  SCEEventStore.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/19/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCEItemStore.h"

@class SCEEvent;
@class SCECategory;

@interface SCEEventStore : NSObject <SCEItemStore>
{
    NSMutableDictionary* idEventMap;
    NSMutableDictionary* queryResultMap;
}

@property (nonatomic, copy) NSMutableArray* items;
@property (nonatomic, readonly) NSDate* lastSynced;
@property (nonatomic, readonly) NSArray* categories;
@property (nonatomic, readonly) BOOL syncInProgress;

@end
