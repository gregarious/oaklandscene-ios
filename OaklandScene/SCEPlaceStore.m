//
//  SCEPlaceStore.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlaceStore.h"
#import "SCEPlace.h"

@implementation SCEPlaceStore

+ (SCEPlaceStore *)sharedStore
{
    static SCEPlaceStore* staticStore = nil;
    if (!staticStore) {
        staticStore = [[SCEPlaceStore alloc] init];
        
        [staticStore fetchContentWithCompletion:
            ^void(NSArray *places, NSError* err) {
                [staticStore setItems:places];
                NSLog(@"Fetched %d places.", [places count]);
            }
        ];
    }
    return staticStore;
}

- (void)fetchContentWithCompletion:(void (^)(NSArray *, NSError *))block
{
    SCEPlace *p1 = [[SCEPlace alloc] init];
    [p1 setName:@"Some Place"];

    SCEPlace *p2 = [[SCEPlace alloc] init];
    [p2 setName:@"Another Place"];

    SCEPlace *p3 = [[SCEPlace alloc] init];
    [p3 setName:@"This Place"];

    NSArray *places = @[p1, p2, p3];

    // TODO: will need to store places in here eventually. for now just simple callback with plain data.
    if (block) {
        block(places, nil);
    }
}

@end
