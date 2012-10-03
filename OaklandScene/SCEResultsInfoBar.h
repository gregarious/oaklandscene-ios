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
}

@property (nonatomic, readonly) UIBarButtonItem *categoryButton;
@property (nonatomic, readonly) UILabel *infoLabel;

// TODO: suboptimal set up (e.g. only way to hide is to disply first then hide).
//       could use some refactoring.
@property (nonatomic) BOOL hideCategoryButton;

@end
