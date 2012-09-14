//
//  SCESearchDialogDelegate.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/14/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCESearchDialogController;

@protocol SCESearchDialogDelegate <NSObject>

//- (void)searchDialog:(SCESearchDialogController *)c
//didChangeCategorySelection:(NSInteger)catId;

- (void)searchDialog:(SCESearchDialogController *)c
didSubmitSearchWithCategory:(NSInteger)catId
        keywordQuery:(NSString *)q;

@end
