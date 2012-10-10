//
//  SCEAppDelegate.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/4/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEAppDelegate.h"

#import "SCEFeedViewController.h"
#import "SCEPlaceFeedViewController.h"
#import "SCEEventFeedViewController.h"
#import "SCESpecialFeedViewController.h"
#import "SCENewsFeedViewController.h"

#import "SCENoticesViewController.h"

#import "SCEItemStore.h"
#import "SCEPlaceStore.h"
#import "SCEEventStore.h"
#import "SCESpecialStore.h"
#import "SCENewsStore.h"

// amount of time before stores should be synced from server (24 hrs)
NSTimeInterval staleSyncThreshold = 60 * 60 * 24;

@implementation SCEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // TODO: debug
    UIView *launchView = [[UIView alloc] initWithFrame:[[self window] bounds]];
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"Loading"];
    [label sizeToFit];
    [launchView addSubview:label];
    
    staticLaunchViewController = [[UIViewController alloc] init];
    [staticLaunchViewController setView:launchView];
    self.window.rootViewController = staticLaunchViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{   
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // set up the static launch view controller
    self.window.rootViewController = staticLaunchViewController;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Initialize the stores
    contentStores = @[[SCEPlaceStore sharedStore],
                        [SCEEventStore sharedStore],
                        [SCESpecialStore sharedStore],
                        [SCENewsStore sharedStore]];
    
    syncErrorDuringLoad = NO;
    for (id<SCEItemStore> store in contentStores) {
        if ([store lastSynced] == nil ||
            -[[store lastSynced] timeIntervalSinceNow] > staleSyncThreshold)
        {
            NSLog(@"%@ out of date. Syncing now.", [store class]);
            [store syncContentWithCompletion:^void(NSArray *a, NSError *err) {
                [self onContentStoreSync:err];
            }];
        }
    }
    // in case no of the stores needed snc, this direct call will execute
    [self onContentStoreSync:nil];
}

- (void)onContentStoreSync:(NSError *)err
{
    if (err) {
        syncErrorDuringLoad = YES;
    }
    
    // ensure thread-saftey during sync checking
    @synchronized(contentStores) {
        for (id<SCEItemStore> store in contentStores) {
            if ([store syncInProgress]) {
                return;
            }
        }
    }
    
    // if we make it here, all the stores are synced
    if (syncErrorDuringLoad) {
        [[[UIAlertView alloc] initWithTitle:@"Connection Problem"
                                    message:@"There was a problem retreiving the most recent information."
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];

    }
    
    // Create the 5 VCs that will live under each tab
    SCENoticesViewController *noticesVC = [[SCENoticesViewController alloc] init];
    
    UINavigationController* placeVC = [[UINavigationController alloc]
                                       initWithRootViewController:[[SCEPlaceFeedViewController alloc] init]];
    UINavigationController* eventVC = [[UINavigationController alloc]
                                       initWithRootViewController:[[SCEEventFeedViewController alloc] init]];
    UINavigationController* specialVC = [[UINavigationController alloc]
                                         initWithRootViewController:[[SCESpecialFeedViewController alloc] init]];
    UINavigationController* newsVC = [[UINavigationController alloc]
                                      initWithRootViewController:[[SCENewsFeedViewController alloc] init]];
    
    // Set up the tab bar controller with the 5 sub VCs
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[noticesVC, placeVC, eventVC, specialVC, newsVC]];
    
    // set the window root controller
    [[self window] setRootViewController:tabBarController];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
