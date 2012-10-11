//
//  SCEWebViewDelegate.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/11/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIWebView;

@protocol SCEWebViewDelegate <NSObject>

- (void)didCloseWebView:(UIWebView*)view;

@end
