//
//  TCCTCatEyeOperateVC.h
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/17.
//

#import "TCCloudTalkingBaseVC.h"
#import "TCCTCatEyeHeader.h"

NS_ASSUME_NONNULL_BEGIN

@class TCCTCatEyeModel;
@interface TCCTCatEyeOperateVC : TCCloudTalkingBaseVC

@property (nonatomic, assign) CatEyeDeviceOperate deviceOperate;
@property (nonatomic, strong) TCCTCatEyeModel *catEyeModel;

@end

NS_ASSUME_NONNULL_END
