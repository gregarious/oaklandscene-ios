//
//  SCEPlaceDetailView.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/24/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class SCEHoursView;
@class SCEAboutView;
@class SCEPlaceDetailHeadView;

@interface SCEPlaceDetailView : UIView
{
    CGFloat lastSubviewBottomYPos;
}

@property (nonatomic) MKMapView *mapView;
@property (nonatomic) SCEPlaceDetailHeadView *headerView;
@property (nonatomic) SCEHoursView *hoursView;
@property (nonatomic) SCEAboutView *aboutView;

@property (nonatomic) UIButton *leftActionButton;
@property (nonatomic) UIButton *rightActionButton;

@property (nonatomic) UIButton *leftConnectButton;
@property (nonatomic) UIButton *middleConnectButton;
@property (nonatomic) UIButton *rightConnectButton;

@end
