//
//  SCESearchFeedDialogController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/17/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCEFeedSearchDelegate.h"

@interface SCEFeedSearchDialogController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) id <SCEFeedSearchDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (weak, nonatomic) IBOutlet UITextField *keywordText;

- (IBAction)searchButton:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

@end
