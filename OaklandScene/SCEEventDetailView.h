//
//  SCEEventDetailView.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/3/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCEEventDetailHeadView;
@class SCEPlaceStubView;
@class SCEAboutView;

@interface SCEEventDetailView : UIView
{
    CGFloat lastSubviewBottomYPos;
}

@property (nonatomic) UIView *mapView;
@property (nonatomic) SCEEventDetailHeadView *headerView;

@property (nonatomic) SCEPlaceStubView *placeStubView;

@property (nonatomic) UIButton *leftConnectButton;
@property (nonatomic) UIButton *rightConnectButton;

@property (nonatomic) SCEAboutView *aboutView;


@end
