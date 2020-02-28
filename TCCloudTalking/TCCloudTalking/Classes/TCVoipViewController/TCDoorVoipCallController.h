//
//  TCDoorVoipCallController.h
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/19.
//

#import <UIKit/UIKit.h>
#import "UCSFuncEngine.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCDoorVoipCallController : UIViewController
{
    int hhInt;
    int mmInt;
    int ssInt;
    NSTimer *timer;
    
    NSInteger voipCallType; //0:免费网络通话 1:单向外呼
}


@property (nonatomic,copy) NSString *callID;
@property (nonatomic,copy) NSString *callerNo;  //直拨电话号码
@property (nonatomic,copy) NSString *voipNo;
@property (retain,nonatomic) NSString *callerName;
@property (assign,nonatomic) UCSCallTypeEnum callType;



@property (assign,nonatomic) BOOL incomingCall; //WLS，2015-12-09，(处于被叫界面)


@property (copy,nonatomic) NSString * callDuration; // WLS，2015-12-18，(通话时间)
@property (assign,nonatomic) BOOL isCallNow; // WLS，2015-12-18，(是否处于通话状态)
@property (assign,nonatomic) BOOL beReject; // WLS，2015-12-21，(被叫是否拒绝接听)
@property (assign,nonatomic) BOOL hangupMySelf; // WLS，2016-11-19，(是否是自己点击了挂断按钮)

@property (copy,nonatomic) NSString * currentTime; // WLS，2016-01-13，(当前收到来电的时间或者发起通话的时间)

@property (nonatomic, assign) bool isGroupDail; //是否同振呼叫


/*
 phoneNo:被叫人的真正的电话号，用于单向外呼
 voipNop:被叫人的voip账号，用于网络免费电话(也可用于界面的显示,自己选择)
 type:电话类型
 */
- (TCDoorVoipCallController *)initWithCallerNo:(NSString *)phoneNo andVoipNo:(NSString *)voipNop andCallType:(NSInteger)type;



-(void)responseVoipManagerStatus:(UCSCallStatus)event callID:(NSString*)callid data:(UCSReason *)data withVideoflag:(int)videoflag;

/**
 @author WLS, 15-12-19 15:12:49
 
 网络状态回调
 
 @param currentNetwork 当前的网络状态
 */
- (void)networkStatusChange:(NSInteger)currentNetwork;
@end

NS_ASSUME_NONNULL_END
