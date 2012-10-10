//
//  SCEFeaturedImage.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/10/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@class SCEURLImage;

@interface SCEFeaturedImage : NSObject <JSONSerializable>

@property (nonatomic, copy) NSString *caption;
@property (nonatomic) SCEURLImage *urlImage;

@end
