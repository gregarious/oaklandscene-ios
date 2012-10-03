//
//  SCEFeedViewDelegate.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/1/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UITableViewCell, SCEFeedView, SCECategory;

@protocol SCEFeedViewDelegate <NSObject>

/*** Table-related methods ***/
- (CGFloat)feedView:(SCEFeedView *)feedView
    tableCellHeightForItem:(NSInteger)itemIndex;

// return a new VC if the selection should load a new view
- (UIViewController *)feedView:(SCEFeedView *)feedView
    didSelectTableCellForItem:(NSInteger)itemIndex;

/*** Search-related methods ***/
- (void)feedView:(SCEFeedView *)feedView
    didSubmitSearchQuery:(NSString *)queryString;

- (void)didCancelSearchForFeedView:(SCEFeedView *)feedView;


/*** Category filter-related methods ***/
- (void)feedView:(SCEFeedView *)feedView
    didChooseCategoryIndex:(NSInteger)categoryIndex;

@end
