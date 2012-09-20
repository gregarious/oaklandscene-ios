//
//  SCEFeedSource.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/19/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEFeedSource.h"
#import "SCEPlace.h"    // TODO: remove this

@implementation SCEFeedSource

@synthesize store, items, syncInProgress;
@synthesize filterCategory, filterKeyword, pageLength;

- (id)init
{
    return [self initWithStore:nil];
}

- (id)initWithStore:(SCEPlaceStore *)s
{
    self = [super init];
    if (self) {
        pageLength = 10;
        syncInProgress = false;
        [self setStore:s];
    }
    return self;
}

- (void)setStore:(SCEPlaceStore *)s
{
    store = s;
    if (![store lastPlacesSet]) {
        [store fetchContentWithCompletion:nil];
    }
}

- (void)sync
{
    syncInProgress = true;
    
    // clear items until sync is finished
    items = nil;

    // once the proper items have been retreived, store them and call the completion block
    void (^onSyncComplete)(NSArray *, NSError *) = ^void (NSArray *matches, NSError *err) {
        NSLog(@"Sync complete:");
        if (matches) {
            NSLog(@"  Number of items: %d", [matches count]);
        }
        else {
            NSLog(@"  %@", err);
        }

        items = matches;
        
        if ([self completionBlock]) {
            [self completionBlock](err);
        }
        syncInProgress = false;
    };
    
    // if no filtering, don't bother with asking the store anything special
    if (![self filterCategory] && ![self filterKeyword]) {
        // "sync" never needs to happen, just call directly
        onSyncComplete([[self store] places], nil);
    }
    else {
        // otherwise
        [store findPlacesMatchingQuery:[self filterKeyword]
                              category:[self filterCategory]
                              onReturn:onSyncComplete];
    }
}

- (NSArray*)getPage:(NSInteger)pageNum
{
    // need to guard against out of range errors
    NSInteger offset = MIN(pageNum * [self pageLength], [items count]);
    NSInteger end = MIN(offset + [self pageLength], [items count]);
    NSRange range = NSMakeRange(offset, end-offset);
    return [items subarrayWithRange:range];
}

- (BOOL)hasPage:(NSInteger)pageNum
{
    NSInteger offset = pageNum * [self pageLength];
    return (offset < [items count]);
}

@end
