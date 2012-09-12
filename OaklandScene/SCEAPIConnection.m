//
//  SCEAPIConnection.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/12/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEAPIConnection.h"

@implementation SCEAPIConnection

- (id)initWithRequest:(NSURLRequest *)r
{
    self = [super init];
    if (self) {
        [self setRequest:r];
    }
    return self;
}

// defer to designated initializer
- (id)init
{
    return [self initWithRequest:nil];
}

- (void)start
{
    
}

@end
