//
//  SCEFeedViewDelegate.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/1/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SCEFeedItemContainer.h"

@protocol SCEFeedViewDelegate <NSObject>

- (UITableViewCell *)tableView:(UITableView *)view
                   cellForItem:(SCEFeedItemContainer *)itemContainer;

- (CGFloat)tableView:(UITableView *)view
       heightForItem:(SCEFeedItemContainer *)itemContainer;


- (void)tableView:(UITableView *)tv didSelectItem:(SCEFeedItemContainer *)itemContainer;
@end
