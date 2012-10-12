//
//  SCESpecialViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/6/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlaceStubDelegate.h"
#import "SCEWebViewDelegate.h"

@class SCESpecial;

@interface SCESpecialViewController : UIViewController <SCEPlaceStubDelegate, SCEWebViewDelegate>

@property (nonatomic, strong) SCESpecial *special;

- (id)initWithSpecial:(SCESpecial *)s;
- (void)goToBackground;
@end
