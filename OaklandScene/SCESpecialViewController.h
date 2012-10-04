//
//  SCESpecialViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/6/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

@class SCESpecial;

@interface SCESpecialViewController : UIViewController

@property (nonatomic, strong) SCESpecial *special;

- (id)initWithSpecial:(SCESpecial *)s;

@end
