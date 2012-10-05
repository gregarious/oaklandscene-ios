//
//  SCEEventViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/6/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCEEventViewController.h"
#import "SCEPlace.h"
#import "SCEPlaceStubView.h"
#import "SCEEvent.h"
#import "SCEEventDetailHeadView.h"
#import "SCEEventDetailView.h"
#import "SCEAboutView.h"
#import "SCEURLImage.h"
#import "SCECategory.h"
#import "SCECategoryList.h"
#import "SCESimpleAnnotation.h"

@implementation SCEEventViewController

@synthesize event;

- (id)initWithEvent:(SCEEvent *)e
{
    self = [super init];
    if (self) {
        [self setEvent:e];
        [self setTitle:[e name]];
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
    SCEEventDetailView *detailView = [[SCEEventDetailView alloc] initWithFrame:frame];
    
    SCEPlace *place = [[self event] place];
    
    // map view

    CLLocationCoordinate2D location = [place location];
    if (place && location.latitude != 0.0 && location.longitude != 0.0) {
        MKMapView *mapView = [[MKMapView alloc] init];
        [detailView setMapView:mapView];
        [mapView addAnnotation:[SCESimpleAnnotation
                                annotationWithCoordinate:location]];
        // can't set the region till the subview is framed: do it at the bottom of this method
    }
    else {
        UILabel *mapReplacementLabel = [[UILabel alloc] init];
        [mapReplacementLabel setText:@"No location information"];
        [mapReplacementLabel setBackgroundColor:[UIColor darkGrayColor]];
        [mapReplacementLabel setTextColor:[UIColor whiteColor]];
        [mapReplacementLabel setTextAlignment:NSTextAlignmentCenter];
        [detailView setMapView:mapReplacementLabel];
    }
    
    // header view
    SCEEventDetailHeadView* headerView = [[[NSBundle mainBundle] loadNibNamed:@"SCEEventDetailHeadView"
                                                                        owner:self
                                                                      options:nil] objectAtIndex:0];
    [[headerView nameLabel] setText:[[self event] name]];
    
    if ([[[self event] urlImage] image]) {
        [[headerView thumbnail] setImage:[[[self event] urlImage] image]];
    }
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateStyle:NSDateFormatterMediumStyle];
    [fmt setTimeStyle:NSDateFormatterShortStyle];
    NSString *timeString = [NSString stringWithFormat:@"%@ - %@",
                            [fmt stringFromDate:[[self event] startTime]],
                            [fmt stringFromDate:[[self event] endTime]]];
    [[headerView dateLabel] setText:timeString];
    
    NSMutableArray *categoryLabels = [NSMutableArray array];
    for (SCECategory *category in [[self event] categories]) {
        [categoryLabels addObject:[category label]];
    }
    [[headerView categoryList] setCategoryLabelTexts:categoryLabels];
    [detailView setHeaderView:headerView];
    
    // place stub view
    SCEPlaceStubView *placeStub;

    if (place) {
        placeStub = [[[NSBundle mainBundle] loadNibNamed:@"SCEPlaceStubView"
                                                   owner:self
                                                 options:nil] objectAtIndex:0];
        [[placeStub nameLabel] setText:[place name]];
        [[placeStub addressLabel] setText:[place streetAddress]];
    }
    else {
        placeStub = [[[NSBundle mainBundle] loadNibNamed:@"SCEPlaceStubView"
                                                   owner:self
                                                 options:nil] objectAtIndex:1];
        [[placeStub nameLabel] setText:[event placePrimitive]];
    }
    [detailView setPlaceStubView:placeStub];

    // NIB index 1 is the longer version of the website button
    UIButton *websiteBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEConnectWebsiteButton"
                                                          owner:self
                                                        options:nil] objectAtIndex:1];
    [detailView setLeftConnectButton:websiteBtn];

    
    [scrollView addSubview:detailView];

    // need to know the size of the detailView, so force layout and get size
    [detailView layoutSubviews];
    [detailView sizeToFit];

    // since map is now framed, we can call setRegion
    // first make sure it's an actual map, not a label replacement
    if ([[detailView mapView] isKindOfClass:[MKMapView class]]) {
        MKMapView *mapView = (MKMapView *)[detailView mapView];
        [mapView setRegion:MKCoordinateRegionMakeWithDistance([place location], 300, 300) animated:false];
    }
    
    [scrollView setContentSize:[detailView bounds].size];
    [self setView:scrollView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
