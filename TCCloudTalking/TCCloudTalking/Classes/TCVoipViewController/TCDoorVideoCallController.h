//
//  TCDoorVideoCallController.h
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/19.
//

#import <UIKit/UIKit.h>
#import "Header.h"
NS_ASSUME_NONNULL_BEGIN

@interface TCDoorVideoCallController : UIViewController
{
    int hhInt;
    int mmInt;
    int ssInt;
    NSTimer *timer;
    
    
}

@property (nonatomic,retain) NSString *callID;
@property (nonatomic,retain) NSString *callerName;
@property (nonatomic,retain) NSString *voipNo;

@property (assign,nonatomic) BOOL incomingCall; //WLS，2015-12-14，(处于被叫界面)

@property (nonatomic, assign) BOOL isActivity; //WLS，2015-12-14，是否是从后台进入前台

@property (copy,nonatomic) NSString * callDuration; // WLS，2015-12-18，(通话时间)
@property (assign,nonatomic) BOOL isCallNow; // WLS，2015-12-18，(是否处于通话状态)
@property (assign,nonatomic) BOOL beReject; // WLS，2015-12-21，(被叫是否拒绝接听)
@property (assign,nonatomic) BOOL hangupMySelf; // WLS，2016-11-19，(是否是自己点击了挂断按钮)

@property (copy,nonatomic) NSString * currentTime; // WLS，2016-01-13，(当前收到来电的时间或者发起通话的时间)

@property (nonatomic, assign) bool isGroupDail; //是否同振呼叫


/*name:被叫人的姓名，用于界面的显示(自己选择)
 voipNop:被叫人的voip账号，用于网络免费电话(也可用于界面的显示,自己选择)
 */
- (TCDoorVideoCallController *)initWithCallerName:(NSString *)name  andVoipNo:(NSString *)voipNo;


-(void)responseVoipManagerStatus:(UCSCallStatus)event callID:(NSString*)callid data:(UCSReason *)data withVideoflag:(int)videoflag;


- (void)networkStatusChange:(NSInteger)currentNetwork;

//- (void)networkDetailChange:(NSString *)currentNetworkDetail;

- (void)onReceivedPreviewImg:(UIImage *)image  callid:(NSString *)callid error:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
