//
//  AppDelegate.m
//  Video-Annotator
//
//  Created by Krishna Bharathala on 10/9/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "AppDelegate.h"
#import "VideoViewController.h"
#import "MainViewController.h"

#import <OneDriveSDK/OneDriveSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    MainViewController *mainVC = [[MainViewController alloc] init];
    self.window.rootViewController = videoVC;
    [self.window makeKeyAndVisible];
    
    [ODClient setMicrosoftAccountAppId:@"0000000048160AF8" scopes:@[@"onedrive.readwrite"] ];
    
    return YES;
}

@end
