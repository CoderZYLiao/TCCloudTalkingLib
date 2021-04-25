//
//  JCMessageChannel.h
//  JCSDKOC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCMessageChannelItem.h"
#import "JCMessageChannelCallback.h"

/**
 *  消息通道类，包括一对一消息和群组消息
 */
@interface JCMessageChannel : NSObject

/**
 *  @brief 缩率图保存路径，初始化会默认设置，同时用户可以自己设置
 */
@property (nonatomic, copy) NSString * __nonnull thumbDir;

/**
 *  @brief 创建 JCMessageChannel 对象
 *  @param client JCClient 对象
 *  @param callback JCMessageChannelCallback 回调接口，用于接收 JCMessageChannel 相关通知
 *  @return 返回 JCMessageChannel 对象，失败返回 nil
 */
+(JCMessageChannel* __nullable)create:(JCClient* __nonnull)client callback:(id<JCMessageChannelCallback> __nonnull)callback;

/**
 *  @brief 发送文本消息
 *  @param type 类型，参见 JCMessageChannelType
 *  @param keyId 对方唯一标识，当 type 为 JCMessageChannelType1To1 时为用户标识，当 type 为 JCMessageChannelTypeGroup 时为群组标识，serverUidMode 为 true 都为 serverUid
 *  @param messageType 文本消息类型，用户可以自定义，例如text，xml等
 *  @param text 文本内容
 *  @param extraParams 自定义参数集
 *  @param cookie 标志数据
 *  @param atAll 是否 @ 所有人, 针对群消息
 *  @param atServerUidList @队列, 针对群消息
 *  @return 返回 JCMessageChannelItem 对象，异常返回 nil
 *  @warning 文本内容不要超过10KB
 */
-(JCMessageChannelItem* __nullable)sendMessage:(JCMessageChannelType)type keyId:(NSString* __nonnull)keyId messageType:(NSString* __nonnull)messageType text:(NSString* __nonnull)text extraParams:(NSDictionary* __nullable)extraParams cookie:(id __nullable)cookie atAll:(bool)atAll atServerUidList:(NSArray<NSString*>* __nullable)atServerUidList;

/**
 *  @brief 发送文件消息
 *  @param type 类型，参见 JCMessageChannelType
 *  @param keyId 对方唯一标识，当 type 为 JCMessageChannelType1To1 时为用户标识，当 type 为 JCMessageChannelTypeGroup 时为群组标识，serverUidMode 为 true 都为 serverUid
 *  @param messageType 文件消息类型，用户可以自定义，例如image，video等
 *  @param fileUri 文件链接地址
 *  @param thumbUri 缩略图文件链接地址
 *  @param size 文件大小(字节)
 *  @param duration 文件时长，针对语音，视频等消息
 *  @param extraParams 自定义参数集
 *  @param cookie 标志数据
 *  @param atAll 是否 @ 所有人, 针对群消息
 *  @param atServerUidList @队列, 针对群消息
 *  @return 返回 JCMessageChannelItem 对象，异常返回 nil
 */
-(JCMessageChannelItem* __nullable)sendFile:(JCMessageChannelType)type keyId:(NSString* __nonnull)keyId messageType:(NSString* __nonnull)messageType fileUri:(NSString* __nonnull)fileUri thumbUri:(NSString* __nonnull)thumbUri size:(int)size duration:(int)duration extraParams:(NSDictionary* __nullable)extraParams cookie:(id __nullable)cookie atAll:(bool)atAll atServerUidList:(NSArray<NSString*>* __nullable)atServerUidList;

/**
 *  @brief 刷新会话数据，只针对 autoMode
 *  @param serverUid 用户uid或者gourp id，nil 则刷新全量数据
 *  @param lastQueryTime 上次查询返回的时间，单位毫秒
 *  @return 返回 操作id，失败返回 -1
 */
-(int)refreshConversation:(NSString* __nullable)serverUid lastQueryTime:(long)lastQueryTime;

/**
  *  @brief  拉取消息，只针对 autoMode
 * @param serverUid 用户uid或者gourp id
 * @param startMessageId 起始消息id
 * @param count 消息条数
 * @param pack  消息列表是否一次性返回
 * @return 返回 操作id，失败返回 -1
 */
-(int)fetchMessages:(nonnull NSString*)serverUid startMessageId:(long)startMessageId count:(int)count pack:(bool)pack;

/**
 * @brief 标志消息为已读
 * @param serverUid 用户uid或者gourp id
 * @param messageId 消息ID
 * @param isGroup 是否是群
 * @return 返回 -1失败，否则返回操作id
 */
-(int)markReadMessage:(nonnull NSString*)serverUid messageId:(long)messageId isGroup:(bool)isGroup;

/**
 * @brief 标志消息为已收
 * @param serverUid 用户uid或者gourp id
 * @param messageId 消息ID，如果-1表示最后一条消息
 * @return 返回 -1失败，否则返回操作id
 */
-(int)markRecvMessage:(nonnull NSString*)serverUid messageId:(long)messageId;
/**
 *  @brief 销毁接口
 */
+(void)destroy;

/**
 * @brief 撤回消息
 * @param serverUid 用户uid或者gourp id
 * @param messageId 消息ID
 * @param content 描述
 * @return 返回 -1失败，否则返回操作id
 */
-(int)withdrawalMessage:(nonnull NSString*)serverUid messageId:(long)messageId content:(NSString* __nonnull)content;

@end
