//
//  SCESpecialViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/6/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlaceStubDelegate.h"

@class SCESpecial;

@interface SCESpecialViewController : UIViewController <SCEPlaceStubDelegate>

@property (nonatomic, strong) SCESpecial *special;

- (id)initWithSpecial:(SCESpecial *)s;

@end
