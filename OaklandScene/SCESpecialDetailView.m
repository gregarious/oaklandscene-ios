//
//  SCESpecialDetailView.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/3/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCESpecialDetailView.h"
#import "SCESpecialDetailHeadView.h"
#import "SCEAboutView.h"
#import "SCESpecialRedeemPrompt.h"
#import "SCEPlaceStubView.h"

@interface SCESpecialDetailView ()

// utility function for various set*View calls
- replaceSubview:(UIView *)old with:(UIView *)new;

@end

@implementation SCESpecialDetailView

@synthesize mapView, headerView;
@synthesize placeStubView, redeemView;
@synthesize aboutView;

NSInteger SCEBackgroundImageTag = 200;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lastSubviewBottomYPos = 0;
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // set up the background images
        UIImageView *windowBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_bkgd_strip.png"]];
        [self addSubview:windowBackground];
        
        windowBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_bkgd_strip.png"]];
        CGRect wbFrame = [windowBackground frame];
        wbFrame.origin.x = frame.size.width - wbFrame.size.width;
        [windowBackground setFrame:wbFrame];
        [self addSubview:windowBackground];
        
        UIImageView *contentBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_content_bkgd.png"]];
        CGRect cbFrame = [contentBackground frame];
        cbFrame.origin = CGPointMake(12, 160);
        [contentBackground setFrame:cbFrame];
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
    [[self placeStubView] setFrame:CGRectMake(24, rasterY, 272, 100)];
    rasterY += [[self placeStubView] frame].size.height + 20;

    // redeem info (not optional)
    [[self redeemView] setFrame:CGRectMake(24, rasterY, 272, 80)];
    rasterY += [[self redeemView] frame].size.height + 10;
    
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

- (void)setMapView:(MKMapView *)view
{
    mapView = [self replaceSubview:[self mapView] with:view];
}

- (void)setHeaderView:(SCESpecialDetailHeadView *)view
{
    headerView = [self replaceSubview:[self headerView] with:view];
}

- (void)setPlaceStubView:(SCEPlaceStubView *)view
{
    placeStubView = [self replaceSubview:[self placeStubView] with:view];
}

- (void)setRedeemView:(SCESpecialRedeemPrompt *)view
{
    redeemView = [self replaceSubview:[self redeemView] with:view];
}

- (void)setAboutView:(SCEAboutView *)view
{
    aboutView = [self replaceSubview:[self aboutView] with:view];
}

@end
