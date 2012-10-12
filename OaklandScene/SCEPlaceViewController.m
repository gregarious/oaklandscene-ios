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
#import "SCEURLImage.h"
#import "SCECategory.h"
#import "SCECategoryList.h"
#import "SCESimpleAnnotation.h"
#import "SCEWebViewController.h"

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
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [scrollView setBounces:NO];

    // set up the detailView
    SCEPlaceDetailView *detailView = [[SCEPlaceDetailView alloc] initWithFrame:frame];
    
    // map view
    MKMapView *mapView = [[MKMapView alloc] init];
    [detailView setMapView:mapView];
    [mapView addAnnotation:[SCESimpleAnnotation annotationWithCoordinate:[[self place] location]
                                                                   title:nil
                                                                subtitle:nil
                                                              resourceId:nil]];
    // can't set the region till the subview is framed: do it at the bottom of this method
    
    // header view
    // need to figure out ahead of time if name will fit on one line
    NSInteger nibViewIndex;
    CGSize sz = [[[self place] name] sizeWithFont:[UIFont boldSystemFontOfSize:16]];
    if (sz.width <= 225) {
        nibViewIndex = 0;
    }
    else {
        nibViewIndex = 1;
    }
    SCEPlaceDetailHeadView* headerView = [[[NSBundle mainBundle] loadNibNamed:@"SCEPlaceDetailHeadView"
                                                                        owner:self
                                                                      options:nil] objectAtIndex:nibViewIndex];
    [[headerView nameLabel] setText:[[self place] name]];
    [[headerView addressLabel] setText:[[self place] streetAddress]];
    if ([[self place] imageUrl]) {
        [[SCEURLImageStore sharedStore] fetchImageWithURLString:[[self place] imageUrl]
                                                   onCompletion:
         ^void(UIImage *image, NSError *err) {
             if (image) {
                 [[headerView thumbnailImage] setImage:image];
             }
         }];
    }
    
    NSMutableArray *categoryLabels = [NSMutableArray array];
    for (SCECategory *category in [[self place] categories]) {
        [categoryLabels addObject:[category label]];
    }
    [[headerView categoryList] setCategoryLabelTexts:categoryLabels];
    [detailView setHeaderView:headerView];

    // hours subview
    NSArray *hours = [[self place] hours];
    if (hours && [hours count] > 0 ) {
        SCEHoursView* hoursView = [[SCEHoursView alloc] init];
        [hoursView setHoursArray:[[self place] hours]];
        [detailView setHoursView:hoursView];
    }
     
    // about subview
    if ([[self place] description] && [[[self place] description] length] > 0) {
        SCEAboutView* aboutView = [[SCEAboutView alloc] init];
        [aboutView setAboutText:[[self place] description]];
        [detailView setAboutView:aboutView];
    }
    
    SCEPlace *p = [self place]; // simple alias
    
    // Directions button
    UIButton *dirBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEDirectionsButton"
                                                      owner:self
                                                    options:nil] objectAtIndex:0];
    [dirBtn setTag:SCEPlaceDetailButtonTagDirections];
    [dirBtn addTarget:self
               action:@selector(buttonPress:)
     forControlEvents:UIControlEventTouchUpInside];
    if ([p daddr]) {
        [dirBtn setEnabled:YES];
    }
    else {
        [dirBtn setEnabled:NO];
    }
    [detailView setLeftActionButton:dirBtn];
    
    // Call button
    UIButton *callBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCECallButton"
                                                       owner:self
                                                     options:nil] objectAtIndex:0];
    [callBtn setTag:SCEPlaceDetailButtonTagCall];
    [callBtn addTarget:self
                action:@selector(buttonPress:)
      forControlEvents:UIControlEventTouchUpInside];
    if ([p phone] && [[p phone] length] >= 7) {
        [callBtn setEnabled:YES];
    }
    else {
        [callBtn setEnabled:NO];
    }
    [detailView setRightActionButton:callBtn];
    
    // Facebook button
    UIButton *facebookBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEConnectFacebookButton"
                                                           owner:self
                                                         options:nil] objectAtIndex:0];
    [facebookBtn setTag:SCEPlaceDetailButtonTagFacebook];
    [facebookBtn addTarget:self
                    action:@selector(buttonPress:)
          forControlEvents:UIControlEventTouchUpInside];
    if ([p facebookId] && [[p facebookId] length] > 0) {
        [facebookBtn setEnabled:YES];
    }
    else {
        [facebookBtn setEnabled:NO];
    }
    [detailView setLeftConnectButton:facebookBtn];
    
    // Twitter button
    UIButton *twitterBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEConnectTwitterButton"
                                                          owner:self
                                                        options:nil] objectAtIndex:0];
    [twitterBtn setTag:SCEPlaceDetailButtonTagTwitter];
    [twitterBtn addTarget:self
                   action:@selector(buttonPress:)
         forControlEvents:UIControlEventTouchUpInside];
    if ([p twitterUsername] && [[p twitterUsername] length] > 0) {
        [twitterBtn setEnabled:YES];
    }
    else {
        [twitterBtn setEnabled:NO];
    }
    [detailView setMiddleConnectButton:twitterBtn];
    
    // Website button
    UIButton *websiteBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEConnectWebsiteButton"
                                                          owner:self
                                                        options:nil] objectAtIndex:0];
    [websiteBtn setTag:SCEPlaceDetailButtonTagWebsite];
    [websiteBtn addTarget:self
                   action:@selector(buttonPress:)
         forControlEvents:UIControlEventTouchUpInside];
    if ([p url] && [[p url] length] > 0) {
        [websiteBtn setEnabled:YES];
    }
    else {
        [websiteBtn setEnabled:NO];
    }
    [detailView setRightConnectButton:websiteBtn];
    
    [scrollView addSubview:detailView];

    // need to know the size of the detailView, so force layout and get size
    [detailView layoutSubviews];
    [detailView sizeToFit];
    
    // since map is now framed, we can call setRegion
    [mapView setRegion:MKCoordinateRegionMakeWithDistance([[self place] location], 300, 300) animated:false];
    
    [scrollView setContentSize:[detailView bounds].size];
    [self setView:scrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)buttonPress:(id)sender
{
    NSString *urlString;
    if ([sender tag] == SCEPlaceDetailButtonTagCall) {
        urlString = [NSString stringWithFormat:@"tel://%@",[[self place] phone]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        return;
    }
    else if ([sender tag] == SCEPlaceDetailButtonTagDirections) {
        // check iOS version by looking for "MKDirectionsRequest" class: new in iOS6
        NSString *daddr = [[[self place] daddr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        urlString = [NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%@", daddr];

        // if iOS version supports Apple maps, launch in separate app
        BOOL appleMapsSupport = (NSClassFromString(@"MKDirectionsRequest") != nil);
        if (appleMapsSupport) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            return;
        }
    }
    else if ([sender tag] == SCEPlaceDetailButtonTagFacebook) {
        urlString = [NSString stringWithFormat:@"http://www.facebook.com/%@", [[self place] facebookId]];
    }
    else if ([sender tag] == SCEPlaceDetailButtonTagTwitter) {
        urlString = [NSString stringWithFormat:@"http://www.twitter.com/%@", [[self place] twitterUsername]];
    }
    else if ([sender tag] == SCEPlaceDetailButtonTagWebsite) {
        urlString = [[self place] url];
        if (![urlString hasPrefix:@"http"]) {
            urlString = [@"http://" stringByAppendingString:urlString];
        }
    }
    else {
        return; // unrecognized sender tag; punt
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
