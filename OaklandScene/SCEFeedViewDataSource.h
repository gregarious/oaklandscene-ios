//
//  SCEFeedViewDataSource.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/2/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class UITableViewCell, SCEFeedView;

@protocol SCEFeedViewDataSource <NSObject>

- (NSInteger)numberOfItemsInFeedView:(SCEFeedView *)feedView;
- (NSInteger)numberOfAnnotationsInFeedView:(SCEFeedView *)feedView;

/*** Table-related methods ***/
- (UITableViewCell *)feedView:(SCEFeedView *)feedView
             tableCellForItem:(NSInteger)itemIndex;

- (id<MKAnnotation>)feedView:(SCEFeedView *)feedView
             annotationForItem:(NSInteger)itemIndex;

/*** Category filter-related methods ***/
- (NSString *)feedView:(SCEFeedView *)feedView
      labelForCategory:(NSInteger)categoryIndex;

- (NSInteger)numberOfCategoriesInFeedView:(SCEFeedView *)feedView;

// returns null if not category is active
// TODO: reaaaaaally hacky here. fix with category logic overhaul
//       this method will call the first category an index 0, but
//       labelForCategory above refers to it by index 1
- (NSNumber *)activeCategoryIndexInFeedView:(SCEFeedView *)feedView;

@end
