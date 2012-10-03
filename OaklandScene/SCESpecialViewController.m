//
//  SCESpecialViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/6/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCESpecialViewController.h"
#import "SCESpecial.h"
//#import "SCESpecialDetailHeadView.h"
#import "SCESpecialDetailView.h"
#import "SCEURLImage.h"

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
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [l setText:[[self special] title]];
    [detailView setTestLabel:l];
    
    // TODO: set up the rest of the subviews
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
