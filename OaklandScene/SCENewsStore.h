//
//  SCENewsStore.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/6/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCEItemStore.h"

@interface  SCENewsStore : NSObject <SCEItemStore>
{
    NSMutableDictionary* idNewsStubMap;
}

@property (nonatomic, copy) NSMutableArray* items;
@property (nonatomic, readonly) NSDate* lastSynced;
@property (nonatomic, readonly) NSArray* categories;
@property (nonatomic, readonly) BOOL syncInProgress;
@end