//
//  SCEFeedSearchDelegate.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/17/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCECategoryPickerDialogController;
@class SCECategory;

@protocol SCECategoryPickerDelegate <UIPickerViewDelegate, UIPickerViewDataSource>

- (void)searchDialog:(SCECategoryPickerDialogController *)dialog
didSubmitSearchWithCategoryRow:(NSInteger)categoryRow;

@end
