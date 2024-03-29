//
//  SCEFeedCellHandler.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/2/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class SCEFeedView;

@protocol SCEFeedItemSource <NSObject>

- (UITableViewCell *)feedView:(SCEFeedView *)feedView
             tableCellForItem:(id)item;

- (id<MKAnnotation>)feedView:(SCEFeedView *)feedView
         annotationForItem:(id)item;

- (CGFloat)feedView:(SCEFeedView *)feedView
tableCellHeightForItem:(id)item;

// returns a new VC if the selection should load a new view
- (UIViewController *)feedView:(SCEFeedView *)feedView
   didSelectItem:(id)item;

- (NSString *)defaultCategoryLabelForFeedView:(SCEFeedView *)feedView;

@end
