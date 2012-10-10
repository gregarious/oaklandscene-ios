//
//  SCENotice.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/10/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface SCENotice : NSObject<JSONSerializable>

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSDate *dtcreated;
@end
