//
//  SCEFeedSourceDelegate.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/21/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCEFeedSource;

@protocol SCEFeedSourceDelegate <NSObject>

- (void)feedSourceContentReady:(SCEFeedSource *)feedSource;

- (void)feedSource:(SCEFeedSource *)feedSource
         syncError:(NSError *)err;

@end
