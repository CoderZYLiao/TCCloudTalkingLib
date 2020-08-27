//
//  JCCallItem.h
//  JCSDK-OC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCCallConstants.h"

/**
 * 上次更新到这次更新间的状态变化集合
 */
@interface JCCallChangeParam : NSObject

/**
 *  @brief 状态是否变化
 */
@property (nonatomic) bool state;

/**
 *  @brief 挂起是否变化
 */
@property (nonatomic) bool hold;

/**
 *  @brief 被挂起是否变化
 */
@property (nonatomic) bool held;

/**
 *  @brief 静音是否变化
 */
@property (nonatomic) bool mute;

/**
 *  @brief 音频录制是否变化
 */
@property (nonatomic) bool audioRecord;

/**
 *  @brief 本地视频录制是否变化
 */
@property (nonatomic) bool localVideoRecord;

/**
 *  @brief 远端视频录制是否变化
 */
@property (nonatomic) bool remoteVideoRecord;

/**
 *  @brief 音频输出是否变化
 */
@property (nonatomic) bool audioOutputType;

/**
 *  @brief 活跃是否变化
 */
@property (nonatomic) bool active;

/**
 *  @brief 本端上传视频是否变化
 */
@property (nonatomic) bool uploadVideoStreamSelf;

/**
 *  @brief 对端上传视频是否变化
 */
@property (nonatomic) bool uploadVideoStreamOther;

/**
 *  @brief 网络状态是否变化
 */
@property (nonatomic) bool netStatus;

/**
 *  @brief 对端声音中断是否变化
 */
@property (nonatomic) bool otherAudioInterrupt;

@end

/**
 * 通话对象，此类主要记录通话的一些状态，UI可以根据其中的状态进行更新
 */
@interface JCCallItem : NSObject

/**
 *  @brief 用户标识
 */
@property (nonatomic, readonly, copy) NSString* __nonnull userId;

/**
 *  @brief 用户昵称
 */
@property (nonatomic , copy) NSString* __nullable displayName;

/**
 *  @brief 渲染标识，用于 JCMediaDevice 渲染视频使用
 */
@property (nonatomic, readonly, copy) NSString* __nonnull renderId;

/**
 *  @brief 通话方向（呼入或呼出），参见 JCCallDirection
 */
@property (nonatomic, readonly) JCCallDirection direction;

/**
 *  @brief 是否为视频通话
 */
@property (nonatomic, readonly) bool video;

/**
 *  @brief 通话建立时间戳，单位秒
 */
@property (nonatomic, readonly) long beginTime;

/**
 *  @brief 通话开始时间，单位秒
 */
@property (nonatomic, readonly) long talkingBeginTime;

/**
 *  @brief 通话状态，参见 JCCallState
 */
@property (nonatomic, readonly) JCCallState state;

/**
 *  @brief 是否是挂起状态
 */
@property (nonatomic, readonly) bool hold;

/**
 *  @brief 是否是被挂起状态
 */
@property (nonatomic, readonly) bool held;

/**
 *  @brief 是否是静音状态
 */
@property (nonatomic, readonly) bool mute;

/**
 *  @brief 是否是录音状态
 */
@property (nonatomic, readonly) bool audioRecord;

/**
 *  @brief 录音文件路径
 */
@property (copy, nonatomic, readonly) NSString* __nullable audioRecordFilePath;

/**
 *  @brief 是否本端视频录制状态
 */
@property (nonatomic, readonly) bool localVideoRecord;

/**
 *  @brief 本地录像文件路径
 */
@property (copy, nonatomic, readonly) NSString* __nullable localVideoRecordFilePath;

/**
 *  @brief 是否远端视频录制状态
 */
@property (nonatomic, readonly) bool remoteVideoRecord;

/**
 *  @brief 远端录像文件路径
 */
@property (copy, nonatomic, readonly) NSString* __nullable remoteVideoRecordFilePath;

/**
 *  @brief 音频输出类型，根据类型判断是听筒，耳机，麦克风等
 */
@property (nonatomic, readonly, copy) NSString* __nullable audioOutputType;

/**
 *  @brief 是否激活状态，会议通话时忽略此参数
 */
@property (nonatomic, readonly) bool active;

/**
 *  @brief 本端是否在上传视频流，针对视频通话有效
 */
@property (nonatomic, readonly) bool uploadVideoStreamSelf;

/**
 *  @brief 对端是否在上传视频流，针对视频通话有效
 */
@property (nonatomic, readonly) bool uploadVideoStreamOther;

/**
 *  @brief 通话结束原因
 */
@property (nonatomic, readonly) JCCallReason reason;

/// 音频发送网络状态
@property (nonatomic, readonly) JCCallNetWork audioNetSendStatus;

/// 音频接收网络状态
@property (nonatomic, readonly) JCCallNetWork audioNetReceiveStatus;

/// 视频发送网络状态
@property (nonatomic, readonly) JCCallNetWork videoNetSendStatus;

/// 视频接收网络状态
@property (nonatomic, readonly) JCCallNetWork videoNetReceiveStatus;

/**
 *  @brief 透传参数
 */
@property (nonatomic, readonly, copy) NSString* __nullable extraParam;

/**
 *  @brief 获取服务端唯一通话CallId，可以用来通话去重，如果为空字符串则不能通过此字段来去重，说明此通话还未到服务器
 */
@property (nonatomic, readonly, copy) NSString* __nullable serverCallId;

/**
 *  @brief 对端声音中断
 */
@property (nonatomic, readonly) bool otherAudioInterrupt;

/**
 *  @brief 小系统通话中，标识通话唯一性
*/
@property (nonatomic, readonly) NSString *__nullable ticket;

/**
 *  @brief 字符串信息
 */
-(NSString* __nonnull)toString;

/**
 * @brief 启动自身视频渲染
 * @param type 渲染模式
 * @return 渲染对象
 */
-(JCMediaDeviceVideoCanvas* __nullable)startSelfVideo:(JCMediaDeviceRender)type;

 /**
  * @brief 停止自身视频渲染
  */
-(void)stopSelfVideo;

/**
 * @brief 启动对端视频渲染
 * @param type 渲染模式
 * @return 渲染对象
 */
-(JCMediaDeviceVideoCanvas* __nullable)startOtherVideo:(JCMediaDeviceRender)type;

/**
 * 停止对端视频渲染
 */
-(void)stopOtherVideo;

@end
