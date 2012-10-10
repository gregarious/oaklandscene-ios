//
//  SCEUtils.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/27/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIView;

@interface SCEUtils : NSObject

typedef enum {
    SCEResolutionNonRetina = 0,
    SCEResolutionRetina3_5 = 1,
    SCEResolutionRetina4 = 2
} SCEResolution;

+ (SCEResolution)screenResolution;
+ (void)logRect:(CGRect)rect withLabel:(NSString *)labelText;

@end
