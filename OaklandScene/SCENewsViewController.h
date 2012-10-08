//
//  SCENewsViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/6/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

@class SCENewsStub;

@interface SCENewsViewController : UIViewController

@property (nonatomic, strong) SCENewsStub *newsStub;

- (id)initWithNewsStub:(SCENewsStub *)s;

@end
