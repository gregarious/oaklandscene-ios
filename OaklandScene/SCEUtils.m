//
//  SCEUtils.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/27/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEUtils.h"

@implementation SCEUtils

+ (SCEResolution)screenResolution
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale > 1.0)) {
        NSLog(@"%f", [[UIScreen mainScreen] bounds].size.height);
        if ([[UIScreen mainScreen] bounds].size.height >= 481.0) {   // 480 is 3.5-inch
            return SCEResolutionRetina4;
        }
        else {
            return SCEResolutionRetina3_5;
        }
    } else {
        return SCEResolutionNonRetina;
    }
}

+ (void)logRect:(CGRect)rect withLabel:(NSString *)labelText
{
    NSLog(@"%@: (%f, %f); (%f x %f)", labelText,
          rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

@end
