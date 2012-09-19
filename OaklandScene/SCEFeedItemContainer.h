//
//  SCEFeedItemContainer.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/19/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCEFeedItemContainer : NSObject

enum {
    SCEFeedItemTypeLoading = 0,
    SCEFeedItemTypeObject = 1,
    SCEFeedItemTypeButton = 2
};
typedef NSUInteger SCEFeedItemType;

@property (nonatomic, assign) SCEFeedItemType type;
@property (nonatomic, assign) id content;

- (id)initWithContent:(id)c
                 type:(SCEFeedItemType)t;

@end
