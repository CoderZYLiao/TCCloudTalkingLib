//
//  JCClientConstants.h
//  JCSDK-OC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  原因枚举
 */
typedef NS_ENUM(NSInteger, JCClientReason) {
    /// 正常
    JCClientReasonNone,
    /// sdk 未初始化
    JCClientReasonSDKNotInit,
    /// 无效的参数
    JCClientReasonInvalidParam,
    /// 函数调用失败
    JCClientReasonCallFunctionError,
    /// 当前状态无法再次登录
    JCClientReasonStateCannotLogin,
    /// 超时
    JCClientReasonTimeOut,
    /// 网络异常
    JCClientReasonNetWork,
    /// appkey 错误
    JCClientReasonAppKey,
    /// 账号密码错误
    JCClientReasonAuth,
    /// 无该用户
    JCClientReasonNoUser,
    /// 被强制登出
    JCClientReasonServerLogout,
    /// 其他设备已登录
    JCClientReasonAnotherDeviceLogined,
    /// 本地请求失败
    JCClientReasonLocalRequest,
    /// 发消息失败
    JCClientReasonSendMessage,
    /// 服务器忙
    JCClientReasonServerBusy,
    /// 服务器不可达
    JCClientReasonServerNotReach,
    /// 服务器不可达
    JCClientReasonServerForbidden,
    /// 服务器不可用
    JCClientReasonServerUnavaliable,
    /// DNS 查询错误
    JCClientReasonDnsQuery,
    /// 服务器内部错误
    JCClientReasonInternal,
    /// 无资源
    JCClientReasonNoResource,
    /// 没有回应验证码
    JCClientReasonNoNonce,
    /// 无效验证码
    JCClientReasonInvalidAuthCode,
    /// token不匹配
    JCClientReasonTokenMismatch,
    /// 其他错误
    JCClientReasonOther = 100,
};

/**
 *  状态枚举
 */
typedef NS_ENUM(NSInteger, JCClientState) {
    /// 未初始化
    JCClientStateNotInit,
    /// 未登陆
    JCClientStateIdle,
    /// 登陆中
    JCClientStateLogining,
    /// 登陆成功
    JCClientStateLogined,
    /// 登出中
    JCClientStateLogouting,
};

typedef NS_ENUM(NSInteger, JCLogLevel) {
    /// Disable
    JCLogLevelDisable,
    /// Error
    JCLogLevelError,
    /// Info
    JCLogLevelInfo,
    /// Debug
    JCLogLevelDebug
};
