
#import "UCSFuncEngine.h"
#import "UCSService.h"
#import "UCSTcpClient.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/message.h>
#import "UCSVOIPViewEngine.h"
#import "Header.h"

NSString * const UCSNotiClsoeView = @"UCSNotiClsoeView";
NSString * const UCSNotiHeadPhone = @"UCSNotiHeadPhone";
NSString * const UCSNotiCallBalance = @"UCSNotiCallBalance";
NSString * const UCSNotiRefreshCallList = @"UCSNotiRefreshCallList";
NSString * const UCSNotiIncomingCall = @"UCSNotiIncomingCall";
NSString * const UCSNotiEngineSucess = @"UCSNotiEngineSucess";
NSString * const UCSNotiTCPTransParent = @"UCSNotiTCPTransParent";

@class VideoView;
@interface UCSFuncEngine ()<AVAudioSessionDelegate>
{
    NSTimer * _timerConnect;
    NSTimer * _timerCheckConnect;
}

@end

@implementation UCSFuncEngine

@synthesize ucsCallService = _ucsCallService;
@synthesize userId = _userId;
@synthesize UIDelegate = _UIDelegate;


UCSFuncEngine* gUCSFuncEngine = nil;





- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSNumber *i = @0;
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable");
            i = @1;
            
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            NSLog(@"AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            break;
            
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UCSNotiHeadPhone object:i];
}




+(UCSFuncEngine *)getInstance
{
    @synchronized(self){
        if(gUCSFuncEngine == nil){
            gUCSFuncEngine = [[self alloc] init];
        }
    }
    return gUCSFuncEngine;
}


- (id)init
{
    if (self = [super init])
    {
        
        self.UIDelegate = [UCSVOIPViewEngine getInstance];
        
        
        UCSService* ucsService = [[UCSService alloc] init];
        [ucsService setDelegate:self];
        self.ucsCallService = ucsService;
        
        [self audioRouteChangeListener]; //监听耳机插入
        
        
        
        
    }
    
    return self;
}

- (void)audioRouteChangeListener{
    [[AVAudioSession sharedInstance] setActive:YES error:nil];//创建单例对象并且使其设置为活跃状态.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];//设置通知
    
}

- (void)dealloc
{
    self.UIDelegate = nil;
    self.ucsCallService = nil;
    self.userId = nil;
}


//-----------------------------------------------功能函数放置区域------------------------------------------------


#pragma mark - 呼叫控制函数

- (void)groupDial:(NSInteger)calltype numbers:(NSArray <NSString *>*) calledNumbers  andUserData:(NSString *)callerData{
    [self.ucsCallService groupDialWithType:calltype numbers:calledNumbers];
}

/**
 * 拨打电话
 * @param callType 电话类型
 * @param calledNumber 电话号(加国际码)或者VoIP号码
 * @param callerData 传递参数
 */
- (void)dial:(NSInteger)callType andCallId:(NSString *)calledNumber andUserdata:(NSString *)callerData
{
    [self.ucsCallService dial:callType andCalled:calledNumber andUserdata:callerData];
}



/**
 * 挂断电话
 * @param callId 电话id
 */
- (void) hangUp: (NSString*)callId;
{
    [[UCSVOIPViewEngine getInstance] WriteToSandBox:[NSString stringWithFormat:@"挂断：%@",self.ucsCallService]];
    
    [self.ucsCallService hangUp:callId];
}

/**
 * 接听电话
 * @param callId 电话id
 * V2.0
 */
- (void) answer: (NSString*)callId
{
    [self.ucsCallService answer:callId];
}


/**
 * 拒绝呼叫(挂断一样,当被呼叫的时候被呼叫方的挂断状态)
 * @param callId 电话id(reason 拒绝呼叫的原因, 可以传入ReasonDeclined:用户拒绝 ReasonBusy:用户忙)
 */
- (void)reject: (NSString*)callId
{
    [self.ucsCallService reject:callId];
}


#pragma mark - DTMF函数
/**
 * 发送DTMF
 * @param dtmf 键值
 */
- (BOOL)sendDTMF: (char)dtmf
{
    return [self.ucsCallService sendDTMF:dtmf];
}

#pragma mark - 本地功能函数

/**
 * 免提设置
 * @param enable false:关闭 true:打开
 */
- (void) setSpeakerphone:(BOOL)enable
{
    [self.ucsCallService setSpeakerphone:enable];
}


/**
 * 获取当前免提状态
 * @return false:关闭 true:打开
 */
- (BOOL) isSpeakerphoneOn
{
    return  [self.ucsCallService isSpeakerphoneOn];
}


/**
 * 静音设置
 * @param on false:正常 true:静音
 */
- (void)setMicMute:(BOOL)on
{
    [self.ucsCallService setMicMute:on];
}

/**
 * 获取当前静音状态
 * @return false:正常 true:静音
 */
- (BOOL)isMicMute
{
    return [self.ucsCallService isMicMute];
}




/**
 * 获取SDK版本信息
 *
 */
- (NSString*) getUCSSDKVersion
{
    return [self.ucsCallService getUCSSDKVersion];
}


- (void)setIpv6:(BOOL)isIpv6{
    
    [self.ucsCallService setIpv6:isIpv6];
    
}

#pragma mark - 视频能力
//-----------------------------------------视频能力分割线-------------------------------------------------------//

/**
 *  初始化视频显示控件（本地视频显示控件和对方视频显示控件）
 *
 *参数 frame 窗口大小
 *
 *@return UIView 视频显示控件:
 */
- (UIView *)allocCameraViewWithFrame:(CGRect)frame{
    
    return [self.ucsCallService allocCameraViewWithFrame:frame];
    
}

/**
 * 设置视频显示参数
 *
 *参数 localVideoView 设置本地视频显示控件
 *参数 remoteView     设置对方视频显示控件
 *参数 width          设置发给对方视频的宽度
 *参数 height         设置发给对方视频的高度
 *
 *@return NO:  YES:
 */

- (BOOL)initCameraConfig:(UIView*)localVideoView withRemoteVideoView:(UIView*)remoteView withRender:(UCSRenderMode)renderMode
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USE720P]) {
        [self.ucsCallService setVideoPreset:UCS_VIE_PROFILE_PRESET_1280x720];
    }else{
        [self.ucsCallService setVideoPreset:UCS_VIE_PROFILE_PRESET_640x480];
    }
    
    [self.ucsCallService setVideoIsUseHwEnc:[[NSUserDefaults standardUserDefaults] boolForKey:USEHardCode]];
    
    return [self.ucsCallService initCameraConfig:localVideoView withRemoteVideoView:remoteView withRender:renderMode];
    
}

/**
 *  自定义视频编码和解码参数
 *
 *  @param ucsVideoEncAttr 编码参数
 */
- (void)setVideoAttr:(UCSVideoEncAttr*)ucsVideoEncAttr{
    
    [self.ucsCallService setVideoAttr:ucsVideoEncAttr ];
    
}

/**
 * 用户自定义分级编码参数
 * @param ucsHierEncAttr 编码参数
 */
- (void)setHierEncAttr:(UCSHierEncAttr*)ucsHierEncAttr{
    
    [self.ucsCallService setHierEncAttr:ucsHierEncAttr];
    
}

/**
 * 旋转显示图像角度
 * Desc: 当呼叫成功、或 接听成功时重新需要重新设置此方法
 * @param landscape       竖屏：0 横屏：1
 * @param localRotation  本地端显示图像角度  数值为0 90 180 270
 */
- (BOOL)setRotationVideo:(unsigned int)landscape andRecivied:(unsigned int)localRotation
{
    return [self.ucsCallService setRotationVideo:landscape andRecivied:localRotation];
}

/**
 *
 * 获取摄像头个数
 */
- (int)getCameraNum
{
    return [self.ucsCallService getCameraNum];
}


/**
 * 摄像头切换 后置摄像头：0 前置摄像头：1
 *return YES 成功 NO 失败
 */
- (BOOL)switchCameraDevice:(UCSSwitchCameraType)CameraIndex
{
    return [self.ucsCallService switchCameraDevice:CameraIndex];
    
}


/**
 *  切换视频模式：发送、接收、正常模式
 *
 *  @param type         CAMERA_RECEIVE : 只接收视频数据（只能接收到对方的视频）
 CAMERA_SEND : 只发送视频数据（只让对方看到我的视频）
 CAMERA_NORMAL : send receive preview
 *
 *  @return YES 成功 NO 失败
 */
- (BOOL)switchVideoMode:(UCSCameraType)type{
    
    return [self.ucsCallService switchVideoMode:type];
    
}


/**
 * 视频截图
 * islocal: 0 是远端截图 1 是本地截图。
 * return YES 成功 NO 失败
 */
- (void)cameraCapture:(int)islocal withFileName:(NSString*)filename withSavePath:(NSString*)savePath;
{
    [self.ucsCallService cameraCapture:islocal withFileName:filename withSavePath:savePath];
    
}

/**
 在视频通话时开始录制视频(注意:此能力需在通话接通后调用)
 
 @param ucsVideoRecordAttr 设置视频录制参数包含: 视频的宽,高,码率,帧率,存储路径,录制方向,
 @return YES为操作成功 , NO为操作失败
 */
- (BOOL)videoRecordStart:(UCSVideoRecordAttr*)ucsVideoRecordAttr
{
    return  [self.ucsCallService videoRecordStart:ucsVideoRecordAttr];
}


/**
 在视频通话时开始录制视频
 
 @return YES为操作成功 , NO为操作失败
 */
- (BOOL)videoRecordStop
{
    return   [self.ucsCallService videoRecordStop];
}

/**
 * 视频来电时是否支持预览
 * isPreView: YES 支持预览 NO 不支持预览。
 * return YES 成功 NO 失败
 */
- (BOOL)setCameraPreViewStatu:(BOOL)isPreView
{
    return [self.ucsCallService setCameraPreViewStatu:isPreView];
    
}


/**
 *  获取视频来电时是否支持预览
 *
 *  @return YES 支持预览 NO 不支持预览
 */
- (BOOL)isCameraPreviewStatu{
    return [self.ucsCallService isCameraPreviewStatu];
    
}




/**
 * 2g网络检测开关
 * @param enable  YES:发起呼叫时不检测2g网络  NO:发起呼叫时检测2g网络
 */
-(void)set2GNetWorkOn:(BOOL)enable{
    
    
    [self.ucsCallService set2GNetWorkOn:enable];
    
}




//------------------------------------------------回调函数放置区域------------------------------------------------


#pragma mark VoIP通话的代理

//收到来电回调(门口机使用)
//- (void)onIncomingCall:(NSString*)callId withcalltype:(UCSCallTypeEnum) callType withcallinfo:(NSDictionary*)callinfo
//{
//
//        if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(incomingCallInfo:andCallID:caller:phone:name:callStatus:callType:)])
//        {
//            [self.UIDelegate incomingCallInfo:callinfo andCallID:callId caller:[callinfo objectForKey:@"callerNumber"] phone:[callinfo objectForKey:@"callerNumber"] name:[callinfo objectForKey:@"callerNumber"]  callStatus:0 callType:[[NSNumber numberWithInt:callType] intValue] ];
//        }
//
//}

//收到来电回调
- (void)onIncomingCall:(NSString*)callId withcalltype:(UCSCallTypeEnum) callType withcallinfo:(NSDictionary*)callinfo
{
    
    
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(incomingCallID:caller:phone:name:callStatus:callType:)])
    {
        
        [self.UIDelegate incomingCallID:callId caller:[callinfo objectForKey:@"callerNumber"] phone:[callinfo objectForKey:@"callerNumber"] name:[callinfo objectForKey:@"callerNumber"]  callStatus:0 callType:[[NSNumber numberWithInt:callType] intValue] ];
        
    }
    
}

#pragma mark - 呼叫回调
//呼叫处理回调--------------------->待定
//- (void)onCallProceeding:(NSString*)callId{}
//呼叫振铃回调
- (void) onAlerting:(NSString*)called
{
    
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(responseVoipManagerStatus:callID:data:withVideoflag:)])
    {
        [self.UIDelegate responseVoipManagerStatus:UCSCallStatus_Alerting callID:called data:nil withVideoflag:0];
    }
    
}
//接听回调
-(void) onAnswer:(NSString*)called
{
    
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(responseVoipManagerStatus:callID:data:withVideoflag:)])
    {
        [self.UIDelegate responseVoipManagerStatus:UCSCallStatus_Answered callID:called data:nil withVideoflag:0];
    }
}
//呼叫失败回调
- (void) onDialFailed:(NSString*)callId  withReason:(UCSReason *) reason
{
    
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(responseVoipManagerStatus:callID:data:withVideoflag:)])
    {
        [self.UIDelegate responseVoipManagerStatus:UCSCallStatus_Failed callID:callId data:reason withVideoflag:0];
    }
}
//释放通话回调
- (void) onHangUp:(NSString*)called withReason:(UCSReason *)reason
{
    
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(responseVoipManagerStatus:callID:data:withVideoflag:)])
    {
        [self.UIDelegate responseVoipManagerStatus:UCSCallStatus_Released callID:called data:reason withVideoflag:0];
    }
}

// 语音质量回调实现
- (void)onNetWorkState:(UCSNetworkState)networkState
{
    if (nil != _UIDelegate && [_UIDelegate respondsToSelector:@selector(showNetWorkState:)]) {
        
        [_UIDelegate performSelector:@selector(showNetWorkState:) withObject:[NSString stringWithFormat:@"%d",networkState]];
    }
}

// 语音质量原因回调
- (void)onNetWorkDetail:(NSString *)networkDetail{
    if (nil != _UIDelegate && [_UIDelegate respondsToSelector:@selector(showNetWorkDetail:)]) {
        
        [_UIDelegate performSelector:@selector(showNetWorkDetail:) withObject:networkDetail];
    }
}


//对端视频模式回调
- (void)onRemoteCameraMode:(UCSCameraType)type{
    
    if (nil != _UIDelegate && [_UIDelegate respondsToSelector:@selector(onRemoCameraMode:)]) {
        [self.UIDelegate onRemoCameraMode:type];
    }
    
    
}

//DTMF回调
- (void)onDTMF:(NSString*)value
{
    NSLog(@"收到dtmf:%@", value);
    
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(responseVoipManagerStatus:callID:data:withVideoflag:)])
    {
        UCSReason *uUCSReason = [[UCSReason alloc]init];
        uUCSReason.reason = 0;
        uUCSReason.msg = value;
        [self.UIDelegate responseVoipManagerStatus:UCSCallStatus_RecDTMFvalue callID:@"DTMF value" data:uUCSReason withVideoflag:0];
    }
    
    
}

//视频截图回调
- (void)onCameraCapture:(NSString*)cameraCapFilePath
{
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(responseVoipManagerStatus:callID:data:withVideoflag:)])
    {
        UCSReason *uUCSReason = [[UCSReason alloc]init];
        uUCSReason.reason = 0;
        uUCSReason.msg = cameraCapFilePath;
        [self.UIDelegate responseVoipManagerStatus:UCSCallStatus_RecDTMFvalue callID:@"DTMF value" data:uUCSReason withVideoflag:0];
    }
    
    
}



//视频电话预览图回调
- (void)onReceivedPreviewImg:(UIImage *)image callid:(NSString *)callid error:(NSError *)error{
    
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(onReceivedPreviewImg:callid:error:)]) {
        [self.UIDelegate onReceivedPreviewImg:image callid:callid error:error];
    }
    
}


//------------------------------------------------回调函数放置区域------------------------------------------------


///正式环境下日志开关
-(void)openSdkLog:(BOOL)isOpenSdkLog
{
    //    [self.ucsCallService openSdkLog:YES];//保存主机地址
    if ([self.ucsCallService respondsToSelector:@selector(openSdkLog:)]) {
        ((id(*)(id,SEL,int))objc_msgSend)(self.ucsCallService, @selector(openSdkLog:), YES);
    }
}

-(void)openMediaEngineLog:(BOOL)isOpenMediaEngineLog{
    
    if ([self.ucsCallService respondsToSelector:@selector(openMediaEngineLog:)]) {
        ((BOOL(*)(id,SEL,BOOL))objc_msgSend)(self.ucsCallService, @selector(openMediaEngineLog:), isOpenMediaEngineLog);
    }
    
}

- (void) callIncomingPushRsp:(NSString*)callid  withVps:(NSInteger)vpsid withReason:(UCSReason*)reason
{
    [[NSString stringWithFormat:@"callIncomingPushRsp:%@ withVps:%ld withReason:%@",callid, (long)vpsid, reason.description ] saveTolog];
    
    
    [self.ucsCallService  callIncomingPushRsp:callid withVps:vpsid withReason:reason];
    
}

//- (void) callIncomingPushRsp:(UCSReason*)reason
//{
//    [[NSString stringWithFormat:@"callIncomingPushRsp:%@ withVps:%ld withReason:%@",callid, (long)vpsid, reason.description ] saveTolog];
//    [self.ucsCallService  callIncomingPushRsp:reason];
//}
- (void)didFailToGetPushIncomingCall:(NSString*)callid withReason:(UCSReason*)reason{
    //   [[NSString stringWithFormat:@"didFailToGetPushIncomingCall:%@",callid] saveTolog];
    //   [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"离线通话续活失败,\n callid:%@,\n reason:%@", callid, reason.msg] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}


/**
 @author WLS, 16-01-11 18:01:09
 
 初始化成功
 
 @param result 结果
 */
- (void)onInitEngineSuccessful:(NSInteger)result{
    
    
    
    //由于ChatListViewController中有网络监控,可以根据网络有无来判定是否登录,故此行代码注释
    //    [[NSNotificationCenter defaultCenter] postNotificationName:UCSNotiEngineSucess object:nil];
    //    [_ucsCallService setRTPEncEnable:YES];
}




//- (BOOL)setAGCPlus:(int)compressionGain targetDbfs:(int)targetDbfs{
//    
//    
//    return [_ucsCallService setAGCPlus:compressionGain targetDbfs:targetDbfs];
//}

//-(void)decryptCallBack:(char*)inData withOutMsg:(char*)outData withInLen:(int)bytesIn withOutLen:(int*)bytesOut
//{
//    
//    
//    memcpy(outData, inData, bytesIn);
//    *bytesOut = bytesIn;
//    
//        
//    
//    
//}
//
//-(void)encryptCallBack:(char*) inData withOutMsg:(char*)outData withInLen:(int )bytesIn withOutLen:(int*)bytesOut
//{
//    
//        
//    memcpy(outData, inData, bytesIn);
//    *bytesOut = bytesIn;
//    
//    
//}
//--------------------------延迟三秒后连接------------------------------------//
//延迟三秒后连接
- (void)creatTimerConnect
{
//    [TCCUserDefaulfManager SetLocalDataBoolen:YES key:@"isHaveLoging"];
    if (_timerConnect) {
        [_timerConnect invalidate];
        _timerConnect = nil;
    }
    _timerConnect = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(afterOneSecond_timerConnect) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timerConnect forMode:NSRunLoopCommonModes];
}

- (void)stopTimerConnect
{
    
//    [TCCUserDefaulfManager SetLocalDataBoolen:NO key:@"isHaveLoging"];
    if (_timerConnect) {
        [_timerConnect invalidate];
        _timerConnect = nil;
        
    }
    
}

- (void)afterOneSecond_timerConnect{
    
    if (self.timerConnectBlock) {
        self.timerConnectBlock();
    }
    
    [self stopTimerConnect];
}


//-------------------------开启间隔15秒检测定时器-------------------------------------//
//开启间隔15秒检测定时器
- (void)creatTimerCheckCon
{
    NSLog(@"开启间隔15秒检测定时器");
    if (_timerCheckConnect) {
        [_timerCheckConnect invalidate];
        _timerCheckConnect = nil;
    }
    _timerCheckConnect = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(connectAfterInUnLine) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timerCheckConnect forMode:NSRunLoopCommonModes];
}

- (void)stopTimerCheckCon
{
    NSLog(@"关闭间隔15秒检测定时器");
    if (_timerCheckConnect) {
        [_timerCheckConnect invalidate];
        _timerCheckConnect = nil;
    }
}
//若连接断开15秒后发起连接
- (void)connectAfterInUnLine
{
    //每间隔15秒检测网络连接状态
    NSLog(@"间隔15秒开始检测是否有连接");
    if([[UCSTcpClient sharedTcpClientManager] login_isConnected]== NO){
        NSLog(@"间隔15秒检测到无连接");
        
//        if(![TCCUserDefaulfManager GetLocalDataBoolen:@"isHaveLoging"]){
//            
//            NSLog(@"间隔15秒检测发现无连接,发起登陆");
//            if (self.timerConnectBlock) {
//                self.timerConnectBlock();
//            }
//
//
//
//        }
        
    }else{
        NSLog(@"间隔15秒检测到有连接,不发起登陆动作");
        
    }
    
    
}

@end
