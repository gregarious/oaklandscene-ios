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
    UIBarButtonItem *labelWrapperButton;
    UIBarButtonItem *spacer;
}

@property (nonatomic, readonly) UIBarButtonItem *categoryButton;
@property (nonatomic, readonly) UIBarButtonItem *reloadButton;
@property (nonatomic, readonly) UILabel *infoLabel;

@property (nonatomic, assign) BOOL showReloadButton;

@end
