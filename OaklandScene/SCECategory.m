//
//  SCECategory.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCECategory.h"

@implementation SCECategory

@synthesize label, value;

- (id)init
{
    return [self initWithLabel:@"" value:0];
}

// designiated initializer
- (id)initWithLabel:(NSString *)l value:(NSInteger)v
{
    self = [super init];
    if (self) {
        [self setLabel:l];
        [self setValue:v];
    }
    return self;
}

@end
