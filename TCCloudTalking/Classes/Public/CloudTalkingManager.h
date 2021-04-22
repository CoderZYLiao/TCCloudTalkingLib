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
- (void)initCloudTalkingWithAccount:(NSString *)account withType:(CloudTalkingType)type;
- (void)makingCallViewWithDoorMachineModel:(TCDoorMachineModel *)machineModel withCallType:(UCSCallTypeEnum)callType;
@end

NS_ASSUME_NONNULL_END
