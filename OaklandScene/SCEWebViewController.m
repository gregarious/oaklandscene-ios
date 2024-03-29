//
//  SCEWebViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/11/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEWebViewController.h"

@implementation SCEWebViewController

@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Back to App"
                                                   style:UIBarButtonItemStyleDone
                                                  target:self
                                                  action:@selector(closeButtonTapped:)];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setHidesWhenStopped:YES];
    UIBarButtonItem *indicatorWrapperButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    UIBarButtonItem *spacer =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                    target:nil
                                                                    action:nil];
    
    backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left.png"]
                                                  style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(backButtonTapped:)];
    forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_right.png"]
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(forwardButtonTapped:)];
    
    [toolbar setItems:@[closeButton, indicatorWrapperButton, spacer, backButton, forwardButton]];
    [toolbar sizeToFit];
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    CGRect webViewFrame = frame;
    webViewFrame.origin.y += [toolbar bounds].size.height;
    webViewFrame.origin.y -= [[UIApplication sharedApplication] statusBarFrame].size.height;
    webViewFrame.size.height -= [toolbar bounds].size.height;
    
    webView = [[UIWebView alloc] initWithFrame:webViewFrame];
    [webView setScalesPageToFit:YES];
    [webView setDelegate:self];
    
    UIView *containerView = [[UIView alloc] initWithFrame:frame];
    [containerView addSubview:webView];
    [containerView addSubview:toolbar];

    [self setView:containerView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateToolbar];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    backButton = nil;
    forwardButton = nil;
    closeButton = nil;
    activityIndicator = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeButtonTapped:(id)sender
{
    [activityIndicator stopAnimating];
    [[self delegate] didCloseWebView:[self webView]];
}

- (void)backButtonTapped:(id)sender
{
    [[self webView] goBack];
}

- (void)forwardButtonTapped:(id)sender
{
    [[self webView] goForward];
}

- (void)updateToolbar
{
    [backButton setEnabled:[[self webView] canGoBack]];
    [forwardButton setEnabled:[[self webView] canGoForward]];
}

/***** UIWebViewDelegate methods *****/
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicator startAnimating];
    [self updateToolbar];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
    [self updateToolbar];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    [self updateToolbar];
    
    // TODO: can't use this now. gets called erreneously for every back button call, and
    //       some sites (e.g. FB link for Miller dentist)
//    [[[UIAlertView alloc] initWithTitle:@"Connection Problem"
//                                message:@"There was a problem connecting to this website."
//                               delegate:nil
//                      cancelButtonTitle:@"Ok"
//                      otherButtonTitles:nil] show];

}

@end
