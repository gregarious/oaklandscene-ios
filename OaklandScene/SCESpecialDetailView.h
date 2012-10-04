//
//  SCESpecialDetailView.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/3/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class SCESpecialDetailHeadView;
@class SCESpecialRedeemPrompt;
@class SCEPlaceStubView;
@class SCEAboutView;

@interface SCESpecialDetailView : UIView
{
    CGFloat lastSubviewBottomYPos;
}

@property (nonatomic) MKMapView *mapView;
@property (nonatomic) SCESpecialDetailHeadView *headerView;

@property (nonatomic) SCEPlaceStubView *placeStubView;

@property (nonatomic) SCESpecialRedeemPrompt *redeemView;

@property (nonatomic) SCEAboutView *aboutView;

@end
