//
//  SCENewsViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/6/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCENewsViewController.h"
#import "SCENewsStubView.h"
#import "SCENewsStub.h"

@implementation SCENewsViewController

@synthesize newsStub;

- (id)initWithNewsStub:(SCENewsStub *)n
{
    self = [super init];
    if (self) {
        [self setNewsStub:n];
        [self setTitle:[n title]];
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[[self parentViewController] view] bounds];
    UIScrollView *scrollView = [[UIScrollView alloc]
                                initWithFrame:frame];
    
    // set up the detailView
    SCENewsStubView *detailView = [[SCENewsStubView alloc] initWithFrame:frame];
    [[detailView headlineLabel] setText:[[self newsStub] title]];
    [[detailView publicationDateLabel] setText:
        [NSDateFormatter localizedStringFromDate:[[self newsStub] publicationDate]
                                       dateStyle:NSDateFormatterLongStyle
                                       timeStyle:NSDateFormatterNoStyle]];

    // hook up button to open link
    [[detailView openSourceButton] addTarget:self
                                      action:@selector(buttonPress:)
                            forControlEvents:UIControlEventTouchUpInside];
    
    [[detailView sourceNameLabel] setText:[[self newsStub] source]];
    [[detailView blurbLabel] setText:[[self newsStub] blurb]];
    
    [scrollView addSubview:detailView];
    
    // need to know the size of the detailView, so force layout and get size
    [detailView layoutSubviews];
    [detailView sizeToFit];
    
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

- (void)buttonPress:(id)sender
{
    // TODO: open in a webview and add http:// if necessary
    
    // only handles website button
    NSURL *url = [NSURL URLWithString:[[self newsStub] url]];
    [[UIApplication sharedApplication] openURL:url];
}

@end
