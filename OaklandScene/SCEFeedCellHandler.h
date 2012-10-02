//
//  SCEFeedCellHandler.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/2/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCEFeedCellHandler <NSObject>

- (UITableViewCell *)feedView:(SCEFeedView *)feedView
             tableCellForItem:(id)item;

- (CGFloat)feedView:(SCEFeedView *)feedView
tableCellHeightForItem:(id)item;

- (void)feedView:(SCEFeedView *)feedView
   didSelectItem:(id)item;

@end
