//
//  SCENewsStub.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface SCENewsStub : NSObject <JSONSerializable>

// basic text-based variables
@property (nonatomic, copy) NSString* blurb;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSDate* publicationDate;

@property (nonatomic, copy) NSString* source;
@property (nonatomic, copy) NSString* sourceUrl;

@property (nonatomic, copy) NSString* resourceId;

@end
