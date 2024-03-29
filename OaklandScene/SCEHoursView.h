//
//  SCEHoursView.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/24/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCEHoursView : UIView
{
    NSArray *hoursLabels;
    CGFloat lastLabelBottomYPos;

    UILabel *titleLabel;
    UIImageView *clockImage;
}

@property (nonatomic, strong) NSArray *hoursArray;

@end
