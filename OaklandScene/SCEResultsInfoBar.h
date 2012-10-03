//
//  SCEResultsInfoBar.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/2/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIToolbar, UIBarButtonItem, UILabel;

@interface SCEResultsInfoBar : UIView
{
    UIToolbar *toolbar;
}

@property (nonatomic, readonly) UIBarButtonItem *categoryButton;
@property (nonatomic, readonly) UILabel *infoLabel;

@end
