//
//  JCGroup.h
//  JCSDKOC
//
//  Created by maikireton on 2017/8/15.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCGroupCallback.h"
#import "JCGroupConstants.h"
#import "JCGroupItem.h"

/**
 *  群操作类
 */
@interface JCGroup : NSObject

/**
 *  @brief 创建 JCGroup 对象
 *  @param client JCClient 对象
 *  @param callback JCGroupCallback 回调接口，用于接收 JCGroup 相关通知
 *  @return 返回 JCGroup 对象
 */
+(JCGroup* __nullable)create:(JCClient* __nonnull)client callback:(id<JCGroupCallback> __nonnull)callback;

/**
 *  @brief 获取当前用户所有加入的群列表，结果通过 JCGroupCallback 中相应回调返回
 *  @param updateTime 最新一次记录的群列表服务器更新时间
 *  @return 返回操作id
 */
-(int)fetchGroups:(long)updateTime;

/**
 *  @brief 刷新群组信息
 *  @param groupId 群标识
 *  @param updateTime 最新一次记录的该群服务器更新时间
 *  @return 返回操作id
 */
-(int)fetchGroupInfo:(NSString* __nonnull)groupId updateTime:(long)updateTime;

/**
 *  @brief 创建群
 *  @param members JCGroupMember 队列
 *  @param groupName 群名称
 *  @param type 群类型
 *  @param customProperties 自定义属性
 *  @return 返回操作id
 */
-(int)createGroup:(NSArray<JCGroupMember*>* __nonnull)members groupName:(NSString* __nonnull)groupName type:(JCGroupType)type customProperties:(NSDictionary<NSString*, NSObject*>* __nullable)customProperties;

/**
 *  @brief 更新群
 *  @param groupItem JCGroupItem 对象，其中 JCGroupItem 中 changeState 值不影响具体操作
 *  @return 返回操作id
 */
-(int)updateGroup:(JCGroupItem* __nonnull)groupItem;

/**
 *  @brief 解散群组，Owner才能解散群组
 *  @param groupId 群标识
 *  @return 返回操作id
 */
-(int)dissolve:(NSString* __nonnull)groupId;

/**
 *  @brief 离开群组
 *  @param groupId 群标识
 *  @return 返回操作id
 */
-(int)leave:(NSString* __nonnull)groupId;

/**
 *  @brief 操作成员
 *  @param groupId 群标识
 *  @param members JCGroupMemeber 对象列表，通过 changeState 值来表明增加，更新，删除成员操作
 *  @return 返回操作id
 */
-(int)dealMembers:(NSString* __nonnull)groupId members:(NSArray<JCGroupMember*>* __nonnull)members;

/**
 *  @brief 邀请加入群
 *  @param groupId 群标识
 *  @param member JCGroupMemeber 对象
 *  @param description 邀请信息
 */
//-(int)inviteMember:(NSString*)groupId member:(JCGroupMember*)member description:(NSString*)description;

/**
 *  @biref 拒绝邀请
 *  @param inviteId 邀请id
 *  @param description 拒绝y描述
 */
//-(int)rejectInvite:(int)inviteId description:(NSString*)description;

/**
 *  @brief 更新群备注信息，仅自己可见
 *  @param groupId 群标识
 *  @param nickName 备注名
 *  @param tag  额外信息
 *  @return 返回操作id
 */
-(int)updateGroupComment:(NSString* __nonnull)groupId nickName:(NSString* __nonnull)nickName tag:(NSDictionary<NSString*, NSObject*>* __nullable)tag;

/**
 *  @brief 设置免打扰
 *  @param groupId 群标识
 *  @param dnd 是否免打扰
 *  @return 返回操作id
 */
-(int)setDnd:(NSString* __nonnull)groupId dnd:(bool)dnd;

/**
 *  @brief 销毁接口
 */
+(void)destroy;

@end
