//
//  SCEEventViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/6/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEEventViewController.h"
#import "SCEEvent.h"
//#import "SCEEventDetailHeadView.h"
#import "SCEEventDetailView.h"
#import "SCEURLImage.h"
#import "SCECategory.h"
#import "SCECategoryList.h"

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
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [l setText:[[self event] name]];
    [detailView setTestLabel:l];
    
    // TODO: Adapt everything below from SCEPlaceViewController
//    
//    // map view
//    MKMapView *mapView = [[MKMapView alloc] init];
//    [detailView setMapView:mapView];
//    [mapView addAnnotation:[SCESimpleAnnotation
//                            annotationWithCoordinate:[[self place] location]]];
//    // can't set the region till the subview is framed: do it at the bottom of this method
//    
//    // header view
//    // need to figure out ahead of time if name will fit on one line
//    NSInteger nibViewIndex;
//    CGSize sz = [[[self place] name] sizeWithFont:[UIFont boldSystemFontOfSize:16]];
//    if (sz.width <= 225) {
//        nibViewIndex = 0;
//    }
//    else {
//        nibViewIndex = 1;
//    }
//    SCEPlaceDetailHeadView* headerView = [[[NSBundle mainBundle] loadNibNamed:@"SCEPlaceDetailHeadView"
//                                                                        owner:self
//                                                                      options:nil] objectAtIndex:nibViewIndex];
//    [[headerView nameLabel] setText:[[self place] name]];
//    [[headerView addressLabel] setText:[[self place] streetAddress]];
//    if ([[self place] urlImage]) {
//        [[headerView thumbnailImage] setImage:[[[self place] urlImage] image]];
//    }
//    else {
//        // TODO: replace with stock image
//        [[headerView thumbnailImage] setImage:nil];
//    }
//    
//    NSMutableArray *categoryLabels = [NSMutableArray array];
//    for (SCECategory *category in [[self place] categories]) {
//        [categoryLabels addObject:[category label]];
//    }
//    [[headerView categoryList] setCategoryLabelTexts:categoryLabels];
//    [detailView setHeaderView:headerView];
//    
//    // hours subview
//    NSArray *hours = [[self place] hours];
//    if (hours && [hours count] > 0 ) {
//        SCEHoursView* hoursView = [[SCEHoursView alloc] init];
//        [hoursView setHoursArray:[[self place] hours]];
//        [detailView setHoursView:hoursView];
//    }
//    
//    // about subview
//    SCEAboutView* aboutView = [[SCEAboutView alloc] init];
//    [aboutView setAboutText:[[self place] description]];
//    [detailView setAboutView:aboutView];
//    
//    // action buttons
//    UIButton *dirBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEDirectionsButton"
//                                                      owner:self
//                                                    options:nil] objectAtIndex:0];
//    [detailView setLeftActionButton:dirBtn];
//    
//    UIButton *callBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCECallButton"
//                                                       owner:self
//                                                     options:nil] objectAtIndex:0];
//    [detailView setRightActionButton:callBtn];
//    
//    UIButton *facebookBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEConnectFacebookButton"
//                                                           owner:self
//                                                         options:nil] objectAtIndex:0];
//    [detailView setLeftConnectButton:facebookBtn];
//    
//    UIButton *twitterBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEConnectTwitterButton"
//                                                          owner:self
//                                                        options:nil] objectAtIndex:0];
//    [detailView setMiddleConnectButton:twitterBtn];
//    
//    UIButton *websiteBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEConnectWebsiteButton"
//                                                          owner:self
//                                                        options:nil] objectAtIndex:0];
//    [detailView setRightConnectButton:websiteBtn];
//    
    [scrollView addSubview:detailView];
//
//    // need to know the size of the detailView, so force layout and get size
    [detailView layoutSubviews];
    [detailView sizeToFit];
//
//    // since map is now framed, we can call setRegion
//    [mapView setRegion:MKCoordinateRegionMakeWithDistance([[self place] location], 300, 300) animated:false];
    
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
