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
#import "SCEPlaceStore.h"
#import "SCEPlaceStubView.h"
#import "SCEPlaceViewController.h"
#import "SCEEvent.h"
#import "SCEEventDetailHeadView.h"
#import "SCEEventDetailView.h"
#import "SCEAboutView.h"
#import "SCEURLImage.h"
#import "SCECategory.h"
#import "SCECategoryList.h"
#import "SCESimpleAnnotation.h"
#import "SCEWebViewController.h"

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
        [mapView addAnnotation:[SCESimpleAnnotation annotationWithCoordinate:location
                                                                       title:nil
                                                                    subtitle:nil
                                                                  resourceId:nil]];
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
    
    if ([[self event] imageUrl]) {
        [[SCEURLImageStore sharedStore] fetchImageWithURLString:[[self event] imageUrl]
                                                   onCompletion:
         ^void(UIImage *image, NSError *err) {
             if (image) {
                 [[headerView thumbnail] setImage:image];
             }
         }];
    }
    
    // determine correct format for date string
    NSString *medStartDate = [NSDateFormatter localizedStringFromDate:[[self event] startTime]
                                                             dateStyle:NSDateFormatterMediumStyle
                                                             timeStyle:NSDateFormatterNoStyle];
    NSString *medEndDate = [NSDateFormatter localizedStringFromDate:[[self event] endTime]
                                                             dateStyle:NSDateFormatterMediumStyle
                                                             timeStyle:NSDateFormatterNoStyle];
    
    NSTimeInterval duration = [[[self event] endTime] timeIntervalSinceDate:[[self event] startTime]];
    
    // if event ends on same day it starts, or within 6 hours of it's start (e.g. 9pm-2am), don't print the end date
    if ([medStartDate isEqualToString:medEndDate] || duration <= 3600 * 6) {   // 6 hours
        [[headerView dateLabel] setText:[NSString stringWithFormat:@"%@ - %@",
            [NSDateFormatter localizedStringFromDate:[[self event] startTime]
                                           dateStyle:NSDateFormatterLongStyle
                                           timeStyle:NSDateFormatterShortStyle],
            [NSDateFormatter localizedStringFromDate:[[self event] endTime]
                                           dateStyle:NSDateFormatterNoStyle
                                           timeStyle:NSDateFormatterShortStyle]]];
    }
    else {
        [[headerView dateLabel] setText:[NSString stringWithFormat:@"%@ - %@",
             [NSDateFormatter localizedStringFromDate:[[self event] startTime]
                                            dateStyle:NSDateFormatterMediumStyle
                                            timeStyle:NSDateFormatterShortStyle],
             [NSDateFormatter localizedStringFromDate:[[self event] endTime]
                                            dateStyle:NSDateFormatterMediumStyle
                                            timeStyle:NSDateFormatterShortStyle]]];
        
    }

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

        [placeStub setDelegate:self];
        
        if (![[[SCEPlaceStore sharedStore] items] containsObject:place]) {
            [[placeStub placePageButton] setEnabled:NO];
        }
        
        if (![place daddr]) {
            [[placeStub placePageButton] setEnabled:NO];
        }
    }
    else {
        placeStub = [[[NSBundle mainBundle] loadNibNamed:@"SCEPlaceStubView"
                                                   owner:self
                                                 options:nil] objectAtIndex:1];
        [[placeStub nameLabel] setText:[event placePrimitive]];
    }
    [detailView setPlaceStubView:placeStub];

    // NIB index 1 is the longer version of the website button
    if ([[self event] url]) {
        UIButton *websiteBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEConnectWebsiteButton"
                                                              owner:self
                                                            options:nil] objectAtIndex:1];
        [detailView setLeftConnectButton:websiteBtn];
        [websiteBtn addTarget:self
                       action:@selector(buttonPress:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    
    [scrollView addSubview:detailView];

    // about subview
    SCEAboutView* aboutView = [[SCEAboutView alloc] init];
    [aboutView setAboutText:[[self event] description]];
    [detailView setAboutView:aboutView];
    
    
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

- (void)placePageButtonTapped
{
    NSString *placeId = [[[self event] place] resourceId];
    if (placeId) {
        SCEPlace *place = [[SCEPlaceStore sharedStore] itemFromResourceId:placeId];
        if (place) {
            SCEPlaceViewController *vc = [[SCEPlaceViewController alloc] initWithPlace:place];
            [[self navigationController] pushViewController:vc animated:YES];
        }
        else {
            // TODO: alert place page coudn't be found?
        }
    }
}

- (void)directionsButtonTapped
{
    NSString *daddr = [[[[self event] place] daddr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%@", daddr];
    
    // if iOS version supports Apple maps, launch in separate app
    BOOL appleMapsSupport = (NSClassFromString(@"MKDirectionsRequest") != nil);
    if (appleMapsSupport) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        return;
    }
    
    // if we made it here, the request needs to be opened in a webview
    SCEWebViewController *webViewController = [[SCEWebViewController alloc] init];
    [webViewController setDelegate:self];
    [self presentModalViewController:webViewController animated:YES];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // have to do this post-presentation
    [[webViewController webView] loadRequest:req];
}

- (void)buttonPress:(id)sender
{
    // only handles website button. others handled by PlaceStubDelegate methods
    NSString *urlString = [[self event] url];
    if (![urlString hasPrefix:@"http"]) {
        urlString = [@"http://" stringByAppendingString:urlString];
    }
    
    // if we made it here, the request needs to be opened in a webview
    SCEWebViewController *webViewController = [[SCEWebViewController alloc] init];
    [webViewController setDelegate:self];
    [self presentModalViewController:webViewController animated:YES];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // have to do this post-presentation
    [[webViewController webView] loadRequest:req];
}

- (void)didCloseWebView:(UIWebView *)view
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
