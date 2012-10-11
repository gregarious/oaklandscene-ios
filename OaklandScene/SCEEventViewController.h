//
//  SCEEventViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/6/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlaceStubDelegate.h"

@class SCEEvent;
@class SCEEventDetailView;

@interface SCEEventViewController : UIViewController <SCEPlaceStubDelegate>

@property (nonatomic, strong) SCEEvent *event;

- (id)initWithEvent:(SCEEvent *)e;
- (void)buttonPress:(id)sender;

@end
