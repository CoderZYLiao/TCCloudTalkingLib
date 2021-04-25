//
//  CloudTalkingManager.h
//  CloudTalking_V5_SDK
//
//  Created by LiaoZhiYao on 2021/4/12.
//  Copyright © 2021 TC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCSTCPDelegateBase.h"
#import "UCSTcpDefine.h"
#import "TCDoorMachineModel.h"
#import "UCSTCPCommonClass.h"
#import "UCSFuncEngine.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum
{
    CloudTalkingTypeUCS,        //接受消息
    CloudTalkingTypeJuphone
} CloudTalkingType;

@interface CloudTalkingManager : NSObject
// 音视频服务提供商UCS初始化
- (void)initUCSCloudTalkingWithToken:(NSString *)token;
// 音视频服务提供商Juphone初始化 cad1a228ea4733f68b1a5097
- (void)initJuphoneCloudTalkingWithServerAddress:(NSString *)serverAddress withAppKey:(NSString *)appKey withAccount:(NSString *)account;
- (void)makingCallViewVideoWithDoorMachineModel:(TCDoorMachineModel *)machineModel withCloudTalkingType:(CloudTalkingType)callType;
@end

NS_ASSUME_NONNULL_END
