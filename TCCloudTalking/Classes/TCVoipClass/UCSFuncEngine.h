
#import <UIKit/UIKit.h>
#import "UCSEvent.h"
#import "UCSService.h"
#import "UCSTcpClient.h"
#import "UCSVideoDefine.h"
#import "TCCPubEnum.h"
#import <AVFoundation/AVFoundation.h>


typedef void (^timerToDoSomeThingBlock)(void);

extern NSString * const UCSNotiClsoeView;
extern NSString * const UCSNotiHeadPhone;
extern NSString * const UCSNotiCallBalance;
extern NSString * const UCSNotiRefreshCallList;
extern NSString * const UCSNotiIncomingCall;
extern NSString * const UCSNotiEngineSucess;
extern NSString * const UCSNotiTCPTransParent;

@protocol UCSEngineUIDelegate <NSObject>
@optional
//来电信息
-(void)incomingCallID:(NSString*)callid caller:(NSString*)caller phone:(NSString*)phone name:(NSString*)name callStatus:(int)status callType:(NSInteger)calltype;
//来电信息(门口机使用)
//-(void)incomingCallInfo:(NSDictionary *)callInfo andCallID:(NSString*)callid caller:(NSString*)caller phone:(NSString*)phone name:(NSString*)name callStatus:(int)status callType:(NSInteger)calltype;//门口机使用该代理方法

//通话状态回调
-(void)responseVoipManagerStatus:(UCSCallStatus)event callID:(NSString*)callid data:(UCSReason *)data withVideoflag:(int)videoflag;



// 语音质量展示回调
- (void)showNetWorkState:(NSString *)networkStateStr;
// 对端视频模式回调
- (void)onRemoCameraMode:(UCSCameraType)type;

//收到视频来电预览图片时回调
- (void)onReceivedPreviewImg:(UIImage *)image  callid:(NSString *)callid error:(NSError *)error;
@end


//这个类是属于上面业务层与SDK之间的调度层，负责调用SDK接口和接收分发SDK的回调
@interface UCSFuncEngine : NSObject<UCSEventDelegate>


@property (nonatomic, retain)UCSService            *ucsCallService;

@property (nonatomic, assign)NSString  *userId;

@property (nonatomic, assign)id<UCSEngineUIDelegate>UIDelegate;//UI业务代理

@property (nonatomic, copy) timerToDoSomeThingBlock    timerConnectBlock;
+(UCSFuncEngine *)getInstance;




#pragma mark - -------------------呼叫控制函数-------------------

- (void)groupDial:(NSInteger)calltype numbers:(NSArray <NSString *>*) calledNumbers  andUserData:(NSString *)callerData;

/**
 * 拨打电话
 * @param callType 电话类型
 * @param calledNumber 电话号(加国际码)或者VoIP号码
 * @param callerData 传递参数
 */
- (void)dial:(NSInteger)callType andCallId:(NSString *)calledNumber andUserdata:(NSString *)callerData;

/**
 * 挂断电话
 * @param callId 电话id
 */
- (void) hangUp: (NSString*)callId;

/**
 * 接听电话
 * @param callId 电话id
 * V2.0
 */
- (void) answer: (NSString*)callId;

/**
 * 拒绝呼叫(挂断一样,当被呼叫的时候被呼叫方的挂断状态)
 * @param callId 电话id(reason 拒绝呼叫的原因, 可以传入ReasonDeclined:用户拒绝 ReasonBusy:用户忙)
 */
- (void)reject: (NSString*)callId;



#pragma mark - -------------------DTMF函数-------------------
/**
 * 发送DTMF
 * @param dtmf 键值
 */
- (BOOL)sendDTMF: (char)dtmf;

#pragma mark - -------------------本地功能函数-------------------

/**
 * 免提设置
 * @param enable false:关闭 true:打开
 */
- (void) setSpeakerphone:(BOOL)enable;


/**
 * 获取当前免提状态
 * @return false:关闭 true:打开
 */
- (BOOL) isSpeakerphoneOn;


/**
 * 静音设置
 * @param on false:正常 true:静音
 */
- (void)setMicMute:(BOOL)on;

/**
 * 获取当前静音状态
 * @return false:正常 true:静音
 */
- (BOOL)isMicMute;



/**
 * 获取SDK版本信息
 *
 */
- (NSString*) getUCSSDKVersion;



- (void)setIpv6:(BOOL)isIpv6;

#pragma mark - -------------------视频能力------------------------

/**
*  初始化视频显示控件（本地视频显示控件和对方视频显示控件）
*
*参数 frame 窗口大小
*
*@return UIView 视频显示控件:
*/
- (UIView *)allocCameraViewWithFrame:(CGRect)frame;

/**
 * 设置视频显示参数
 *
 *参数 localVideoView 设置本地视频显示控件
 *参数 remoteView     设置对方视频显示控件
 *
 *@return NO:  YES:
 */
-(BOOL)initCameraConfig:(UIView*)localVideoView withRemoteVideoView:(UIView*)remoteView withRender:(UCSRenderMode)renderMode;



/**
 *  自定义视频编码和解码参数
 */
- (void)setVideoAttr:(UCSVideoEncAttr*)ucsVideoEncAttr ;


/**
 * 用户自定义分级编码参数
 * @param ucsHierEncAttr 编码参数
 */
- (void)setHierEncAttr:(UCSHierEncAttr*)ucsHierEncAttr;


/**
 * 旋转显示图像角度
 * Desc: 当呼叫成功、或 接听成功时重新需要重新设置此方法
 * @param landscape       竖屏：0 横屏：1
 * @param localRotation  本地端显示图像角度  数值为0 90 180 270
 */
- (BOOL)setRotationVideo:(unsigned int)landscape andRecivied:(unsigned int)localRotation;

/**
 *
 * 获取摄像头个数
 */
- (int)getCameraNum;


/**
 * 摄像头切换 后置摄像头：0 前置摄像头：1
 *return YES 成功 NO 失败
 */
- (BOOL)switchCameraDevice:(UCSSwitchCameraType)CameraIndex;


/**
 *  切换视频模式：发送、接收、正常模式
 *
 *  @param type         CAMERA_RECEIVE : 只接收视频数据（只能接收到对方的视频）
                        CAMERA_SEND : 只发送视频数据（只让对方看到我的视频）
                        CAMERA_NORMAL : send receive preview
 *
 *  @return YES 成功 NO 失败
 */
- (BOOL)switchVideoMode:(UCSCameraType)type;



- (void)cameraCapture:(int)islocal withFileName:(NSString*)filename withSavePath:(NSString*)savePath;

/**
 在视频通话时开始录制视频(注意:此能力需在通话接通后调用)
 
 @param ucsVideoRecordAttr 设置视频录制参数包含: 视频的宽,高,码率,帧率,存储路径,录制方向,
 @return YES为操作成功 , NO为操作失败
 */
- (BOOL)videoRecordStart:(UCSVideoRecordAttr*)ucsVideoRecordAttr;


/**
 在视频通话时开始录制视频
 
 @return YES为操作成功 , NO为操作失败
 */
- (BOOL)videoRecordStop;


/**
 * 视频来电时是否支持预览
 * isPreView: YES 支持预览 NO 不支持预览。
 * return YES 成功 NO 失败
 */
- (BOOL)setCameraPreViewStatu:(BOOL)isPreView;


/**
 *  获取视频来电时是否支持预览
 *
 *  @return YES 支持预览 NO 不支持预览
 */
- (BOOL)isCameraPreviewStatu;


/**
 * 2g网络检测开关
 * @param enable  YES:发起呼叫时不检测2g网络  NO:发起呼叫时检测2g网络
 */

-(void)set2GNetWorkOn:(BOOL)enable;





///正式环境下日志开关
-(void)openSdkLog:(BOOL)isOpenSdkLog;


-(void)openMediaEngineLog:(BOOL)isOpenMediaEngineLog;


///续活接口
- (void) callIncomingPushRsp:(NSString*)callid  withVps:(NSInteger)vpsid withReason:(UCSReason*)reason;

//- (void) callIncomingPushRsp:(UCSReason*)reason;
//- (BOOL)setAGCPlus:(int)compressionGain targetDbfs:(int)targetDbfs;

//延迟三秒后连接
- (void)creatTimerConnect;
- (void)stopTimerConnect;
////开启间隔15秒检测定时器
- (void)creatTimerCheckCon;
- (void)stopTimerCheckCon;

@end
