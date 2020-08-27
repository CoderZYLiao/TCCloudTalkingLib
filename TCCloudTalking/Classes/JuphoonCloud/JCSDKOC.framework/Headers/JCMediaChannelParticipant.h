//
//  JCMediaChannelParticipant.h
//  JCSDK-OC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCMediaChannelConstants.h"

/**
 * 上次更新到这次更新间的状态变化集合
 */
@interface JCMediaChannelParticipantChangeParam : NSObject

/**
 * 上传音频是否变化
 */
@property (nonatomic) Boolean audio;

/**
 * 上传视频是否变化
 */
@property (nonatomic) Boolean video;

/**
 * 图像请求大小是否变化
 */
@property (nonatomic) Boolean pictureSize;

/**
 *  成员类型是否变化
 */
@property (nonatomic) Boolean type;

/**
 * 成员网络状态是否变化
 */
@property (nonatomic) Boolean netStatus;

/**
 * 自定义状态变化
 */
@property (nonatomic) Boolean customState;

/**
 * 自定义角色变化
 */
@property (nonatomic) Boolean customRole;

@end

/**
 *  媒体频道成员
 */
@interface JCMediaChannelParticipant : NSObject

/**
 *  @brief 用户标识
 */
@property (nonatomic, readonly, copy) NSString* userId;

/**
 *  @brief 渲染标识，用于 JCMediaDevice 中 startVideo 渲染视频使用
 */
@property (nonatomic, readonly, copy) NSString* renderId;

/**
 *  @brief 昵称
 */
@property (nonatomic, readonly, copy) NSString* displayName;

/**
 *  @brief 音量状态
 *  @see JCMediaChannelVolumeStatus
 */
@property (nonatomic, readonly) JCMediaChannelVolumeStatus volumeStatus;

/**
 *  @brief 网络状态
 *  @see JCMediaChannelnetStatus
 */
@property (nonatomic, readonly) JCMediaChannelNetStatus netStatus;

/**
 *  @brief 是否开启了语音
 */
@property (nonatomic, readonly) bool audio;

/**
 *  @brief 是否开启了视频
 */
@property (nonatomic, readonly) bool video;

/**
 *  @brief 是否通过Sip接通
 */
@property (nonatomic, readonly) bool sipTalking;

/**
 * @brief 获得成员类型
 */
@property (nonatomic, readonly) int type;

/**
 *  @brief 图像尺寸
 *  @see JCMediaChannelPictureSize
 */
@property (nonatomic, readonly) JCMediaChannelPictureSize pictureSize;

/**
 * @brief 获得自定义角色值
 */
@property (nonatomic, readonly) JCMediaChannelCustomRole customRole;

/**
 * @brief 获得自定义状态值
 */
@property (nonatomic, readonly) JCMediaChannelCustomState customState;

/**
 * @brief 是否是创建者
 */
@property (nonatomic, readonly) bool isCreator;

/**
 *   @brief 是否是自身
 */
@property (nonatomic, readonly) bool isSelf;

/**
 *  @brief 字符串信息
 */
-(NSString*)toString;

/**
 * @brief 开始渲染视频对象
 * @param type 渲染模式
 * @param pictureSize 视频请求级别
 * @return 渲染对象
 */
-(JCMediaDeviceVideoCanvas*)startVideo:(JCMediaDeviceRender)type pictureSize:(JCMediaChannelPictureSize)pictureSize;

/**
 * 停止渲染视频对象
 */
-(void)stopVideo;

@end
