//
//  JCMessageChannelItem.h
//  JCSDKOC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCMessageChannelConstants.h"

/**
 *  IM消息对象类
 */
@interface JCMessageChannelItem : NSObject

/**
 *  @brief 消息唯一标识
 */
@property (nonatomic, readonly, copy) NSString* messageId;

/**
 *  @brief 消息内容类型
 */
@property (nonatomic, readonly, copy) NSString* messageType;

/**
 *  @brief 消息内容，包括文本和自定义消息体内容
 */
@property (nonatomic, readonly, copy) NSString* text;

/**
 *  @brief 文件链接，可以通过 JCStorage 将文件上传至 Juphoon Cloud 平台来获取该地址，也可以从其他文件消息获取改地址
 */
@property (nonatomic, readonly, copy) NSString* fileUri;

/**
 *  @brief 缩略图链接，可以通过 JCStorage 将文件上传至 Juphoon Cloud 平台来获取该地址，也可以从其他文件消息获取改地址
 */
@property (nonatomic, readonly, copy) NSString* thumbUri;

/**
 *  @brief 文件大小
 */
@property (nonatomic, readonly) int fileSize;

/**
 *  @brief 文件时长，语音，视频消息有效
 */
@property (nonatomic, readonly) int duration;

/**
 *  @brief 自定义参数集
 */
@property (nonatomic, readonly, strong) NSDictionary* extraParams;

/**
 *  @brief 消息对端用户标识
 */
@property (nonatomic, readonly, copy) NSString* userId;

/**
 *  @brief 消息对端昵称
 */
@property (nonatomic, readonly, copy) NSString* displayName;

/*
 *  @brief 群组标识，mType 为 JCIMTypeGroup 时有效
 */
@property (nonatomic, readonly, copy) NSString* groupId;

/**
 *  @brief 发送或者接收时间，单位毫秒
 */
@property (nonatomic, readonly) long time;

/**
 *  @brief 发送成功时间，单位毫秒，如果是收到消息则是服务器记录的该消息发送时间
 */
@property (nonatomic, readonly) long sentTime;

/**
 *  @brief 消息发送还是接收，参见 JCIMDirection
 */
@property (nonatomic, readonly) JCMessageChannelItemDirection direction;

/**
 *  @return 一对一消息还是群组消息，参见 JCMessageChannelType
 */
@property (nonatomic, readonly) JCMessageChannelType type;

/**
 *  @return 消息状态，参见 JCMessageChannelItemState
 */
@property (nonatomic, readonly) JCMessageChannelItemState state;

/**
 *  @return 消息错误，当消息状态为 JCMessageChannelStateSendFail 是有效，参见 JCMessageChannelReason
 */
@property (nonatomic, readonly) JCMessageChannelReason error;

/**
 *  @brief 消息的服务器时间，只有接收的消息有该值
 */
@property (nonatomic, readonly) long serverMessageId;

/**
 *  @brief cookie
 */
@property (nonatomic, strong) id cookie;

/**
 * @brief 会话 serverUid
 */
@property (nonatomic, strong) NSString* serverUid;

/**
* @brief 消息发送者 uid
*/
@property (nonatomic, strong) NSString* senderUid;

/// 是否@我的消息，针对群聊
@property (nonatomic) bool atMe;
/// 是否@所有人的消息，针对群聊
@property (nonatomic) bool atAll;
/// @的uid列表
@property (nonatomic, strong) NSArray<NSString*>* atServerUidList;
/// 是否是撤回消息
@property (nonatomic) bool isWithdrawal;
/// 撤回的消息id
@property (nonatomic) long withdrawalMessageId;;

@end
