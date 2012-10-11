//
//  SCEWebViewController.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/11/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCEWebViewDelegate.h"

@interface SCEWebViewController : UIViewController <UIWebViewDelegate>
{
    UIBarButtonItem *backButton;
    UIBarButtonItem *forwardButton;
    UIBarButtonItem *closeButton;
}

@property (nonatomic, readonly) UIWebView *webView;
@property (nonatomic, strong) id<SCEWebViewDelegate> delegate;

- (void)closeButtonTapped:(id)sender;
- (void)backButtonTapped:(id)sender;
- (void)forwardButtonTapped:(id)sender;
- (void)updateToolbar;

@end
