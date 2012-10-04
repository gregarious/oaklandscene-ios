//
//  SCECategoryPickerDialogController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/17/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCECategoryPickerDelegate.h"

@interface SCECategoryPickerDialogController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) id <SCECategoryPickerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;

- (IBAction)searchButton:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

@end
