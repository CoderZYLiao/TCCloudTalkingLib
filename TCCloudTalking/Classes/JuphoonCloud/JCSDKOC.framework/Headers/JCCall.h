//
//  JCCall.h
//  JCSDK-OC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCCallCallback.h"
#import "JCCallItem.h"


@interface JCCallParam : NSObject
/// 透传参数，设置后被叫方可获取该参数
@property (nonatomic) NSString * __nullable extraParam;
/// 与小系统通话使用，服务端需要的凭证，用于标识通话唯一性，此参数只有在iot模式生效
@property (nonatomic) NSString * __nullable ticket;

+ (instancetype __nullable )callParamWithExtraParam:(NSString *__nullable)extraParam ticket:(NSString *__nullable)ticket;
@end

/**
 * 一对一配置
 */
@interface JCCallMediaConfig : NSObject

/// 音频编解码,协商优先级按顺序排列, 每个编解码用";"间隔, 注意大小写
@property (nonatomic, strong) NSString* __nonnull audioEnableCodecs;
/// 回声消除模式
@property (nonatomic) JCCallAecMode audioAecMode;
/// 是否开启音频
@property (nonatomic) bool audioArsEnable;
/// 音频最小码率，kb
@property (nonatomic) int audioArsBitrateMin;
/// 音频最大码率，kb
@property (nonatomic) int audioArsBitrateMax;
/// 语音red抗丢包, 打开会增加payload码率, 关闭增强抗丢包能力节省码率从而降低功耗, 网络不稳定，一般选择打开
@property (nonatomic) bool audioRed;
/// 一般接收端声音质量好可关闭噪声抑制，减少声音dsp处理，降低功耗
@property (nonatomic) bool audioRxAnr;
/// rtx重传, 同FEC、NACK一起用，降低功耗, 网络不稳定，一般选择打开
@property (nonatomic) bool audioRtx;
/// 接收端声音自动增益控制, 接收端声音过大过小时，可尝试打开
@property (nonatomic) bool audioRxAgc;
/// 回声消除
@property (nonatomic) bool audioQosAec;
/// 发送端噪声抑制, 接收端声音噪声大，提高抑制等级；接收端声音小，可在不影响声音质量情况下降低抑制等级或者关闭抑制
@property (nonatomic) bool audioQosAnr;
/// 发送端声音自动增益控制
@property (nonatomic) bool audioQosAgc;
/// 静音检测
@property (nonatomic) bool audioQosVad;
/// 音频打包时长
@property (nonatomic) int audioPacketTime;

/// 视频编解码，协商优先级按顺序排列
@property (nonatomic, strong) NSString* __nonnull videoEnableCodecs;
/// 视频接收宽
@property (nonatomic) int videoResolutionRecvWidth;
/// 视频接收高
@property (nonatomic) int videoResolutionRecvHeight;
/// 视频发送宽
@property (nonatomic) int videoResolutionSendWidth;
/// 视频发送高
@property (nonatomic) int videoResolutionSendHeight;
/// 视频初始码率 kb
@property (nonatomic) int videoBitrate;
/// 发送帧率
@property (nonatomic) int videoSendFramerate;
/// 是否开启视频 ars
@property (nonatomic) bool videoArsEnable;
/// 视频最小码率，kb
@property (nonatomic) int videoArsBitrateMin;
/// 视频最大码率，kb
@property (nonatomic) int videoArsBitrateMax;
/// 视频最小帧率，kb
@property (nonatomic) int videoArsFramerateMin;
/// 视频最大帧率，kb
@property (nonatomic) int videoArsFramerateMax;
///支持rfc 2198 语音fec-red，增强抗丢包能力，会增加一倍的payload码率，不会增加包头。
///比如Opus 55kbps增加一倍码率后，最终码率达到90kbps=55+35；Opus 10kbps增加一倍码率后，最终码率达到16kbps=10+6。
@property (nonatomic) bool videoRedFec;
/**
 * @brief 影响本端视频请求分辨率，默认设置为true，
 *
 * 假设条件
 *    1. 本端默认请求是640*360的分辨率，通过 MtcCallDb.Mtc_CallDbSetAnVideoRecvResolution 设置
 *    2. 本端屏幕分辨率为360*360
 *
 *    true：请求分辨率则会被调整为360*360
 *    false: 请求还是以640*360进行请求
 */
@property (nonatomic) bool videoRecvFullScreen;
// 视频数据以SmallNalu方式打包, 一个包打包的数据多，减少包头的码率，从而降低功耗
@property (nonatomic) bool videoSmallNalu;
// 分辨率控制, 开启则分辨率随网络波动而变化, 关闭则固定分辨率
@property (nonatomic) bool videoResolutionControl;

/**
 * @brief 字符串信息
 * @return 返回 JCCall 实例
 */
-(NSString* __nonnull)toString;

/// 根据模式生成配置参数
/// @param mode 模式
+(JCCallMediaConfig* __nonnull)generateByMode:(JCCallMediaConfigMode)mode;

@end

/**
 *  一对一通话类
 *  @warning 扬声器通过 JCMediaDevice 类中 enableSpeaker 进行开关
 */
@interface JCCall : NSObject

/**
 *  @brief 通话对象列表
 */
@property (nonatomic, readonly, strong) NSArray* __nullable callItems;

/**
 *  @brief 最大通话数，当通话超过最大数呼出会失败，收到来电会自动拒绝
 */
@property (nonatomic) int maxCallNum;

/**
 *  @brief 当 JCCallItem 网络状态为 disconnected 时是否挂断，默认为 false
 */
@property (nonatomic) bool termWhenNetDisconnected;

/// 媒体参数
@property (nonatomic, strong) JCCallMediaConfig* __nonnull mediaConfig;

/**
 *  @brief                  创建 JCCall 实例
 *  @param client           JCClient 实例
 *  @param mediaDevice      JCMediaDevice 实例
 *  @param callback         JCCallCallback 回调接口，用于接收 JCCall 相关回调事件
 *  @return                 返回 JCCall 实例
 */
+(JCCall* __nullable)create:(JCClient* __nonnull)client mediaDevice:(JCMediaDevice* __nonnull)mediaDevice callback:(id<JCCallCallback> __nonnull)callback;
 
/**
 *  @brief 销毁接口
 */
+(void)destroy;

/**
 *  @brief                  一对一呼叫
 *  @param userId           用户标识
 *  @param video            是否为视频呼叫
 *  @param callParam       设置透传参数和ticket等参数，ticket 只有在iot模式生效
 *  @return                 返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)call:(NSString* __nonnull)userId video:(bool)video callParam:(JCCallParam * __nullable)callParam;

/**
 *  @brief                  挂断
 *  @param item             JCCallItem 对象
 *  @param reason           挂断原因
 *  @param description      挂断描述
 *  @return                 返回 true 表示正常执行调用流程，false 表示调用异常
 *  @see JCCallReason
 */
-(bool)term:(JCCallItem* __nonnull)item reason:(JCCallReason)reason description:(NSString* __nullable)description;

/**
 *  @brief                  接听
 *  @param item             JCCallItem 对象
 *  @param video            针对视频呼入可以选择以视频接听还是音频接听
 *  @return                 返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)answer:(JCCallItem* __nonnull)item video:(bool)video;

/**
 *  @brief 静音，通过 JCCallItem 对象中的静音状态来决定开启关闭静音
 *  @param item JCCallItem 对象
 *  @return 返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)mute:(JCCallItem* __nonnull)item;

/**
 *  @brief                  呼叫保持，通过 JCCallItem 对象中的呼叫保持状态来决定开启关闭呼叫保持
 *  @param item             JCCallItem 对象
 *  @return                 返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)hold:(JCCallItem* __nonnull)item;

/**
 * 语音通话录音，通过 JCCallItem 对象中的audioRecord状态来决定开启关闭录音
 *
 * @param item              JCCallItem 对象
 * @param enable            开启关闭录音
 * @param filePath          录音文件路径
 * @return                  返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)audioRecord:(JCCallItem* __nonnull)item enable:(bool)enable filePath:(NSString* __nullable)filePath;

/**
 * 视频通话录制，通过 JCCallItem 对象中的 localVideoRecord 状态来决定开启关闭录制
 *
 * @param item              JCCallItem 对象
 * @param enable            开启关闭录制
 * @param remote            是否为远端视频源
 * @param width             录制视频宽像素
 * @param height            录制视频高像素
 * @param filePath          录制视频文件存储路径
 * @param bothAudio         是否录制两端音频，false 表示只录制视频端音频
 * @return                  返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)videoRecord:(JCCallItem* __nonnull)item enable:(bool)enable remote:(bool)remote width:(int)width height:(int)height filePath:(NSString* __nullable)filePath bothAudio:(bool)bothAudio;

/**
 *  @brief 切换活跃通话
 *  @param item 需要变为活跃状态的 JCCallItem 对象
 *  @return 返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)becomeActive:(JCCallItem* __nonnull)item;

/**
 *  @brief 开启关闭视频流发送，用于视频通话中
 *  @param item JCCallItem 对象
 *  @return 返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)enableUploadVideoStream:(JCCallItem* __nonnull)item;

/**
 *  @brief 通过通话建立的通道发送数据
 *  @param item 需要发送数据的 JCCallItem 对象
 *  @param type 文本消息类型，用户可以自定义，例如text、xml等
 *  @param content 消息内容
 *  @return 返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)sendMessage:(JCCallItem * __nonnull)item type:(NSString * __nonnull)type content:(NSString * __nonnull)content;

/**
 * @brief 获得当前通话统计信息，以Json字符串形式返回，其中包含 "Audio" 和 "Video" 两个节点
 *
 * @return 当前通话统计信息
 */
-(NSString * __nullable)getStatistics;

/**
 * @brief 获得当前活跃通话
 *
 * @return 当前活跃通话，没有则返回nil
 */
-(JCCallItem* __nullable)getActiveCallItem;


/**
 * 发送DTMF信息
 *
 * @param item  需要发送数据的 JCCallItem 对象
 * @param value DTMF值
 */
-(bool)sendDtmf:(JCCallItem *_Nonnull)item value:(JCCallDtmf)value;



@end
