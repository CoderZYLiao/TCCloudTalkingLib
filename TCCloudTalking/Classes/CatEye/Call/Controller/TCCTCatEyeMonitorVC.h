//
//  TCCTCatEyeMonitorVC.h
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/20.
//

#import "TCCloudTalkingBaseVC.h"
#import "Header.h"

@class TCCTCatEyeModel;

NS_ASSUME_NONNULL_BEGIN

@interface TCCTCatEyeMonitorVC : TCCloudTalkingBaseVC

@property (nonatomic, strong) TCCTCatEyeModel *catEyeModel;

//通话状态回调
-(void)responseVoipManagerStatus:(UCSCallStatus)event callID:(NSString*)callid data:(UCSReason *)data withVideoflag:(int)videoflag;

@end

NS_ASSUME_NONNULL_END
