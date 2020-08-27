//
//  JCGroupCallback.h
//  JCSDKOC
//
//  Created by maikireton on 2017/8/15.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCGroupItem.h"
#import "JCGroupMember.h"
#import "JCGroupConstants.h"

/**
 *  JCGroup 回调代理
 */
@protocol JCGroupCallback <NSObject>

/**
 *  @brief 拉取群列表结果回调
 *  @param operationId 操作标识，由 fetchGroups 接口返回
 *  @param result true 表示获取成功，false 表示获取失败
 *  @param reason 当 result 为 false 时该值有效
 *  @param groups 群列表
 *  @param updateTime 服务器更新时间
 *  @param baseTime 服务器上个版本更新时间
 *  @param fullUpdate 是否全更新
 *  @see JCGroupReason
 */
-(void)onFetchGroups:(int)operationId result:(bool)result reason:(JCGroupReason)reason groups:(NSArray<JCGroupItem*>*)groups updateTime:(long)updateTime baseTime:(long)baseTime fullUpdate:(bool)fullUpdate;

/**
 *  @brief 拉取群详情结果回调
 *  @param operationId 操作标识，由 fetchGroupInfo 接口返回
 *  @param result true 表示获取成功，false 表示获取失败
 *  @param reason 当 result 为 false 时该值有效
 *  @param groupItem JCGroupItem 对象
 *  @param members 成员列表
 *  @param updateTime 服务器更新时间
 *  @param baseTime 服务器上个版本更新时间
 *  @param fullUpdate 是否全更新
 *  @see JCGroupReason
 */
-(void)onFetchGroupInfo:(int)operationId result:(bool)result reason:(JCGroupReason)reason groupItem:(JCGroupItem*)groupItem members:(NSArray<JCGroupMember*>*)members updateTime:(long)updateTime baseTime:(long)baseTime fullUpdate:(bool)fullUpdate;

/**
 *  @brief 群列表更新，调用 JCGroup fetchGroups 获取更新
 *  @param groups 变化的 group
 *  @param updateTime 服务器更新时间
 *  @param baseTime 服务器上个版本更新时间
 */
-(void)onGroupListChange:(NSArray<JCGroupItem*>*)groups updateTime:(long)updateTime baseTime:(long)baseTime;

/**
 *  @brief 群信息更新，调用 JCGroup fetchGroupInfo 获取更新
 *  @param groupId 群标识
 *  @param members 成员列表
 *  @param updateTime 服务器更新时间
 *  @param baseTime 服务器上个版本更新时间
 */
-(void)onGroupInfoChange:(NSString*)groupId members:(NSArray<JCGroupMember*>*)members updateTime:(long)updateTime baseTime:(long)baseTime;

/**
 *  @brief 创建群回调
 *  @param operationId 操作标识，由 createGroup 接口返回
 *  @param result true 表示登陆成功，false 表示登陆失败
 *  @param reason 当 result 为 false 时该值有效
 *  @param groupItem JCGroupItem 对象
 *  @param updateTime 服务器更新时间
 *  @param baseTime 服务器上个版本更新时间
 *  @see JCGroupReason
 */
-(void)onCreateGroup:(int)operationId result:(bool)result reason:(JCGroupReason)reason groupItem:(JCGroupItem*)groupItem updateTime:(long)updateTime baseTime:(long)baseTime;;

/**
 *  @brief 更新群信息调用回调
 *  @param operationId 操作标识，由 updateGroup 接口返回
 *  @param result true 表示登陆成功，false 表示登陆失败
 *  @param reason 当 result 为 false 时该值有效
 *  @param groupId 群标识
 *  @see JCGroupReason
 */
-(void)onUpdateGroup:(int)operationId result:(bool)result reason:(JCGroupReason)reason groupId:(NSString*)groupId;

/**
 *  @brief 解散群组回调
 *  @param operationId 操作表示，由 dissolve 接口返回
 *  @param result true 表示成功，false 表示失败
 *  @param reason 当 result 为 false 时该值有效，参见 JCGroupReason
 *  @param groupId 群标识
 */
-(void)onDissolve:(int)operationId result:(bool)result reason:(JCGroupReason)reason groupId:(NSString*)groupId;

/**
 *  @brief 离开群组回调
 *  @param operationId 操作标识，由 leave 接口返回
 *  @param result true 表示成功，false 表示失败
 *  @param reason 当 result 为 false 时该值有效，参见 JCGroupReason
 *  @param groupId 群标识
 */
-(void)onLeave:(int)operationId result:(bool)result reason:(JCGroupReason)reason groupId:(NSString*)groupId;

/**
 *  @brief dealMembers 结果回调
 *  @param operationId 操作标识，由 dealMembers 接口返回
 *  @param result true 表示成功，false 表示失败
 *  @param reason 当 result 为 false 时该值有效，参见 JCGroupReason
 *  @param groupId 群标识
 */
-(void)onDealMembers:(int)operationId result:(bool)result reason:(JCGroupReason)reason groupId:(NSString*)groupId;

/**
 *  @brief inviteMember 结果回调，只表示该请求服务器成功接收
 *  @param operationId 操作表示，由 inviteMember 接口返回
 *  @param result true 表示成功，false 表示失败
 *  @param reason 当 result 为 false 时该值有效，参见 JCGroupReason
 *  @param groupId 群标识
 */
//-(void)onInviteMember:(int)operationId result:(bool)result reason:(JCGroupReason)reason groupId:(NSString*)groupId;

/**
 *  @brief 发出邀请
 *  @param inviteId 邀请的服务器id，后续和响应关联
 *  @param groupId 群 id
 *  @param groupName 群名字
 *  @param receiverServerUid 被邀请人 serverUid
 *  @param receiverName 被邀请人昵称
 *  @param info 邀请信息
 */
//-(void)onSendInvite:(int)inviteId groupId:(NSString*)groupId groupName:(NSString*)groupName receiverServerUid:(NSString*)receiverServerUid receiverName:(NSString*)receiverName info:(NSString*)info;

/**
 *  @brief 收到邀请
 *  @param inviteId 邀请的服务器id，后续和响应关联
 *  @param groupId 群 id
 *  @param groupName 群名字
 *  @param inviterServerUid 邀请人 serverUid
 *  @param inviterName 邀请人昵称
 *  @param info 邀请信息
 */
//-(void)onRecvInvite:(int)inviteId groupId:(NSString*)groupId groupName:(NSString*)groupName inviterServerUid:(NSString*)inviterServerUid inviterName:(NSString*)inviterName info:(NSString*)info;

/**
 *  @brief 更新备注信息结果回调
 *  @param operationId 操作标识
 *  @param result true 表示成功，false 表示失败
 *  @param reason 当 result 为 false 时该值有效，参见 JCGroupReason
 *  @param groupId 群标识
 */
-(void)onUpdateGroupComment:(int)operationId result:(bool)result reason:(JCGroupReason)reason groupId:(NSString*)groupId;

/**
 *  @brief 设置免打扰结果回调
 *  @param operationId 操作标识
 *  @param result true 表示成功，false 表示失败
 *  @param reason 当 result 为 false 时该值有效，参见 JCGroupReason
 *  @param groupId 群标识
 */
-(void)onSetGroupDnd:(int)operationId result:(bool)result reason:(JCGroupReason)reason groupId:(NSString*)groupId;


@end
