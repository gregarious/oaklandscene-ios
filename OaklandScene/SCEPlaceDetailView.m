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
#import "SCEPlaceDetailHeadView.h"
#import "SCEAboutView.h"
#import "SCEHoursView.h"

@implementation SCEPlaceDetailView

@synthesize mapView, headerView;

@synthesize hoursView, aboutView;
@synthesize leftActionButton, rightActionButton;
@synthesize leftConnectButton, middleConnectButton, rightConnectButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lastSubviewBottomYPos = 0;
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // set up the background images
        CGSize sz;
        UIImageView *windowBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_bkgd.png"]];
        sz = [[windowBackground image] size];
        [windowBackground setFrame:CGRectMake(0, 0, sz.width, sz.height)];

        UIImageView *contentBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_content_bkgd.png"]];
        sz = [[contentBackground image] size];
        [contentBackground setFrame:CGRectMake(12, 160, sz.width, sz.height)];

        // add the subviews
        [self addSubview:windowBackground];
        [self addSubview:contentBackground];
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat rasterY = 0.0;
    // map view
    if ([self mapView]) {
        [[self mapView] setFrame:CGRectMake(12.0, rasterY, 296.0, 80.0)];
        rasterY += [[self mapView] frame].size.height;
    }
    
    // header view (not optional)
    [[self headerView] setFrame:CGRectMake(4, rasterY, 312, 80)];
    // add height of header and a margin below
    rasterY += [[self headerView] frame].size.height + 8;
    
    // hours
    if ([self hoursView]) {
        [[self hoursView] setFrame:CGRectMake(24, rasterY, 272, 0)];
        [[self hoursView] sizeToFit];
        // add height of subview and a margin below
        rasterY += [[self hoursView] frame].size.height + 20;
    }
    
    // buttons
    BOOL actionButtonExists = [self leftActionButton] || [self rightActionButton];
    BOOL connectButtonExists = [self leftConnectButton] || [self middleConnectButton] || [self rightConnectButton];
    if (actionButtonExists || connectButtonExists) {
        
        if (actionButtonExists) {
            CGFloat btnHeight = 44;
            [[self leftActionButton] setFrame:CGRectMake(24, rasterY, 132, btnHeight)];
            [[self rightActionButton] setFrame:CGRectMake(164, rasterY, 132, btnHeight)];
            rasterY += btnHeight;

            // add padding between button rows
            if (connectButtonExists) {
                rasterY += 12;
            }
        }
        
        if (connectButtonExists) {
            CGFloat btnHeight = 44;
            [[self leftConnectButton] setFrame:CGRectMake(24, rasterY, 88, btnHeight)];
            [[self middleConnectButton] setFrame:CGRectMake(116, rasterY, 88, btnHeight)];
            [[self rightConnectButton] setFrame:CGRectMake(208, rasterY, 88, btnHeight)];
            rasterY += btnHeight;
        }
        // margin below buttons
        rasterY += 20;
    }
    
    // about
    if ([self aboutView]) {
        [[self aboutView] setFrame:CGRectMake(24, rasterY, 272, 0)];
        [[self aboutView] sizeToFit];
        rasterY += [[self aboutView] frame].size.height + 20;
    }
    
    lastSubviewBottomYPos = rasterY;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, lastSubviewBottomYPos + 20);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// Various set property calls -- overridden to handle the subview adding/removing
// Note that setNeedsLayout is NOT called as a result of this call

- (void)setMapView:(MKMapView *)view
{
    [[self mapView] removeFromSuperview];
    mapView = view;

    [self addSubview:view];
}

- (void)setHeaderView:(SCEPlaceDetailHeadView *)view
{
    [[self headerView] removeFromSuperview];
    headerView = view;
    [self addSubview:view];
}

- (void)setHoursView:(SCEHoursView *)view
{
    [[self hoursView] removeFromSuperview];
    hoursView = view;
    [self addSubview:hoursView];
}

- (void)setAboutView:(SCEAboutView *)view
{
    [[self aboutView] removeFromSuperview];
    aboutView = view;
    [self addSubview:aboutView];
}

- (void)setLeftActionButton:(UIButton *)btn
{
    [[self leftActionButton] removeFromSuperview];
    leftActionButton = btn;
    [self addSubview:leftActionButton];
}

- (void)setRightActionButton:(UIButton *)btn
{
    [[self rightActionButton] removeFromSuperview];
    rightActionButton = btn;
    [self addSubview:rightActionButton];
}

- (void)setLeftConnectButton:(UIButton *)btn
{
    [[self leftConnectButton] removeFromSuperview];
    leftConnectButton = btn;
    [self addSubview:leftConnectButton];
}

- (void)setMiddleConnectButton:(UIButton *)btn
{
    [[self middleConnectButton] removeFromSuperview];
    middleConnectButton = btn;
    [self addSubview:middleConnectButton];
}

- (void)setRightConnectButton:(UIButton *)btn
{
    [[self rightConnectButton] removeFromSuperview];
    rightConnectButton = btn;
    [self addSubview:rightConnectButton];
}

@end
