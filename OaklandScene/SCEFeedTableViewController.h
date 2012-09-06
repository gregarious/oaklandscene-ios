//
//  SCEFeedTableViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCEFeedViewController;

@interface SCEFeedTableViewController : UITableViewController

- (id) initWithCellNibName:(NSString *)cellNibName
            feedController:(SCEFeedViewController *)controller;

// this should be one of the UITableCell-derived classes (e.g. SCEPlaceTableCell)
@property (copy, nonatomic) NSString *cellNibName;

// back reference to feedViewController for the sake of relaying select messages
@property (weak, nonatomic) SCEFeedViewController *feedViewController;

@end
