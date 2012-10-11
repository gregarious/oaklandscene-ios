//
//  SCESpecialViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/6/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCESpecialViewController.h"
#import "SCESpecial.h"
#import "SCESpecialDetailHeadView.h"
#import "SCESpecialDetailView.h"
#import "SCEURLImage.h"
#import "SCESimpleAnnotation.h"
#import "SCEAboutView.h"
#import "SCESpecialRedeemPrompt.h"
#import "SCEPlace.h"
#import "SCEPlaceStubView.h"
#import "SCEPlaceViewController.h"
#import "SCEPlaceStore.h"
#import "SCEWebViewController.h"

@implementation SCESpecialViewController

@synthesize special;

- (id)initWithSpecial:(SCESpecial *)s
{
    self = [super init];
    if (self) {
        [self setSpecial:s];
        [self setTitle:[s title]];
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
    SCESpecialDetailView *detailView = [[SCESpecialDetailView alloc] initWithFrame:frame];
    
    // map view
    MKMapView *mapView = [[MKMapView alloc] init];
    [detailView setMapView:mapView];
    [mapView addAnnotation:[SCESimpleAnnotation annotationWithCoordinate:[[[self special] place] location]
                                                                   title:nil
                                                                subtitle:nil
                                                              resourceId:nil]];

    // can't set the region till the subview is framed: do it at the bottom of this method

    
    // header view
    SCESpecialDetailHeadView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"SCESpecialDetailHeadView"
                                                                        owner:self
                                                                      options:nil] objectAtIndex:0];
    [[headerView titleLabel] setText:[[self special] title]];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateStyle:NSDateFormatterLongStyle];
    NSString *expString = [fmt stringFromDate:[[self special] expiresDate]];
    [[headerView expiresLabel] setText:[NSString stringWithFormat: @"Expires %@", expString]];

    [detailView setHeaderView:headerView];

    // place stub view
    SCEPlaceStubView *placeStub = [[[NSBundle mainBundle] loadNibNamed:@"SCEPlaceStubView"
                                                                 owner:self
                                                               options:nil] objectAtIndex:0];
    [[placeStub nameLabel] setText:[[[self special] place] name]];
    [[placeStub addressLabel] setText:[[[self special] place] streetAddress]];
    [detailView setPlaceStubView:placeStub];
    
    [placeStub setDelegate:self];
    
    if (![[[SCEPlaceStore sharedStore] items] containsObject:[[self special] place]]) {
        [[placeStub placePageButton] setEnabled:NO];
    }
    
    if (![[[self special] place] daddr]) {
        [[placeStub placePageButton] setEnabled:NO];
    }
    
    // TODO: hook up button actions
    
    // redeem prompt
    SCESpecialRedeemPrompt *redeemPrompt = [[[NSBundle mainBundle] loadNibNamed:@"SCESpecialRedeemPrompt"
                                                                          owner:self
                                                                        options:nil] objectAtIndex:0];
    NSString *instructions = [NSString stringWithFormat:@"Show this screen at %@ to redeem this special!",
                                                        [[[self special] place] name]];
    NSString *imgUrl = [[[self special] place] imageUrl];
    if (imgUrl) {
        [[SCEURLImageStore sharedStore] fetchImageWithURLString:imgUrl
                                                   onCompletion:
         ^void(UIImage *image, NSError *err) {
             if (image) {
                [[redeemPrompt thumbnail] setImage:image];
             }
         }];
    }
    [[redeemPrompt instructionsLabel] setText:instructions];
    [detailView setRedeemView:redeemPrompt];
    
    // about text area
    NSString *aboutText = [[self special] description];
    if (!aboutText || [aboutText length] > 0) {
        SCEAboutView *aboutView = [[SCEAboutView alloc] init];
        [aboutView setAboutText:aboutText];
        [detailView setAboutView:aboutView];
    }
    
    [scrollView addSubview:detailView];

    // need to know the size of the detailView, so force layout and get size
    [detailView layoutSubviews];
    [detailView sizeToFit];

    // since map is now framed, we can call setRegion
    [mapView setRegion:MKCoordinateRegionMakeWithDistance([[[self special] place] location], 300, 300) animated:false];
    
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
    NSString *placeId = [[[self special] place] resourceId];
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
    NSString *daddr = [[[[self special] place] daddr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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

- (void)didCloseWebView:(UIWebView *)view
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
