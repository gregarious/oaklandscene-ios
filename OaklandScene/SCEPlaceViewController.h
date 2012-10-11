//
//  SCEPlaceViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

@class SCEPlace;
@class SCEPlaceDetailView;

@interface SCEPlaceViewController : UIViewController 
@property (nonatomic, strong) SCEPlace *place;

typedef enum {
    SCEPlaceDetailButtonTagDirections = 401,
    SCEPlaceDetailButtonTagCall = 402,
    SCEPlaceDetailButtonTagFacebook = 403,
    SCEPlaceDetailButtonTagTwitter = 404,
    SCEPlaceDetailButtonTagWebsite = 405
} SCEPlaceDetailButtonTag;

- (id)initWithPlace:(SCEPlace *)p;
- (void)buttonPress:(id)sender;

@end
