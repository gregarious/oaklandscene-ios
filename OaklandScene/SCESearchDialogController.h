//
//  SCESearchDialogController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/14/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCESearchDialogDelegate.h"

@interface SCESearchDialogController : UIViewController
{
    __weak IBOutlet UITextField *queryField;
}

@property (nonatomic, assign) id <SCESearchDialogDelegate> delegate;

- (IBAction)search:(id)sender;

@end
