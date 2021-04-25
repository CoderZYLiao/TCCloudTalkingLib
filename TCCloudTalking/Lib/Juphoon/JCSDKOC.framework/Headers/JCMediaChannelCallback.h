//
//  JCMediaChannelCallback.h
//  JCSDK-OC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCMediaChannelParticipant.h"
#import "JCMediaChannelConstants.h"
#import "JCMediaChannelQueryInfo.h"
#import "JCMediaChannelParticipant.h"

@class JCMediaChannelPropChangeParam;

/**
 *   @brief JCMediaChannelCallback 回调
 */
@protocol JCMediaChannelCallback <NSObject>

/**
 *  @brief 自身状态变化回调
 *  @param state 当前状态值
 *  @param oldState 变化前状态
 *  @see JCMediaChannelState
 */
-(void)onMediaChannelStateChange:(JCMediaChannelState)state oldState:(JCMediaChannelState)oldState;

/**
 *  @brief 属性变化回调，目前主要关注屏幕共享状态的更新
 *  @param changeParam 变化标识集合
 */
-(void)onMediaChannelPropertyChange:(JCMediaChannelPropChangeParam *)changeParam;

/**
 *  @brief 加入频道结果回调
 *  @param result true 表示成功，false 表示失败
 *  @param reason 加入失败原因，当 result 为 false 时该值有效
 *  @param channelId 媒体频道标识符
 *  @see JCMediaChannelReason
 */
-(void)onJoin:(bool)result reason:(JCMediaChannelReason)reason channelId:(NSString*)channelId;

/**
 *  @brief 离开频道结果回调
 *  @param reason 离开原因
 *  @param channelId 频道标识符
 *  @see JCMediaChannelReason
 */
-(void)onLeave:(JCMediaChannelReason)reason channelId:(NSString*)channelId;

/**
 * @brief 解散频道结果回调
 * @param result    true 表示成功，false 表示失败
 * @param reason    解散失败原因，当 result 为 false 时该值有效
 */
-(void)onStop:(bool)result reason:(JCMediaChannelReason)reason;

/**
 *  @brief 查询媒体通道信息结果回调
 *  @param operationId 操作id，由 query 接口返回
 *  @param result true 表示查询成功，false 表示查询失败
 *  @param reason  查询失败原因 当 result 为 false 时该值有效
 *  @param queryInfo 查询到的信息，当失败时只需关注 channelId
 *  @see JCMediaChannelReason
 */
-(void)onQuery:(int)operationId result:(bool)result reason:(JCMediaChannelReason)reason queryInfo:(JCMediaChannelQueryInfo*)queryInfo;

/**
 *  @brief 新成员加入回调
 *  @param participant 成员对象
 */
-(void)onParticipantJoin:(JCMediaChannelParticipant*)participant;

/**
 *  @brief 成员离开回调
 *  @param participant 成员对象
 */
-(void)onParticipantLeft:(JCMediaChannelParticipant*)participant;

/**
 *  @brief 成员更新回调
 *  @param participant 成员对象
 *  @param participantChangeParam 变化标识集合
 */
-(void)onParticipantUpdate:(JCMediaChannelParticipant*)participant participantChangeParam:(JCMediaChannelParticipantChangeParam *)participantChangeParam;

/**
 * @brief 接收频道消息的回调
 *
 * @param type 消息类型
 * @param content 消息内容
 * @param fromUserId    消息发送成员的userId
 */
-(void)onMessageReceive:(NSString *)type content:(NSString *)content fromUserId:(NSString *)fromUserId;

/**
 * @brief 邀请Sip用户操作结果回调，成功后会触发 onParticipantJoin
 *
 * @param operationId 操作id
 * @param result 操作结果 true表示成功，false表示失败
 * @param reason 操作原因
 */
-(void)onInviteSipUserResult:(int)operationId result:(bool)result reason:(int)reason;

/**
 * @brief 成员声音变化
 *
 * @param participant 变化成员
 */
-(void)onParticipantVolumeChange:(JCMediaChannelParticipant*)participant;

@end
