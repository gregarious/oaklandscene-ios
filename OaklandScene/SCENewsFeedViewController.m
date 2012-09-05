//
//  SCENewsFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCENewsFeedViewController.h"

@implementation SCENewsFeedViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setTitle:@"News"];
        // TODO: other type-specific initialization
        // TODO: release the map controller child: unnecessary for this vc
    }
    
    return self;
}


- (void) setViewMode:(NSUInteger)viewMode
{
    if (viewMode != SCEFeedViewModeTable) {
        @throw [NSException exceptionWithName:@"Invalid view mode"
                                       reason:@"only SCEFeedViewModelTable is supported for news feeds"
                                    userInfo:nil];
    }
    [super setViewMode:viewMode];
}
// TODO: other type-specific configuration methods

@end
