//
//  TCCTCatEyeCall.h
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/20.
//

#import "TCCloudTalkingBaseVC.h"
#import "Header.h"

//猫眼通话状态
typedef NS_ENUM(NSInteger, CatEyeCallStatus) {
    CatEyeCallStatus_NULL,    //未知
    CatEyeCallStatus_Call,    //被呼叫中
    CatEyeCallStatus_Talk,      //通话中
};

NS_ASSUME_NONNULL_BEGIN

@interface TCCTCatEyeCall : TCCloudTalkingBaseVC

@property (nonatomic, copy) NSString *callID;  //对讲账号

//通话状态回调
-(void)responseVoipManagerStatus:(UCSCallStatus)event callID:(NSString*)callid data:(UCSReason *)data withVideoflag:(int)videoflag;

@end

NS_ASSUME_NONNULL_END
