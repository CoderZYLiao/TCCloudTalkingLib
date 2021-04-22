//
//  CloudTalkingManager.m
//  CloudTalking_V5_SDK
//
//  Created by LiaoZhiYao on 2021/4/12.
//  Copyright © 2021 TC. All rights reserved.
//

#import "CloudTalkingManager.h"
#import "UCSVOIPViewEngine.h"

@interface CloudTalkingManager() <UCSTCPDelegateBase>
@property (nonatomic, assign) CloudTalkingType talkingType;
@end

@implementation CloudTalkingManager
 // 7363395161858048
- (void)initCloudTalkingWithAccount:(NSString *)account withType:(CloudTalkingType)type
{
    _talkingType = type;
    if (type == CloudTalkingTypeUCS) {  // 云之讯
        [[UCSTcpClient sharedTcpClientManager] setTcpDelegate:self];
        [UCSFuncEngine getInstance];
        [[UCSTcpClient sharedTcpClientManager] login_uninitWithFlag:NO];
        [[UCSTcpClient sharedTcpClientManager] login_connect:account  success:^(NSString *userId) {
            [self connectionSuccessful];
            [[UCSFuncEngine getInstance] creatTimerCheckCon];  //开启15秒连接定时检测
        } failure:^(UCSError *error) {
            [self connectionFailed:error.code];
        }];
    } else if (type == CloudTalkingTypeJuphone) {  // 菊风
        
    }
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

/**
 *  @brief 收到透传数据时回调
 *
 *  @param objcts 透传实体类
 */
- (void)didReceiveTransParentData:(UCSTCPTransParent *)objcts {
    
}

// 拨打电话之前先确定云之讯或者菊风已经连接
- (void)makingCallViewWithDoorMachineModel:(TCDoorMachineModel *)machineModel withCallType:(UCSCallTypeEnum)callType
{
    if (_talkingType == CloudTalkingTypeUCS) {
        // V520080492c47b6922b49ffa
        [[UCSVOIPViewEngine getInstance] makingCallViewCallNumber:machineModel.intercomUserId callType:UCSCallType_VideoPhone callName:machineModel.name];
    } else {
        
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

@end
