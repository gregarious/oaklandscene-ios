//
//  SCENewsViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/6/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEWebViewDelegate.h"

@class SCENewsStub;

@interface SCENewsViewController : UIViewController <SCEWebViewDelegate>

@property (nonatomic, strong) SCENewsStub *newsStub;

- (id)initWithNewsStub:(SCENewsStub *)s;
- (void)buttonPress:(id)sender;

@end
