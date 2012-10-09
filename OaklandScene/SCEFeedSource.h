//
//  SCEFeedSource.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/19/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCEFeedViewDelegate.h"
#import "SCEFeedViewDataSource.h"
#import "SCEFeedItemSource.h"
#import "SCEItemStore.h"

@class SCECategory, SCEPlaceStore, SCEFeedStaticCell, SCEFeedLoadingCell;

/* SCEFeedSource:
 
 Serves as both the SCEFeedDelegate and SCEFeedDataSource for the
 SCEFeedViewController. Handles store management, acting on FeedView
 events, filtering results, pagination, and more.
*/
@interface SCEFeedSource : NSObject <SCEFeedViewDelegate, SCEFeedViewDataSource>
{
    NSRange shownItemRange;
    SCEFeedStaticCell *showMoreCell;
    SCEFeedLoadingCell *loadingCell;

    id statusCell;
    
    BOOL syncInProgress;
    
    // protected backing object for sake of PlaceFeedSource item setting
    @protected
    NSArray *_items;
}

@property (nonatomic) id <SCEItemStore> store; // TODO: make a generic store

@property (nonatomic, readonly) NSArray* items;

@property (nonatomic) SCECategory* filterCategory;
@property (nonatomic) NSString* filterKeyword;

@property (nonatomic) NSInteger pageLength;

@property (nonatomic) id <SCEFeedItemSource> itemSource;

- (id)initWithStore:(id <SCEItemStore>)s;

- (void)syncWithCompletion:(void (^)(NSError *err))block;

@end
