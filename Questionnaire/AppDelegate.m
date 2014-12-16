//
//  AppDelegate.m
//  Questionnaire
//
//  Created by Srinivas Varada on 15/12/14.
//  Copyright (c) 2014 Srinivas Varada. All rights reserved.
//

#import "AppDelegate.h"
#include "CommonAppManager.h"
#import "DBManager.h"
#import "PaperFoldNavigationController.h"
#import "ViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "TGLViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blueColor];
    [self.window makeKeyAndVisible];
    
    
    DBManager *db1 = [DBManager sharedAppManager];

    int success = [db1 createEditableCopyOfDB:@"SyncDataBase.sqlite"];
    
    [Parse setApplicationId:@"zbBECvRVktXCYC76RJ8nY9ZkPo80A2A6qvyhBqDN" clientKey:@"kHcNzQt4atPvKPTtU1D4BePm47PYFKrC7tAQ6Avm"];
    
    TGLViewController *contentViewController = [[TGLViewController alloc] initWithNibName:@"TGLViewController" bundle:[NSBundle mainBundle]];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:contentViewController];
    [navController.navigationBar setHidden:YES];
    
    
    PaperFoldNavigationController *paperFoldNavController = [[PaperFoldNavigationController alloc] initWithRootViewController:navController];
    [self.window setRootViewController:paperFoldNavController];
    
    LeftViewController *leftViewController = [[LeftViewController alloc] init];
    UINavigationController *leftNavController = [[UINavigationController alloc] initWithRootViewController:leftViewController];
    [leftNavController setNavigationBarHidden:YES];
    [paperFoldNavController setLeftViewController:leftNavController width:150];
    
    RightViewController *rightViewController = [[RightViewController alloc] init];
    UINavigationController *rightNavController = [[UINavigationController alloc] initWithRootViewController:rightViewController];
    [rightNavController setNavigationBarHidden:YES];
    [paperFoldNavController setRightViewController:rightNavController width:150.0 rightViewFoldCount:3 rightViewPullFactor:0.9];
    
    BOOL isSyncSuccess = [[NSUserDefaults standardUserDefaults] boolForKey:@"ISSyncSuccess"];
    
    if (!isSyncSuccess) {
       
        [[CommonAppManager sharedAppManager] sync];
    
    }
    else{
        
        [[CommonAppManager sharedAppManager] getDataFromLocalDB];
        
    }
    


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
