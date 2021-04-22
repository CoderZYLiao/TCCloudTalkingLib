//
//  JCAccount.h
//  JCSDKOC
//
//  Created by Ginger on 2018/6/8.
//  Copyright © 2018年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCAccountCallback.h"
#import "JCAccountItem.h"

/**
 * @brief  账号类
 */
@interface JCAccount : NSObject

/**
 * @brief 创建 JCAccount 实例
 * @param callback    回调接口，用于接收 JCAccount 相关回调事件
 * @return JCAccount  实例
 */
+ (JCAccount*)create:(id<JCAccountCallback>)callback;

/**
 * @brief 销毁 JCAccount 实例
 */
+ (void)destroy;

/**
 * @brief 查询账号状态
 * @param userIdArray 查询的账号
 * @return 返回操作id
 */
- (int)queryUserStatus:(NSArray<NSString*>*)userIdArray;

/**
 * @brief 查询 serverUid
 * @param userIdArray 查询的账号
 * @return 返回操作id
 */
- (int)queryServerUid:(NSArray<NSString*>*)userIdArray;

/**
 * @brief 查询 userId
 * @param serverUidArray 查询 serverUid
 * @return 返回操作id
 */
- (int)queryUserId:(NSArray<NSString*>*)serverUidArray;

/**
 * @brief 查询所有的联系人（支持增量）
 * @param lastQueryTime 上次更新时间戳
 * @return 返回操作id
 */
- (int)refreshContacts:(long)lastQueryTime;

/**
 * @brief 操作联系人
 * @param contact 联系人对象
 * @return 返回操作id
 */
- (int)dealContact:(JCAccountContact*)contact;

/**
 *  @brief 设置免打扰
 *  @param contactServerUid 用户服务器uid
 *  @param dnd 是否免打扰
 *  @return 返回操作id
 */
- (int)setDnd:(NSString*)contactServerUid dnd:(bool)dnd;

/**
 * @brief 添加回调
 * @param callback JCAccountCallback 接口对象
 */
- (void)addCallback:(id<JCAccountCallback>)callback;

/**
 * @brief 删除回调
 * @param callback JCAccountCallback 接口对象
 */
- (void)removeCallback:(id<JCAccountCallback>)callback;

@end
