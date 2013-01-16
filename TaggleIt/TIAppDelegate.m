//
//  TIAppDelegate.m
//  TaggleIt
//
//  Created by Sadasivan Arun on 11/21/12.
//  Copyright (c) 2012 Sadasivan Arun. All rights reserved.
//

#import "TIAppDelegate.h"

#import "TIViewController.h"
#import "DAUtility.h"
#import "DAConstants.h"

@implementation TIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self addDatabaseToDocumentsFolder];
    self.viewController = [[TIViewController alloc] initWithNibName:@"TIViewController" bundle:nil];
    
    UINavigationController *controller = [[UINavigationController alloc]initWithRootViewController:self.viewController];
    
    self.window.rootViewController = controller;
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

-(BOOL) addDatabaseToDocumentsFolder
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *destPath = [DAUtility getDocumentPathForUserDB];
    
    NSString *pathToFileInBundle = [[NSBundle mainBundle]pathForResource:DatabaseNameWithoutExt ofType:@"sqlite"];
    
    NSError *error = nil;
    
    return [fileManager copyItemAtPath:pathToFileInBundle toPath:destPath error:&error];
}

@end
