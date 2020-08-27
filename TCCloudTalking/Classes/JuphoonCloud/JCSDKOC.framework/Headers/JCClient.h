//
//  JCClient.h
//  JCSDK-OC
//
//  Created by maikireton on 2017/8/10.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCClientCallback.h"

/// 创建参数
@interface JCClientCreateParam : NSObject

/// sdk信息存储目录
@property (nonatomic, copy) NSString* __nonnull sdkInfoDir;

/// sdk日志目录
@property (nonatomic, copy) NSString* __nonnull sdkLogDir;

/// sdk日志等级 JCLogLevel
@property (nonatomic) JCLogLevel sdkLogLevel;

@end

/// 登录参数
@interface JCClientLoginParam : NSObject

/// 设备id，一般模拟器使用，因为模拟器可能获得的设备id都一样
@property (nonatomic, copy) NSString* __nonnull deviceId;

/// https代理, 例如 192.168.1.100:3128
@property (nonatomic, copy) NSString* __nullable httpsProxy;

/// 登录账号不存在的情况下是否内部自动创建该账号，默认为 true
@property (nonatomic) bool autoCreateAccount;

/**
 * @brief 终端类型，如果需要多终端登录，则需要为每一类型的设备设置一个类型
 *
 * 例如需要手机端和PC端同时能登录，则手机端设置 moblie，pc端设为 pc，
 * 在调用 login 接口时会把同一类型登录的其他终端踢下线
 * 调用 relogin 接口如果有该类型终端的登录用户则会登录失败
 */
@property (nonatomic, strong) NSString* __nonnull terminalType;

@end

/**
 *  @brief JCClient 为全局基础类，主要负责登陆登出管理及账户属性存储
 */
@interface JCClient : NSObject

/**
 *  @brief 用户标识
 *  @warning 当 state > JCClientStateIdle 该值有效
 */
@property (nonatomic, readonly, copy) NSString* __nonnull userId;

/**
 *  @brief 昵称，用于通话，消息等，可以更直观的表明身份
 */
@property (nonatomic, copy) NSString* __nonnull displayName;

/**
 * @brief 当前状态
 * @see JCClientState
*/
@property (nonatomic, readonly) JCClientState state;

/// 创建参数，只有创建成功才有值
@property (nonatomic, readonly) JCClientCreateParam* __nullable createParam;

/// 登录参数，只有调用登录接口后会有值，登出后为 nil
@property (nonatomic, readonly) JCClientLoginParam* __nullable loginParam;

/// Appkey
@property (nonatomic, readonly) NSString* __nonnull appkey;

/// 服务器用户id
@property (nonatomic, readonly) NSString* __nonnull serverUid;

/// 获取登录服务器地址
@property (nonatomic, readonly) NSString * __nonnull serverAddress;

/**
 * @brief 创建 JCClient 实例
 * @param appKey 用户从 Juphoon Cloud 平台上申请的 AppKey 字符串
 * @param callback 回调接口，用于接收 JCClient 相关通知
 * @param createParam 创建参数，nil 则按默认值创建
 * @return JCClient 对象
 */
+(JCClient* __nullable)create:(NSString* __nonnull)appKey callback:(id<JCClientCallback> __nonnull)callback creatParam:(JCClientCreateParam* __nullable)createParam;

/**
 *  @brief 销毁接口
 */
+(void)destroy;

/**
 * @brief 登陆 Juphoon Cloud 平台，只有登陆成功后才能进行平台上的各种业务
 * 服务器分为鉴权模式和非鉴权模式
 *
 *     - 鉴权模式: 服务器会检查用户名和密码
 *
 *     - 免鉴权模式: 只要用户保证用户标识唯一即可, 服务器不校验
 *
 * 登陆结果通过 JCClientCallback 通知
 *
 * @param userId 用户名
 * @param password 密码，免鉴权模式密码可以随意输入，但不能为空
 * @param serverAddress 登录服务器地址
 * @param loginParam 登录参数，nil则按照默认值登录
 * @return 返回 true 表示正常执行调用流程，false 表示调用异常，异常错误通过 JCClientCallback 通知
 * @warning 目前只支持免鉴权模式，免鉴权模式下当账号不存在时会自动去创建该账号
 * @warning 用户名为英文数字和'+' '-' '_' '.'，长度不要超过64字符，'-' '_' '.'不能作为第一个字符
 */
-(bool)login:(NSString* __nonnull)userId password:(NSString* __nonnull)password serverAddress:(NSString*__nullable)serverAddress loginParam:(JCClientLoginParam* __nullable)loginParam;

/**
 * @brief 重登录，该接口在如果有其他同类型终端登录着则会登录失败，一般用于记住了账号后重启自动登录逻辑
 * 服务器分为鉴权模式和非鉴权模式
 *
 *     - 鉴权模式: 服务器会检查用户名和密码
 *
 *     - 免鉴权模式: 只要用户保证用户标识唯一即可, 服务器不校验
 *
 * 登陆结果通过 JCClientCallback 通知
 *
 * @param userId 用户名
 * @param password 密码，免鉴权模式密码可以随意输入，但不能为空
 * @param serverAddress 登录服务器地址
 * @param loginParam 登录参数，nil则按照默认值登录
 * @return 返回 true 表示正常执行调用流程，false 表示调用异常，异常错误通过 JCClientCallback 通知
 * @warning 目前只支持免鉴权模式，免鉴权模式下当账号不存在时会自动去创建该账号
 * @warning 用户名为英文数字和'+' '-' '_' '.'，长度不要超过64字符，'-' '_' '.'不能作为第一个字符
 */
-(bool)relogin:(NSString* __nonnull)userId password:(NSString* __nonnull)password serverAddress:(NSString*__nullable)serverAddress loginParam:(JCClientLoginParam* __nullable)loginParam;

/**
 *  登出 Juphoon Cloud 平台，登出后不能进行平台上的各种业务
 *  @return 返回 true 表示正常执行调用流程，false 表示调用异常，异常错误通过 JCClientCallback 通知
 */
-(bool)logout;

@end
