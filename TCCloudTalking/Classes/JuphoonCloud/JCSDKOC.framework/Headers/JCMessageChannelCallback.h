//
//  JCMessageChannelCallback.h
//  JCSDKOC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCMessageChannelItem.h"
#import "JCMessageChannelConversation.h"

/**
 *  JCIM 回调代理
 */
@protocol JCMessageChannelCallback <NSObject>

/**
 *  @brief 消息发送状态更新
 *  @param message IM消息对象，通过该对象可以获得消息的属性及状态
 *  @see JCMessageChannelItem
 */
-(void)onMessageSendUpdate:(JCMessageChannelItem*)message;

/**
 *  @brief 收到消息通知，非自动接收模式下会上报自己的消息，上层需要自己处理
 *  @param message IM消息对象，通过该对象可以获得消息的属性及状态
 *  @see JCMessageChannelItem
 */
-(void)onMessageRecv:(JCMessageChannelItem*)message;

/**
 *  @brief 刷新会话回调
 *  @param operationId 操作标识
 *  @param result true 表示获取成功，false 表示获取失败
 *  @param conversations 当 result 为 true 时返回会话列表
 *  @param reason 当 result 为 false 时该值有效
 *  @param updateTime 服务器最后更新时间，当 result 为 false 时该值有效
 *  @param refreshServerUid 调用 refreshConversation 传入的 serverUid
 */
-(void)onRefreshConversation:(int)operationId result:(bool)result conversations:(NSArray<JCMessageChannelConversation*>*)conversations reason:(JCMessageChannelReason)reason updateTime:(long)updateTime refreshServerUid:(NSString*)refreshServerUid;

/**
*  @brief 拉取消息结果
*  @param operationId 操作标识
*  @param result true 表示获取成功，false 表示获取失败
*  @param reason 当 result 为 false 时该值有效
*/
-(void)onFetchMessageResult:(int)operationId result:(bool)result reason:(JCMessageChannelReason)reason;

/**
*  @brief 设置已读操作结果
*  @param operationId 操作标识
*  @param result true 表示获取成功，false 表示获取失败
*  @param reason 当 result 为 false 时该值有效
*/
-(void)onMarkReadResult:(int)operationId result:(bool)result reason:(JCMessageChannelReason)reason;

/**
*  @brief 设置已接收操作结果
*  @param operationId 操作标识
*  @param result true 表示获取成功，false 表示获取失败
*  @param reason 当 result 为 false 时该值有效
*/
-(void)onMarkRecvResult:(int)operationId result:(bool)result reason:(JCMessageChannelReason)reason;

/**
*  @brief 收到对端设置已接收通知
*  @param serverUid 用户uid
*  @param serverMessageId 服务器消息 id
*/
-(void)onReceiveMarkRecv:(NSString*)serverUid serverMessageId:(long)serverMessageId;

/**
 *  @brief 收到对端设置已接收通知
 *  @param serverUid 用户uid
 *  @param serverMessageId 服务器消息 id
 */
-(void)onReceiveMarkRead:(NSString*)serverUid serverMessageId:(long)serverMessageId;

/**
 * @brief 收到消息列表通知, 由 fetchMessages 中 pack 传 true 后触发
 *
 * @param messageList IM消息对象列表，通过该对象可以获得消息的属性及状态
 * @see JCMessageChannelItem
 */
-(void)onMessageListRecv:(NSArray<JCMessageChannelItem*>*)messageList;

/**
 * @brief 撤回结果回掉
 *
 * @param operationId 操作ID
 * @param result 标志消息已收是否成功
 * @param message  消息对象，只有 serverUid，serverMessageId，text 字段有效
 * @param reason 失败原因描述
 */
-(void)onWithdrawalMessageResult:(int)operationId result:(bool)result message:(JCMessageChannelItem*)message reason:(JCMessageChannelReason)reason;

@end
