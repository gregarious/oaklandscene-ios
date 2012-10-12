//
//  SCEEventViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/6/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlaceStubDelegate.h"
#import "SCEWebViewDelegate.h"

@class SCEEvent;
@class SCEEventDetailView;

@interface SCEEventViewController : UIViewController <SCEPlaceStubDelegate, SCEWebViewDelegate>

@property (nonatomic, strong) SCEEvent *event;

- (id)initWithEvent:(SCEEvent *)e;
- (void)buttonPress:(id)sender;
- (void)goToBackground;

@end
