//
//  SCEPlaceViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

@class SCEPlace;

@interface SCEPlaceViewController : UIViewController
{
    __weak IBOutlet UILabel *nameLabel;
}

@property (nonatomic, strong) SCEPlace *place;

- (id)initWithPlace:(SCEPlace *)p;

@end
