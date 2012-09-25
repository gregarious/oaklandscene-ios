//
//  SCEPlaceViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SCEPlaceViewController.h"
#import "SCEHoursView.h"
#import "SCEAboutView.h"
#import "SCEPlaceDetailView.h"
#import "SCEPlace.h"

// quick n dirty annotation for debug purposes
@interface SCESimpleAnnotation : NSObject<MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coord;
@end
@implementation SCESimpleAnnotation
@synthesize coordinate;
+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coord
{
    SCESimpleAnnotation *obj = [[SCESimpleAnnotation alloc] init];
    [obj setCoordinate:coord];
    return obj;
}
@end

@implementation SCEPlaceViewController

- (id)initWithPlace:(SCEPlace *)p
{
    self = [super init];
    if (self) {
        [self setPlace:p];
        [self setTitle:[p name]];
    }

    return self;
}

- (void)loadView
{
    // set up the wrapping scroll view
    CGRect frame = [[[self parentViewController] view] bounds];
    UIScrollView *scrollView = [[UIScrollView alloc]
                                initWithFrame:frame];

    // set up the detailView
    SCEPlaceDetailView *detailView = [[SCEPlaceDetailView alloc] init];

    [[detailView mapView] setRegion:MKCoordinateRegionMakeWithDistance([[self place] location], 300, 300)];
    [[detailView mapView] addAnnotation:[SCESimpleAnnotation
                                         annotationWithCoordinate:[[self place] location]]];
    
    SCEAboutView* aboutView = [[SCEAboutView alloc] init];
    [detailView setAboutView:aboutView];

    UIButton *dirBtn = [[[NSBundle mainBundle] loadNibNamed:@"directions_btn"
                                                      owner:self
                                                    options:nil] objectAtIndex:0];
    [detailView setLeftActionButton:dirBtn];
    
    UIButton *callBtn = [[[NSBundle mainBundle] loadNibNamed:@"call_btn"
                                                      owner:self
                                                    options:nil] objectAtIndex:0];
    [detailView setRightActionButton:callBtn];

    UIButton *facebookBtn = [[[NSBundle mainBundle] loadNibNamed:@"facebook_btn"
                                                           owner:self
                                                         options:nil] objectAtIndex:0];
    [detailView setLeftConnectButton:facebookBtn];
    
    UIButton *twitterBtn = [[[NSBundle mainBundle] loadNibNamed:@"twitter_btn"
                                                           owner:self
                                                         options:nil] objectAtIndex:0];
    [detailView setMiddleConnectButton:twitterBtn];

    UIButton *websiteBtn = [[[NSBundle mainBundle] loadNibNamed:@"website_btn"
                                                          owner:self
                                                        options:nil] objectAtIndex:0];
    [detailView setRightConnectButton:websiteBtn];

    [scrollView addSubview:detailView];
    [scrollView setContentSize:[detailView bounds].size];
    [self setView:scrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
