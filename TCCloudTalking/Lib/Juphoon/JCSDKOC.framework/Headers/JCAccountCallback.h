//
//  JCAccountCallback.h
//  JCSDKOC
//
//  Created by Ginger on 2018/6/8.
//  Copyright © 2018年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCAccountItem.h"
#import "JCAccountContact.h"

/**
 *  @brief 代理事件
 */
@protocol JCAccountCallback <NSObject>

/**
 *  @brief  查询账号状态结果回调
 *  @param operationId      操作ID，由queryUserStatus接口返回
 *  @param queryResult      查询是否成功
 *  @param accountItemList  查询结果
 */
- (void)onQueryUserStatusResult:(int)operationId result:(BOOL)queryResult accountItemList:(NSArray<JCAccountItem*>*)accountItemList;

/**
 * @brief 查询账号 serverUid 结果回调
 * @param operationId 操作ID, 由queryServerUid接口返回
 * @param queryResult 查询是否成功, 成功但不一定所有查询 userId 都有 serverUid
 * @param serverUids 查询结果
 */
- (void)onQueryServerUidResult:(int)operationId result:(BOOL)queryResult serverUids:(NSDictionary<NSString*, NSString*>*)serverUids;

/**
 * @brief 查询账号 userId 结果回调
 * @param operationId 操作ID, 由queryUserId接口返回
 * @param queryResult 查询是否成功, 成功但不一定所有查询d serverUid 都有 userId
 * @param userIds 查询结果
 */
- (void)onQueryUserIdResult:(int)operationId result:(BOOL)queryResult userIds:(NSDictionary<NSString*, NSString*>*)userIds;

/**
 * @brief 查询网络联系人列表结果回调
 * @param operationId 操作ID, 由queryUserId接口返回
 * @param result 刷新是否成功
 * @param contacts 联系人队列
 * @param updateTime 服务器更新时间
 * @param fullUpdate 是否全更新
 */
- (void)onRefreshContacts:(int)operationId result:(BOOL)result contacts:(NSArray<JCAccountContact*>*)contacts updateTime:(long)updateTime fullUpdate:(bool)fullUpdate;

/**
 *  @brief 处理联系人结果回调
 *  @param operationId 操作ID
 *  @param result 操作是否成功
 *  @param reason 原因
 */
- (void)onDealContact:(int)operationId result:(BOOL)result reason:(JCAccountReason)reason;

/**
 *  @brief 服务器联系人变化，上层主动  refreshContacts
 */
- (void)onContactsChange:(NSArray<JCAccountContact*>*)contacts;

/**
 *  @brief 处理联系人结果回调
 *  @param operationId 操作ID
 *  @param result 操作是否成功
 *  @param reason 原因
 */
-(void)onSetContactDnd:(int)operationId result:(bool)result reason:(JCAccountReason)reason;

@end
