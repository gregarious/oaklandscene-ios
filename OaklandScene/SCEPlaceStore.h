//
//  SCEPlaceStore.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "JSONSerializable.h"
#import "SCEItemStore.h"

@interface SCEPlaceStore : NSObject <SCEItemStore>
{
    NSMutableDictionary* idPlaceMap;
    NSMutableDictionary* queryResultMap;
}

@property (nonatomic, copy) NSMutableArray* items;
@property (nonatomic, readonly) NSDate* lastSynced;
@property (nonatomic, readonly) NSArray* categories;

@end
