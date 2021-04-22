//
//  JCClientCallback.h
//  JCSDK-OC
//
//  Created by maikireton on 2017/8/10.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCClientConstants.h"

/**
 *  JCClient 回调代理
 */
@protocol JCClientCallback <NSObject>

/**
 *  @brief 登陆结果回调
 *  @param result true 表示登陆成功，false 表示登陆失败
 *  @param reason 当 result 为 false 时该值有效
 *  @see JCClientReason
 */
-(void)onLogin:(bool)result reason:(JCClientReason)reason;

/**
 *  @brief 登出回调
 *  @param reason 登出原因
 *  @see JCClientReason
 */
-(void)onLogout:(JCClientReason)reason;

/**
 *  @brief 登陆状态变化通知
 *  @param state 当前状态值
 *  @param oldState 之前状态值
 */
-(void)onClientStateChange:(JCClientState)state oldState:(JCClientState)oldState;

@end
