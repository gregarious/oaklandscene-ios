//
//  SCENewsTableCell.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/6/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEFeedTableCell.h"

@interface SCENewsTableCell : SCEFeedTableCell

@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;

@end
