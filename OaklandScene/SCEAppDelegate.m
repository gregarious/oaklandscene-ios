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

#import "SCETodayViewController.h"

@implementation SCEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    // Set up the 5 main tab controllers
    UIViewController *todayController = [[SCETodayViewController alloc] init];
    UIViewController *placesController = [[SCEPlaceFeedViewController alloc] init];
    UIViewController *eventsController = [[SCEEventFeedViewController alloc] init];
    UIViewController *specialsController = [[SCESpecialFeedViewController alloc] init];
    UIViewController *newsController = [[SCENewsFeedViewController alloc] init];
    
    // Configure the tab bar controller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[todayController,
                                            placesController,
                                            eventsController,
                                            specialsController,
                                            newsController]];

    // TODO: move this somewhere more appropriate (probably a custom tab bar class)
    [[tabBarController navigationItem] setTitle:@"Feeds"];
    UIBarButtonItem *viewModeButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Map"
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(toggleViewMode:)];
    [[tabBarController navigationItem] setLeftBarButtonItem:viewModeButton];
    
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                     target:self
                                     action:@selector(searchFeed:)];
    [[tabBarController navigationItem] setRightBarButtonItem:searchButton];

    
    
    // wrap the tab bar controller in the main nav controller
    self.navController = [[UINavigationController alloc]
                             initWithRootViewController:tabBarController];
    
    // set the window root controller
    self.window.rootViewController = self.navController;
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
