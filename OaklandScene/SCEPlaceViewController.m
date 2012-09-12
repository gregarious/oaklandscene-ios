//
//  SCEPlaceViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlaceViewController.h"
#import "SCEPlace.h"

@implementation SCEPlaceViewController

- (id)initWithPlace:(SCEPlace *)p
{
    self = [super init];
    if (self) {
        [self setPlace:p];
        [self setTitle:[p name]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
