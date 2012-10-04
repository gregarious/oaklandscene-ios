//
//  SCESpecialTableCell.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/6/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEFeedTableCell.h"

@interface SCESpecialTableCell : SCEFeedTableCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiresLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;

@end
