//
//  SCEFeedTableViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCEFeedTableViewController : UITableViewController

- (id) initWithStyle:(UITableViewStyle)style
       cellNibName:(NSString *)cellClass;

// this should be one of the UITableCell-derived classes (e.g. SCEPlaceTableCell)
@property (nonatomic, copy) NSString *cellNibName;

@end
