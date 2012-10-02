//
//  SCEFeedCellHandler.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/2/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCEFeedView;

@protocol SCEFeedItemSource <NSObject>

- (UITableViewCell *)feedView:(SCEFeedView *)feedView
             tableCellForItem:(id)item;

- (CGFloat)feedView:(SCEFeedView *)feedView
tableCellHeightForItem:(id)item;

// returns a new VC if the selection should load a new view
- (UIViewController *)feedView:(SCEFeedView *)feedView
   didSelectItem:(id)item;

@end
