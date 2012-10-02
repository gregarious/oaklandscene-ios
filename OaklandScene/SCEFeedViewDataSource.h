//
//  SCEFeedViewDataSource.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/2/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UITableViewCell, SCEFeedView;

@protocol SCEFeedViewDataSource <NSObject>

- (NSInteger)numberOfItemsInFeedView:(SCEFeedView *)feedView;

/*** Table-related methods ***/
- (UITableViewCell *)feedView:(SCEFeedView *)feedView
             tableCellForItem:(NSInteger)itemIndex;

/*** Category filter-related methods ***/
- (NSString *)feedView:(SCEFeedView *)feedView
      labelForCategory:(NSInteger)categoryIndex;

- (NSInteger)numberOfCategoriesInFeedView:(SCEFeedView *)feedView;

@end
