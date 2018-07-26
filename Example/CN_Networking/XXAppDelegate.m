//
//  XXAppDelegate.m
//  CN_Networking
//
//  Created by obgniyum on 07/25/2018.
//  Copyright (c) 2018 obgniyum. All rights reserved.
//

#import "XXAppDelegate.h"
//#import "CN_Networking.h"
#import "CN_NET_Float.h"
#import "XX_Network.h"

@implementation XXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[CN_NET_Float CN_Instance] cn_show:YES];
    [CN_Network CN_DEBUG:CN_URL_SCHEME_HTTP host:@"192.168.0.136" port:@"8080"];
    [XX_Network CN_DEBUG:CN_URL_SCHEME_HTTP host:@"192.168.0.136" port:@"8080"];
    
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

@end
