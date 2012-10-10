//
//  SCESpecialStore.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/3/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCESpecialStore.h"
#import "SCEItemStore.h"

@class SCEEvent;

@interface SCESpecialStore : NSObject <SCEItemStore>
{
    NSMutableDictionary* idSpecialMap;
    NSMutableDictionary* queryResultMap;
}

@property (nonatomic, copy) NSMutableArray* items;
@property (nonatomic, readonly) NSDate* lastSynced;
@property (nonatomic, readonly) NSArray* categories;    // always [] for specials
@property (nonatomic, readonly) BOOL syncInProgress;
// TODO: get rid of categories requirement for SCEItemStore

@end
