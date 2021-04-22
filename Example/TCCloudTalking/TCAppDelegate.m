//
//  TCAppDelegate.m
//  TCCloudTalking
//
//  Created by TYL on 10/21/2019.
//  Copyright (c) 2019 TYL. All rights reserved.
//

#import "TCAppDelegate.h"
#import "ViewController.h"
#import "Header.h"
#import "JCManager.h"

@interface TCAppDelegate()
@property (nonatomic, strong) NSDictionary *pushInfo; //离线推送的信息
@property (nonatomic, strong) NSDictionary *userActivityInfo;
@end

@implementation TCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
