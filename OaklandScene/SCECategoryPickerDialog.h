//
//  SCECategoryPickerDialog.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/10/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCECategoryPickerDialog : UIControl

@property (readonly, nonatomic) IBOutlet UIPickerView *picker;
@property (readonly, nonatomic) IBOutlet UIToolbar *toolbar;

- (void)closeAnimationWithBlock:(void (^)(BOOL finished))completion;

@end
