//
//  UCSCallEvent.h
//  yzxapisdk
//
//  Created by tongkucky on 14-4-2.
//  Copyright (c) 2014年 yzx. All rights reserved.
//
#import "UCSCommonClass.h"
#import "UCSVideoDefine.h"

@protocol UCSEventDelegate<NSObject>



@optional
#pragma mark 初始化函数代理
//引擎初始化成功
- (void)onInitEngineSuccessful:(NSInteger)result;



#pragma mark - 互联网音频通话的代理
//收到来电回调
- (void)onIncomingCall:(NSString*)callid withcalltype:(UCSCallTypeEnum) callType withcallinfo:(NSDictionary*)callinfo;

//呼叫振铃回调
-(void)onAlerting:(NSString*)called;

//接听回调
-(void) onAnswer:(NSString*)callid;

//呼叫失败回调
- (void) onDialFailed:(NSString*)callid  withReason:(UCSReason*)reason;

//释放通话回调
- (void) onHangUp:(NSString*)callid withReason:(UCSReason*)reason;

//语音质量上报回调
- (void)onNetWorkState:(UCSNetworkState)networkState;

//DTMF回调
- (void)onDTMF:(NSString *)value;

//拉取离线推送的来电失败回调
- (void)didFailToGetPushIncomingCall:(NSString*)callid withReason:(UCSReason*)reason;




#pragma mark - 互联网视频通话的代理
//视频截图回调
- (void)onCameraCapture:(NSString*)cameraCapFilePath;

//对方视频模式回调
- (void)onRemoteCameraMode:(UCSCameraType)type;

//视频通话前被叫显示主叫预览图片时回调
- (void)onReceivedPreviewImg:(UIImage *)image  callid:(NSString *)callid error:(NSError *)error;

#pragma mark - 加解密的代理

// rtp解密回调
- (void)decryptCallBack:(char *)inMsg withOutMsg:(char *)outMsg withInLen:(int)inLen withOutLen:(int *)outLen;

// rtp加密回调
- (void)encryptCallBack:(char *)inMsg withOutMsg:(char *)outMsg withInLen:(int)inLen withOutLen:(int *)outLen;



@end
