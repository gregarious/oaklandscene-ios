//
//  SCEUtils.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/27/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEUtils.h"

@implementation SCEUtils

+ (void)logRect:(CGRect)rect withLabel:(NSString *)labelText
{
    NSLog(@"%@: (%f, %f); (%f x %f)", labelText,
          rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

@end
