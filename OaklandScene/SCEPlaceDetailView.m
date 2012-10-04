//
//  SCEPlaceDetailView.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/24/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "SCEPlaceDetailView.h"
#import "SCEPlaceDetailHeadView.h"
#import "SCEAboutView.h"
#import "SCEHoursView.h"

@interface SCEPlaceDetailView ()

// utility function for various set*View calls
- replaceSubview:(UIView *)old with:(UIView *)new;

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

// Used in various set property calls -- necessary to  handle the subview adding/removing
- (id)replaceSubview:(UIView *)old with:(UIView *)new
{
    [old removeFromSuperview];
    [self addSubview:new];
    return new;
}

// Note that setNeedsLayout is NOT called as a result of these calls
- (void)setMapView:(MKMapView *)view
{
    mapView = [self replaceSubview:[self mapView] with:view];
}

- (void)setHeaderView:(SCEPlaceDetailHeadView *)view
{
    headerView = [self replaceSubview:[self headerView] with:view];
}

- (void)setHoursView:(SCEHoursView *)view
{
    hoursView = [self replaceSubview:[self hoursView] with:view];
}

- (void)setAboutView:(SCEAboutView *)view
{
    aboutView = [self replaceSubview:[self aboutView] with:view];
}

- (void)setLeftActionButton:(UIButton *)btn
{
    leftActionButton = [self replaceSubview:[self leftActionButton] with:btn];
}

- (void)setRightActionButton:(UIButton *)btn
{
    rightActionButton = [self replaceSubview:[self rightActionButton] with:btn];
}

- (void)setLeftConnectButton:(UIButton *)btn
{
    leftConnectButton = [self replaceSubview:[self leftConnectButton] with:btn];
}

- (void)setMiddleConnectButton:(UIButton *)btn
{
    middleConnectButton = [self replaceSubview:[self middleConnectButton] with:btn];
}

- (void)setRightConnectButton:(UIButton *)btn
{
    rightConnectButton = [self replaceSubview:[self rightConnectButton] with:btn];
}

@end
