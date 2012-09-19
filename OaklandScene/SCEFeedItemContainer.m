//
//  SCEFeedItemContainer.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/19/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEFeedItemContainer.h"

@implementation SCEFeedItemContainer

@synthesize type, content;

- (id)initWithContent:(id)c type:(SCEFeedItemType)t
{
    self = [super init];
    if (self) {
        [self setContent:c];
        [self setType:t];
    }
    return self;
}

@end
