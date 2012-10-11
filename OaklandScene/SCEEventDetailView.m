//
//  SCEEventDetailView.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/3/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEEventDetailView.h"
#import "SCEEventDetailHeadView.h"
#import "SCEAboutView.h"
#import "SCEPlaceStubView.h"

@interface SCEEventDetailView ()

// utility function for various set*View calls
- replaceSubview:(UIView *)old with:(UIView *)new;

@end

@implementation SCEEventDetailView

@synthesize mapView, headerView, placeStubView;
@synthesize leftConnectButton, rightConnectButton;
@synthesize aboutView;

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
        [[self mapView] setFrame:CGRectMake(12.0, rasterY, 296, 80)];
        rasterY += [[self mapView] frame].size.height;
    }
    
    // header view (not optional)
    [[self headerView] setFrame:CGRectMake(4, rasterY, 312, 80)];
    // add height of header and a margin below
    rasterY += [[self headerView] frame].size.height + 8;
    
    // place info (not optional)
    if ([self placeStubView]) {
        CGRect stubFrame = [[self placeStubView] frame];
        stubFrame.origin = CGPointMake(24, rasterY);
        [[self placeStubView] setFrame:stubFrame];
        rasterY += [[self placeStubView] frame].size.height + 10;
    }
    
    if ([self leftConnectButton] || [self rightConnectButton]) {
        if ([self leftConnectButton]) {
            CGFloat btnHeight = 44;
            
            // temporarily fixing left to be in the middle: no fb buttons for events for now
            [[self leftConnectButton] setFrame:CGRectMake(94, rasterY, 132, btnHeight)];
            
//            [[self leftConnectButton] setFrame:CGRectMake(24, rasterY, 132, btnHeight)];
//            [[self rightConnectButton] setFrame:CGRectMake(164, rasterY, 132, btnHeight)];
            rasterY += btnHeight;
        }
        // margin below buttons
        rasterY += 20;
    }

    // about info
    if ([self aboutView]) {
        [[self aboutView] setFrame:CGRectMake(24, rasterY, 272, 0)];
        [[self aboutView] sizeToFit];
        rasterY += [[self aboutView] frame].size.height + 20;
    }
    
    // TODO: why is the +20 necessary? we already added padding above
    lastSubviewBottomYPos = rasterY + 20;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, lastSubviewBottomYPos);
}

// Used in various set property calls -- necessary to handle the subview adding/removing
- (id)replaceSubview:(UIView *)old with:(UIView *)new
{
    [old removeFromSuperview];
    [self addSubview:new];
    return new;
}

- (void)setMapView:(UIView *)view
{
    mapView = [self replaceSubview:[self mapView] with:view];
}

- (void)setHeaderView:(SCEEventDetailHeadView *)view
{
    headerView = [self replaceSubview:[self headerView] with:view];
}

- (void)setPlaceStubView:(SCEPlaceStubView *)view
{
    placeStubView = [self replaceSubview:[self placeStubView] with:view];
}

- (void)setLeftConnectButton:(UIButton *)btn
{
    leftConnectButton = [self replaceSubview:[self leftConnectButton] with:btn];
}

- (void)setRightConnecButton:(UIButton *)btn
{
    rightConnectButton = [self replaceSubview:[self rightConnectButton] with:btn];
}

- (void)setAboutView:(SCEAboutView *)view
{
    aboutView = [self replaceSubview:[self aboutView] with:view];
}


@end
