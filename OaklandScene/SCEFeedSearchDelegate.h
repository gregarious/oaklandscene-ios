//
//  SCEFeedSearchDelegate.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/17/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCEFeedSearchDialogController;

@protocol SCEFeedSearchDelegate <UIPickerViewDelegate, UIPickerViewDataSource>

- (void)searchDialog:(SCEFeedSearchDialogController *)dialog
didSubmitSearchWithCategoryRow:(NSInteger)categoryRow
        keywordQuery:(NSString *)queryString;

@end
