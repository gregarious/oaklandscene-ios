//
//  SCEPlaceDetailView.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/24/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "SCEPlaceDetailView.h"
#import "SCEPlaceHeaderView.h"
#import "SCEAboutView.h"
#import "SCEHoursView.h"

@interface SCEPlaceDetailView ()

- (void)updateDynamicSubviewFrames;

@end

@implementation SCEPlaceDetailView

@synthesize mapView, headerView;

@synthesize hoursView, aboutView;
@synthesize leftActionButton, rightActionButton;
@synthesize leftConnectButton, middleConnectButton, rightConnectButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize sz;
        UIImageView *windowBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_bkgd.png"]];
        sz = [[windowBackground image] size];
        [windowBackground setFrame:CGRectMake(0, 0, sz.width, sz.height)];

        UIImageView *contentBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_content_bkgd.png"]];
        sz = [[contentBackground image] size];
        [contentBackground setFrame:CGRectMake(12, 160, sz.width, sz.height)];

        // initialize all the static subviews
        NSInteger fy = 0;  // running counter of frame position y
        NSInteger fw = 296;         // current width of frame

        // init map view
        mapView = [[MKMapView alloc] initWithFrame:CGRectMake(12, fy, fw, 80)];
        fy += 80;
        
        // init header view
        headerView = [[SCEPlaceHeaderView alloc] initWithFrame:CGRectMake(4, fy, fw, 80)];
        fy += 80;
        
        // add the subviews
        [self addSubview:windowBackground];
        [self addSubview:contentBackground];
        [self addSubview:mapView];
        [self addSubview:headerView];
    }
    return self;
}

- (void)updateDynamicSubviewFrames
{
    NSInteger fx = 24, fy = 168, fw = 248;
    CGSize sz;
    if ([self hoursView]) {
        sz = [[self hoursView] bounds].size;
        [[self hoursView] setFrame:CGRectMake(fx, fy, fw, sz.height)];
        fy += sz.height + 20;
    }
    
    sz = CGSizeMake(0.0, 0.0);
    if ([self leftActionButton] || [self rightActionButton]) {
        if ([self leftActionButton]) {
            sz = [[self leftActionButton] bounds].size;
            [[self leftActionButton] setFrame:CGRectMake(fx, fy, 132, sz.height)];
        }
        if ([self rightActionButton]) {
            sz = [[self rightActionButton] bounds].size;
            [[self rightActionButton] setFrame:CGRectMake(fx + 140, fy, 132, sz.height)];
        }
        fy += sz.height + 12;
    }
    
    sz = CGSizeMake(0.0, 0.0);
    if ([self leftConnectButton] || [self middleConnectButton] || [self rightActionButton]) {
        if ([self leftConnectButton]) {
            sz = [[self leftConnectButton] bounds].size;
            [[self leftConnectButton] setFrame:CGRectMake(fx, fy, 88, sz.height)];
        }
        if ([self middleConnectButton]) {
            sz = [[self middleConnectButton] bounds].size;
            [[self middleConnectButton] setFrame:CGRectMake(fx + 92, fy, 88, sz.height)];
        }
        if ([self rightConnectButton]) {
            sz = [[self rightConnectButton] bounds].size;
            [[self rightConnectButton] setFrame:CGRectMake(fx + 184, fy, 88, sz.height)];
        }
        fy += sz.height + 20;
    }

    sz = CGSizeMake(0.0, 0.0);
    if ([self aboutView]) {
        sz = [[self aboutView] bounds].size;
        [[self aboutView] setFrame:CGRectMake(fx, fy, fw, sz.height)];
        fy += sz.height;
    }
    
    // set the true bounds of the view
    CGRect bounds = CGRectMake(0.0, 0.0, 320.0, fy+12.0);
//    CGRect bounds = [self frame];
//    bounds.size.width = 44;
    // TODO: figure out why this isn't a setBounds call? Look more into internal inflating of bounds. 
    [self setFrame:bounds];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setHoursView:(SCEHoursView *)view
{
    [[self hoursView] removeFromSuperview];
    hoursView = view;
    [self addSubview:hoursView];
    [self updateDynamicSubviewFrames];
}

- (void)setAboutView:(SCEAboutView *)view
{
    [[self aboutView] removeFromSuperview];
    aboutView = view;
    [self addSubview:aboutView];
    [self updateDynamicSubviewFrames];
}

- (void)setLeftActionButton:(UIButton *)btn
{
    [[self leftActionButton] removeFromSuperview];
    leftActionButton = btn;
    [self addSubview:leftActionButton];
    [self updateDynamicSubviewFrames];
}

- (void)setRightActionButton:(UIButton *)btn
{
    [[self rightActionButton] removeFromSuperview];
    rightActionButton = btn;
    [self addSubview:rightActionButton];
    [self updateDynamicSubviewFrames];
}

- (void)setLeftConnectButton:(UIButton *)btn
{
    [[self leftConnectButton] removeFromSuperview];
    leftConnectButton = btn;
    [self addSubview:leftConnectButton];
    [self updateDynamicSubviewFrames];
}

- (void)setMiddleConnectButton:(UIButton *)btn
{
    [[self middleConnectButton] removeFromSuperview];
    middleConnectButton = btn;
    [self addSubview:middleConnectButton];
    [self updateDynamicSubviewFrames];
}

- (void)setRightConnectButton:(UIButton *)btn
{
    [[self rightConnectButton] removeFromSuperview];
    rightConnectButton = btn;
    [self addSubview:rightConnectButton];
    [self updateDynamicSubviewFrames];
}

@end
