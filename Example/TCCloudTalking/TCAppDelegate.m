//
//  TCAppDelegate.m
//  TCCloudTalking
//
//  Created by TYL on 10/21/2019.
//  Copyright (c) 2019 TYL. All rights reserved.
//

#import "TCAppDelegate.h"
#import "TCLoginViewController.h"
#import "TCCMianViewController.h"
#import "TCNavigationController.h"
#import "Header.h"
#import "JCManager.h"

//测试
#import "TCCLoginViewController.h"
#import "TCTextViewController.h"
#import "TCDoorVideoCallController.h"
#import "IFlyMSC/IFlyMSC.h"
#import "TCCHomeViewController.h"

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
//pushkit(音视频推送)
#import <PushKit/PushKit.h>

#import "JCManager.h"
#define APPID_VALUE           @"5ddceac9"
@interface TCAppDelegate()<JPUSHRegisterDelegate,UCSTCPDelegateBase,PKPushRegistryDelegate>
@property (nonatomic, strong) NSDictionary * pushInfo; //离线推送的信息
@property (nonatomic, strong) NSDictionary * userActivityInfo;

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
    
    
    
    //设置tcp代理
    [[UCSTcpClient sharedTcpClientManager] setTcpDelegate:self];
    //云对讲功能初始化
    [UCSFuncEngine getInstance];
    
    //菊风初始化
    [JCManager.shared initialize];
    
    [self gotoLoginInterface];
    
    [self registPushKit];
    /*
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
    
    //    [self InitJPushWithOptions:launchOptions];
    */
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSuccess:) name:kClientOnLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginFail:) name:kClientOnLoginFailNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clientStateChange:) name:kClientStateChangeNotification object:nil];
    
    return YES;
}

// 去登录页面
- (void)gotoLoginInterface
{

    TCUserModel *userModel = [[TCPersonalInfoModel shareInstance] getUserModel];
    if (userModel == nil) {
        TCLoginViewController *LoginVc = [[TCLoginViewController alloc]init];
        TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:LoginVc];
        self.window.rootViewController = nav;
        LoginVc.loginSucceedAction = ^(NSInteger tag) {
            //初始化云之讯
            [self LoginTcpClient];
            //初始化菊风
            [self LoginJCClient];
        };
        
    } else {
        //初始化云之讯
        [self LoginTcpClient];
        //初始化菊风
        [self LoginJCClient];
    }
    
    
    
    
    
}


- (void)LoginTcpClient
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
    TCCMianViewController *TextVc = [[TCCMianViewController alloc] init];
    
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:TextVc];
    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
    CATransition *anim = [CATransition animation];
    anim.type = @"kCATransitionPush";
    anim.duration = 1;
    [[UIApplication sharedApplication].delegate.window.layer addAnimation:anim forKey:nil];
}

-(void)connectionFailed:(UCSErrorCode) errorCode
{
    NSLog(@"------登录失败%u",errorCode);
    TCCMianViewController *TextVc = [[TCCMianViewController alloc] init];
    
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:TextVc];
    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
    CATransition *anim = [CATransition animation];
    anim.type = @"kCATransitionPush";
    anim.duration = 1;
    [[UIApplication sharedApplication].delegate.window.layer addAnimation:anim forKey:nil];
}


- (void)LoginJCClient
{

    if (JCManager.shared.client.state == JCClientStateLogined) {
        [JCManager.shared.client logout];
    }else if (JCManager.shared.client.state == JCClientStateIdle)
    {
        JCClientLoginParam* loginParam = [[JCClientLoginParam alloc] init];
        //国内服务器地址环境配置
        if ([JCManager.shared.client login:@"0123456789" password:@"123" loginParam:nil]) {
           debugLog(@"菊风服务器登录正常");
        }else
        {
            debugLog(@"菊风服务器登录异常");
        }
    }
}


#pragma mark notification

- (void)onLoginSuccess:(NSNotification *)info
{
    TCCMianViewController *TextVc = [[TCCMianViewController alloc] init];
    
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:TextVc];
    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
    CATransition *anim = [CATransition animation];
    anim.type = @"kCATransitionPush";
    anim.duration = 1;
    [[UIApplication sharedApplication].delegate.window.layer addAnimation:anim forKey:nil];
    debugLog(@"菊风服务器登录成功");
}

- (void)onLoginFail:(NSNotification *)info
{
    debugLog(@"菊风服务器登录失败---%@",info);
}

- (void)clientStateChange:(NSNotification*)info
{
    JCClientState state = JCManager.shared.client.state;
    if (state == JCClientStateIdle) {
        debugLog(@"登录");

    } else if (state == JCClientStateLogined) {
        debugLog(@"已登录");
        
    } else if (state == JCClientStateLogining) {
        
        debugLog(@"登录中");
    } else if (state == JCClientStateLogouting) {
        
        debugLog(@"登出中");
    }
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


#pragma mark - JPUSH

- (void)InitJPushWithOptions:(NSDictionary *)launchOptions
{
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:@"7f6d1a683520458f42d42738"
                          channel:@"App Store"
                 apsForProduction:NO
            advertisingIdentifier:nil];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:TCUserId];
    if (userId.length > 0) {
        [JPUSHService setAlias:userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            if (iResCode == 0) {
                NSLog(@"设置别名成功");
            } else {
                NSLog(@"设置别名失败");
            }
        } seq:0];
    }
}

#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    // 把云停车的消息按钮标红，同时去掉badge（云停车页面没初始化的情况下无法标红问题）
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)didConnectionStatusChanged:(UCSConnectionStatus)connectionStatus error:(UCSError *)error
{
    switch (connectionStatus) {
        case UCSConnectionStatus_BeClicked:
            [self kickOff];
            break;
        case UCSConnectionStatus_ReConnectFail:
            [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectStateNotification object:UCTCPDisConnectNotification];
            break;
        case UCSConnectionStatus_StartReConnect:
            [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectStateNotification object:UCTCPConnectingNotification];
            break;
        case UCSConnectionStatus_ReConnectSuccess:
            [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectStateNotification object:UCTCPDidConnectNotification];
            [self launchCall:_pushInfo];
            [self launchUserAvtivity];
            [[UCSFuncEngine getInstance] stopTimerConnect];
            break;
        case UCSConnectionStatus_loginSuccess:
            [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectStateNotification object:UCTCPDidConnectNotification];
            [self launchCall:_pushInfo];
            [self launchUserAvtivity];
            break;
        case UCSConnectionStatus_ConnectFail:
            [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectStateNotification object:UCTCPDisConnectNotification];
            break;
        default:
            break;
    }
}

/**
 *  @brief 收到透传数据时回调
 *
 *  @param objcts 透传实体类
 */
- (void)didReceiveTransParentData:(UCSTCPTransParent *)objcts {
    
}


- (void)launchUserAvtivity{
    if (_userActivityInfo == nil) { return ;}
    NSString * handle = _userActivityInfo[@"handle"];
    int  type = [_userActivityInfo[@"type"] intValue];
    [[UCSVOIPViewEngine getInstance] makingCallViewCallNumber:handle callType:type callName:handle];
    _userActivityInfo = nil;
}

- (void)kickOff
{
    
    // 被踢下线时 防止下次直接后台登录 清空token
    [[NSNotificationCenter defaultCenter] postNotificationName:TCPKickOffNotification object:nil];
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前账号在别处登录了" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //用户退出登录执行
        //        [LoginOutTool UserLogout];
    }];
    [alertView addAction:okAction];
    [_window.rootViewController presentViewController:alertView animated:YES completion:nil];
}

#pragma mark 注册pushkit 和 代理方法
- (void)registPushKit{
    if (UCS_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(8.0)) {
        PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:nil];
        pushRegistry.delegate = self;
        pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
        [[NSString stringWithFormat:@"------coming-----registPushKit--------"] saveTolog];
        //    [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"向苹果注册PushKit"]];
    }
}
//VoIP Push Token获取
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type{
    NSString *str = [NSString stringWithFormat:@"%@",credentials.token];
    NSString * _tokenStr = [[[str stringByReplacingOccurrencesOfString:@"<" withString:@""]
                             stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSString stringWithFormat:@"pushkit_didUpdatePushCredentials: %@", _tokenStr] saveTolog];
    
    [[UCSTcpClient sharedTcpClientManager] setVoipServiceToken:credentials.token];
    //    [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"收到苹果下发的PushKitDeviceToken"]];
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type {
    
    [[NSString stringWithFormat:@"didReceiveIncomingPushWithPayload: %@", payload.description] saveTolog];
    
    
    if (type == PKPushTypeVoIP) {
        _tmpdictionaryPayload = payload.dictionaryPayload;
        
        WEAKSELF
        
        
        
        TCHousesInfoModel *houesModel = [[TCPersonalInfoModel shareInstance] getHousesInfoModel];
        
        //02
        //     [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"收到VPush:vpinfo->%@_token->%@",[self getRemotePushInfo:payload.dictionaryPayload],[[InfoManager sharedInfoManager].imtoken substringToIndex:5]]];
        
        
        [[NSString stringWithFormat:@"dictionaryPayload: %@", _tmpdictionaryPayload.description] saveTolog];
        
        NSString *callid = _tmpdictionaryPayload[@"e"][@"callid"];
        
        if (callid) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //03
                //                 [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"收到VPush开始登录"]];
                
                [[UCSTcpClient sharedTcpClientManager] login_connect:houesModel.intercomToken  success:^(NSString *userId) {
                    //04
                    //                    [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"收到VPush登录成功"]];
                    
                    
                    [weakSelf saveRemotePushInfo:[weakSelf.tmpdictionaryPayload copy]];
                    
                    
                    
                    
                    [[UCSFuncEngine getInstance] stopTimerConnect];
                } failure:^(UCSError *error) {
                    //05
                    [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"VPush登录失败,c->%d d->%@",error.code,error.errorDescription]];
                    
                    weakSelf.tmpdictionaryPayload = nil;
                    
                }];
                
                
            });
        }
        
        
    }
    
}

//------------------//收到远程通知后，拉起来电 有参数版本--------------------------------//
- (void)saveRemotePushInfo:(NSDictionary *)userInfo{
    _pushInfo = nil;
    NSString * callid = userInfo[@"e"][@"callid"];
    NSString * vpsId = userInfo[@"e"][@"vid"];
    
    [[NSString stringWithFormat:@"saveRemotePushInfo: %@ %@\n", callid, vpsId] saveTolog];
    _pushInfo =  (callid && vpsId) ? userInfo : nil;
    
    if ([[UCSTcpClient sharedTcpClientManager] login_isConnected]) {
        [self launchCall:_pushInfo];
    }
}

//收到远程通知后，拉起来电
- (void)launchCall:(NSDictionary *)info{
    
    if (_pushInfo == nil)  return;
    
    [[NSString stringWithFormat:@"launchCall:%@", info.description] saveTolog];
    
    NSString * callid = info[@"e"][@"callid"];
    NSString * vpsId = info[@"e"][@"vid"];
    [[UCSFuncEngine getInstance] callIncomingPushRsp:callid withVps:vpsId.integerValue withReason:0];
    
    
    _pushInfo = nil;
}
//------------------//收到远程通知后，拉起来电 有参数版本--------------------------------//


@end
