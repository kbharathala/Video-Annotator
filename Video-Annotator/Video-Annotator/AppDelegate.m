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
#import <AVFoundation/AVFoundation.h>
#import <Wit/Wit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [Wit sharedInstance].accessToken = @"5619c10f-ef52-40ae-a495-7f74c1d13330";
    [Wit sharedInstance].detectSpeechStop = WITVadConfigDetectSpeechStop;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    MainViewController *mainVC = [[MainViewController alloc] init];
    self.window.rootViewController = videoVC;
    [self.window makeKeyAndVisible];
    
    [ODClient setMicrosoftAccountAppId:@"0000000048160AF8" scopes:@[@"onedrive.readwrite"] ];
    
    return YES;
}

@end
