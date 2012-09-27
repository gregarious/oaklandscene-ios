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
#import "SCEPlaceDetailHeadView.h"
#import "SCEPlaceDetailView.h"
#import "SCEPlace.h"
#import "SCEUtils.h"

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
    SCEPlaceDetailView *detailView = [[SCEPlaceDetailView alloc] initWithFrame:frame];
    
    MKMapView *mapView = [[MKMapView alloc] init];
    [mapView setRegion:MKCoordinateRegionMakeWithDistance([[self place] location], 300, 300)];
    [mapView addAnnotation:[SCESimpleAnnotation
                                         annotationWithCoordinate:[[self place] location]]];
    [detailView setMapView:mapView];
    
    SCEPlaceDetailHeadView* headerView = [[SCEPlaceDetailHeadView alloc] init];
    [detailView setHeaderView:headerView];

    NSArray *hours = [[self place] hours];
    if (hours && [hours count] > 0 ) {
        SCEHoursView* hoursView = [[SCEHoursView alloc] init];
        [hoursView setHoursArray:[[self place] hours]];
        [detailView setHoursView:hoursView];
    }
    
    SCEAboutView* aboutView = [[SCEAboutView alloc] init];
    [aboutView setAboutText:[[self place] description]];
    [detailView setAboutView:aboutView];

    UIButton *dirBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEDirectionsButton"
                                                      owner:self
                                                    options:nil] objectAtIndex:0];
    [detailView setLeftActionButton:dirBtn];
    
    UIButton *callBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCECallButton"
                                                      owner:self
                                                    options:nil] objectAtIndex:0];
    [detailView setRightActionButton:callBtn];

    UIButton *facebookBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEConnectFacebookButton"
                                                           owner:self
                                                         options:nil] objectAtIndex:0];
    [detailView setLeftConnectButton:facebookBtn];
    
    UIButton *twitterBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEConnectTwitterButton"
                                                           owner:self
                                                         options:nil] objectAtIndex:0];
    [detailView setMiddleConnectButton:twitterBtn];

    UIButton *websiteBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEConnectWebsiteButton"
                                                          owner:self
                                                        options:nil] objectAtIndex:0];
    [detailView setRightConnectButton:websiteBtn];

    [scrollView addSubview:detailView];

    // need to know the size of the detailView, so force layout and get size
    [detailView layoutSubviews];
    [detailView sizeToFit];
    
    // TODO: not going to work cause detailView size isn't known until layoutSubviews is called
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
