//
//  SCEAPIResponse.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/12/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface SCEAPIResponse : NSObject <JSONSerializable>

@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) NSURL *nextURL;
@property (nonatomic, strong) NSURL *previousURL;

@property (nonatomic, strong) NSArray *objects;

@end
