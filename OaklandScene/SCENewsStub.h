//
//  SCENewsStub.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCENewsStub : NSObject

// basic text-based variables
@property (nonatomic, copy) NSString* blurb;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* source;
@property (nonatomic, copy) NSString* sourceUrl;
@property (nonatomic, copy) NSString* title;

// key to the main image store
@property (nonatomic, copy) NSString* imageKey;

@end
