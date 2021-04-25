//
//  CloudTalkingManager.m
//  CloudTalking_V5_SDK
//
//  Created by LiaoZhiYao on 2021/4/12.
//  Copyright © 2021 TC. All rights reserved.
//

#import "CloudTalkingManager.h"
#import "UCSVOIPViewEngine.h"
#import "JCManager.h"

@interface CloudTalkingManager() <UCSTCPDelegateBase>

@end

@implementation CloudTalkingManager


#pragma mark - 初始化

 // 音视频服务提供商UCS初始化
- (void)initUCSCloudTalkingWithToken:(NSString *)token
{
    [[UCSTcpClient sharedTcpClientManager] setTcpDelegate:self];
    [UCSFuncEngine getInstance];
    [[UCSTcpClient sharedTcpClientManager] login_uninitWithFlag:NO];
    [[UCSTcpClient sharedTcpClientManager] login_connect:token  success:^(NSString *userId) {
        [self connectionSuccessful];
        [[UCSFuncEngine getInstance] creatTimerCheckCon];  //开启15秒连接定时检测
    } failure:^(UCSError *error) {
        [self connectionFailed:error.code];
    }];
}

// 音视频服务提供商Juphone初始化 cad1a228ea4733f68b1a5097
- (void)initJuphoneCloudTalkingWithServerAddress:(NSString *)serverAddress withAppKey:(NSString *)appKey withAccount:(NSString *)account
{
    [JCManager.shared initializeWithAppKey:appKey];  // 初始化菊风
    [self LoginJCClientWithServerAddress:serverAddress withAppKey:appKey withAccount:account];
    // 菊风消息监测
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSuccess:) name:kClientOnLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginFail:) name:kClientOnLoginFailNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clientStateChange:) name:kClientStateChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kickOff) name:kClientOnLogoutNotification object:nil];
}

#pragma mark - 云之讯相关

-(void)connectionSuccessful
{
//    debugLog(@"------对讲初始化成功");
}

-(void)connectionFailed:(UCSErrorCode) errorCode
{
//    debugLog(@"------登录失败%u",errorCode);
}

- (void)didConnectionStatusChanged:(UCSConnectionStatus)connectionStatus error:(UCSError *)error
{
    switch (connectionStatus) {
        case UCSConnectionStatus_BeClicked:
//            [self kickOff];
            break;
        case UCSConnectionStatus_ReConnectFail:
//            [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectStateNotification object:UCTCPDisConnectNotification];
            break;
        case UCSConnectionStatus_StartReConnect:
//            [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectStateNotification object:UCTCPConnectingNotification];
            break;
        case UCSConnectionStatus_ReConnectSuccess:
//            [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectStateNotification object:UCTCPDidConnectNotification];
            [[UCSFuncEngine getInstance] stopTimerConnect];
            break;
        case UCSConnectionStatus_loginSuccess:
//            [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectStateNotification object:UCTCPDidConnectNotification];
            break;
        case UCSConnectionStatus_ConnectFail:
//            [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectStateNotification object:UCTCPDisConnectNotification];
            break;
        default:
            break;
    }
}

// 拨打电话之前先确定云之讯或者菊风已经连接
- (void)makingCallViewVideoWithDoorMachineModel:(TCDoorMachineModel *)machineModel withCloudTalkingType:(CloudTalkingType)callType
{
    if (callType == CloudTalkingTypeUCS) {
        // V520080492c47b6922b49ffa
        [[UCSVOIPViewEngine getInstance] makingCallViewCallNumber:machineModel.intercomUserId callType:UCSCallType_VideoPhone callName:machineModel.name];
    } else {
        if (JCManager.shared.client.state == JCClientStateLogined) {
          JCCallParam *callParam = [[JCCallParam alloc] init];
          [callParam setExtraParam:machineModel.name];
          bool value = [JCManager.shared.call call:machineModel.intercomUserId video:true callParam:callParam];
          if (value) {
             NSLog(@"菊风调用call方法成功");
          }
      } else {
          NSLog(@"对讲账号异常，请重新登录应用");
      }
    }
}

- (void)openTheDoorWithDoorName:(NSString *)DoorName TalkID:(NSString *)TalkID withHouseInfoId:(NSString *)houseInfoId
{
    if ([[UCSTcpClient sharedTcpClientManager] login_isConnected]) {
        NSDictionary * dict1 = @{
            @"messageSenderType" : @(2),
            @"formuid" : houseInfoId
        };
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict1 options:NSJSONWritingPrettyPrinted error:nil];
        NSString *UMessage = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //开锁第二通道(在第一通道开锁不成功的情况下调用)
        UCSTCPTransParentRequest *request = [UCSTCPTransParentRequest initWithCmdString:UMessage receiveId:TalkID];
        [[UCSTcpClient sharedTcpClientManager] sendTransParentData:request success:^(UCSTCPTransParentRequest *request) {
//            NSString *tmpack = [NSString stringWithFormat:@"发送成功:ackData-->%@",request.ackData];
        } failure:^(UCSTCPTransParentRequest *request, UCSError *error) {
            
        }];
    }
}

#pragma mark - 菊风相关

- (void)LoginJCClientWithServerAddress:(NSString *)serverAddress withAppKey:(NSString *)appKey withAccount:(NSString *)account
{
    if (JCManager.shared.client.state == JCClientStateLogined) {
        [JCManager.shared.client logout];
    }
    
    if (JCManager.shared.client.state == JCClientStateIdle) {
        if ([JCManager.shared.client login:account password:@"tc123456" serverAddress:serverAddress loginParam:nil]) {
            NSLog(@"菊风服务器登录调用正常");
        } else {
            NSLog(@"菊风服务器登录调用异常");
        }
    }
}

- (void)onLoginSuccess:(NSNotification *)info
{
    NSLog(@"菊风服务器登录成功");
}

- (void)onLoginFail:(NSNotification *)info
{
    NSLog(@"菊风服务器登录失败---%@",info);
}

- (void)clientStateChange:(NSNotification*)info
{
    JCClientState state = JCManager.shared.client.state;
    if (state == JCClientStateIdle) {
        NSLog(@"登录");
    } else if (state == JCClientStateLogined) {
        NSLog(@"已登录");
    } else if (state == JCClientStateLogining) {
        NSLog(@"登录中");
    } else if (state == JCClientStateLogouting) {
        NSLog(@"登出中");
    }
}

@end
