//
//  TCAppDelegate.m
//  TCCloudTalking
//
//  Created by TYL on 10/21/2019.
//  Copyright (c) 2019 TYL. All rights reserved.
//

#import "TCAppDelegate.h"
#import "TCLoginViewController.h"

#import "TCNavigationController.h"
#import "Header.h"

//测试
#import "TCCLoginViewController.h"
#import "TCTextViewController.h"
#import "TCDoorVideoCallController.h"
#import "IFlyMSC/IFlyMSC.h"
#import "TCCHomeViewController.h"

#define APPID_VALUE           @"5ddceac9"
@interface TCAppDelegate()<UCSTCPDelegateBase>

@end

@implementation TCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

//    TCDoorVideoCallController *SmartDoorVc = [[TCDoorVideoCallController alloc] init];
//    SmartDoorVc.callerName = @"阿里落地N21-2号机";
//    TCCLoginViewController *SmartDoorVc = [[TCCLoginViewController alloc] init];
//    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:SmartDoorVc];
//    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
//    CATransition *anim = [CATransition animation];
//    anim.type = @"kCATransitionPush";
//    anim.duration = 1;
//    [[UIApplication sharedApplication].delegate.window.layer addAnimation:anim forKey:nil];
//     Override point for customization after application launch.
    [self gotoLoginInterface];
    //设置tcp代理
    [[UCSTcpClient sharedTcpClientManager] setTcpDelegate:self];
    //云对讲功能初始化
    [UCSFuncEngine getInstance];
    
    //讯飞SDK初始化
    //Set log level
    [IFlySetting setLogFile:LVL_ALL];
    
    //Set whether to output log messages in Xcode console
    [IFlySetting showLogcat:YES];
    
    //Set the local storage path of SDK
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //Set APPID
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //Configure and initialize iflytek services.(This interface must been invoked in application:didFinishLaunchingWithOptions:)
    [IFlySpeechUtility createUtility:initString];
    
    [self.window makeKeyAndVisible];
    return YES;
}

// 去登录页面
- (void)gotoLoginInterface
{
    
    //连接之前，先断开tcp连接，
    [[UCSTcpClient sharedTcpClientManager] login_uninitWithFlag:NO];
    
    TCHousesInfoModel *houesModel = [[TCPersonalInfoModel shareInstance] getHousesInfoModel];
    //        [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"Login开始登录"]];
    //连接云平台
    [[UCSTcpClient sharedTcpClientManager] login_connect:houesModel.intercomToken  success:^(NSString *userId) {
        //            [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"Login登录成功"]];
        NSString * log2 = [NSString stringWithFormat:@"%@:TCP链接成功\n",[self getNowTime]];
        
        [self connectionSuccessful];
        [[UCSFuncEngine getInstance] creatTimerCheckCon];//开启15秒连接定时检测
    } failure:^(UCSError *error) {
        //            [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"Login登录失败"]];
        NSString * log2 = [NSString stringWithFormat:@"%@:TCP链接失败 error：%u\n",[self getNowTime],error.code];
        
        [self connectionFailed:error.code];
    }];
    
    
}

-(void)connectionSuccessful
{
    NSLog(@"------对讲初始化成功");
    TCLoginViewController *LoginVc = [[TCLoginViewController alloc]init];
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:LoginVc];
    self.window.rootViewController = nav;
    LoginVc.loginSucceedAction = ^(NSInteger tag) {
//        TCCHomeViewController *TextVc = [[TCCHomeViewController alloc] init];
        TCTextViewController *TextVc = [[TCTextViewController alloc] init];
        TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:TextVc];
        [UIApplication sharedApplication].delegate.window.rootViewController = nav;
        CATransition *anim = [CATransition animation];
        anim.type = @"kCATransitionPush";
        anim.duration = 1;
        [[UIApplication sharedApplication].delegate.window.layer addAnimation:anim forKey:nil];
    };
}

-(void)connectionFailed:(UCSErrorCode) errorCode
{
    NSLog(@"------登录失败%u",errorCode);
    TCLoginViewController *LoginVc = [[TCLoginViewController alloc]init];
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:LoginVc];
    self.window.rootViewController = nav;
    LoginVc.loginSucceedAction = ^(NSInteger tag) {
//        TCCHomeViewController *TextVc = [[TCCHomeViewController alloc] init];
        TCTextViewController *TextVc = [[TCTextViewController alloc] init];
        TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:TextVc];
        [UIApplication sharedApplication].delegate.window.rootViewController = nav;
        CATransition *anim = [CATransition animation];
        anim.type = @"kCATransitionPush";
        anim.duration = 1;
        [[UIApplication sharedApplication].delegate.window.layer addAnimation:anim forKey:nil];
    };
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


#pragma mark - 登录注册日志
- (NSString *)getNowTime
{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}


@end
