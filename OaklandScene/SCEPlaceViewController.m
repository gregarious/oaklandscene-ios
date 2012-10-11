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
    SCEAboutView* aboutView = [[SCEAboutView alloc] init];
    [aboutView setAboutText:[[self place] description]];
    [detailView setAboutView:aboutView];

    
    SCEPlace *p = [self place];
    // action buttons
    UIButton *dirBtn, *callBtn;
    if ([p location].latitude != 0 && [p location].longitude != 0) {
        dirBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEDirectionsButton"
                                                owner:self
                                              options:nil] objectAtIndex:0];
        [dirBtn setTag:SCEPlaceDetailButtonTagDirections];
        [dirBtn addTarget:self
                   action:@selector(buttonPress:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([p phone] && [[p phone] length] >= 7) {
        callBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCECallButton"
                                                 owner:self
                                               options:nil] objectAtIndex:0];
        [callBtn setTag:SCEPlaceDetailButtonTagCall];
        [callBtn addTarget:self
                   action:@selector(buttonPress:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    
    // TODO: set up the button setting like an array, like UIToolbar
    if (dirBtn) {
        [detailView setLeftActionButton:dirBtn];
        if (callBtn) {
            [detailView setRightActionButton:callBtn];
        }
    }
    else if (callBtn) {
        [detailView setLeftActionButton:callBtn];
    }
    

    UIButton *facebookBtn, *twitterBtn, *websiteBtn;
    
    if ([p facebookId] && [[p facebookId] length] > 0) {
        facebookBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEConnectFacebookButton"
                                                     owner:self
                                                   options:nil] objectAtIndex:0];
        [facebookBtn setTag:SCEPlaceDetailButtonTagFacebook];
        [facebookBtn addTarget:self
                        action:@selector(buttonPress:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([p twitterUsername] && [[p twitterUsername] length] > 0) {
        twitterBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEConnectTwitterButton"
                                                    owner:self
                                                  options:nil] objectAtIndex:0];
        [twitterBtn setTag:SCEPlaceDetailButtonTagTwitter];
        [twitterBtn addTarget:self
                        action:@selector(buttonPress:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([p url] && [[p url] length] > 0) {
        websiteBtn = [[[NSBundle mainBundle] loadNibNamed:@"SCEConnectWebsiteButton"
                                                    owner:self
                                                  options:nil] objectAtIndex:0];
        [websiteBtn setTag:SCEPlaceDetailButtonTagWebsite];
        [websiteBtn addTarget:self
                       action:@selector(buttonPress:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    
    // TODO: Bwahahaha. Set up the button setting like an array, like UIToolbar
    if (facebookBtn) {
        [detailView setLeftConnectButton:facebookBtn];
        if (twitterBtn) {
            [detailView setMiddleConnectButton:twitterBtn];
            if (websiteBtn) {
                [detailView setRightConnectButton:websiteBtn];
            }
        }
        else if (websiteBtn) {
            [detailView setMiddleConnectButton:websiteBtn];
        }
    }
    else if (twitterBtn) {
        [detailView setLeftConnectButton:twitterBtn];
        if (websiteBtn) {
            [detailView setMiddleConnectButton:websiteBtn];
        }
    }
    else if (websiteBtn) {
        [detailView setLeftConnectButton:websiteBtn];
    }

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
    // TODO:
    // if facebook/twitter/website is the target, open in a webview
    // if directions is the target and iOS <6, open in a webview
    // need to trim parenthesis out of phone numbers
    
    NSString *protocol, *address;
    if ([sender tag] == SCEPlaceDetailButtonTagCall) {
        protocol = @"tel";
        address = [[self place] phone];
    }
    else if ([sender tag] == SCEPlaceDetailButtonTagDirections) {
        protocol = @"http";
        address = [NSString stringWithFormat:@"maps.apple.com/maps?daddr=%@", @"San+Francisco"];
    }
    else if ([sender tag] == SCEPlaceDetailButtonTagFacebook) {
        protocol = @"http";
        address = [NSString stringWithFormat:@"www.facebook.com/%@", [[self place] facebookId]];
    }
    else if ([sender tag] == SCEPlaceDetailButtonTagTwitter) {
        protocol = @"http";
        address = [NSString stringWithFormat:@"www.twitter.com/%@", [[self place] twitterUsername]];
    }
    else if ([sender tag] == SCEPlaceDetailButtonTagWebsite) {
        protocol = @"http";
        address = [[self place] url];
    }
    
    NSURL *appUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@",
                                          protocol, address]];
    [[UIApplication sharedApplication] openURL:appUrl];
}

@end
