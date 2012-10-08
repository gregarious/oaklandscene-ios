//
//  SCENewsStubView.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCENewsStubView : UIView
{
    UILabel *staticSourceLabel;  // simple "Source: " label
    CGFloat lastSubviewBottomYPos;
}

@property (nonatomic, readonly) UILabel *headlineLabel;
@property (nonatomic, readonly) UILabel *sourceNameLabel;
@property (nonatomic, readonly) UILabel *publicationDateLabel;

@property (nonatomic, readonly) UIButton *openSourceButton;
@property (nonatomic, readonly) UILabel *blurbLabel;

@end
