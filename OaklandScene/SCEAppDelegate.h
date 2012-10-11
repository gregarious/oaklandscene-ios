//
//  SCEAppDelegate.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/4/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCENoticesViewController;

@interface SCEAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    NSArray *contentStores;
    BOOL syncErrorDuringLoad;
    UIViewController *staticLaunchViewController;
    UITabBarController *tabBarController;
    
    SCENoticesViewController *noticesViewController;
}

@property (strong, nonatomic) UIWindow *window;

- (void)onContentStoreSync:(NSError *)err;

@end
