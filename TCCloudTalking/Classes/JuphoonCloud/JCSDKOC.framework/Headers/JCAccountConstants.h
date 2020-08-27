//
//  JCAccountConstants.h
//  JCSDKOC
//
//  Created by chendi on 2018/6/21.
//  Copyright © 2018 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用户状态
 */
typedef NS_ENUM(NSInteger, JCAccountUserStatus) {
    /// 查询异常
    JCAccountUserStatusError,
    /// 用户未注册
    JCAccountUserStatusNotFound,
    /// 用户离线
    JCAccountUserStatusOffline,
    /// 用户推送状态
    JCAccountUserStatusPush,
    /// 用户在线
    JCAccountUserStatusOnline
};

/**
 *  联系人变化状态
 */
typedef NS_ENUM(NSInteger, JCAccountContactChangeState) {
    /// 新增
    JCAccountContactChangeStateAdd = 0,
    /// 更新
    JCAccountContactChangeStateUpdate,
    /// 删除
    JCAccountContactChangeStateRemove,
};

typedef NS_ENUM(NSInteger, JCAccountContactType) {
    /// 无关系
    JCAccountContactTypeNone = -1,
    /// 陌生人
    JCAccountContactTypeStranger = 15,
    /// 系统
    JCAccountContactTypeSystem = 18,
};

/**
 *  错误枚举
 */
typedef NS_ENUM(NSInteger, JCAccountReason) {
    /// 正常
    JCAccountReasonNone,
    /// 未登陆
    JCAccountReasonNotLogin,
    /// 函数调用失败
    JCAccountReasonCallFunctionError,
    /// 超时
    JCAccountReasonTimeOut,
    /// 网络异常
    JCAccountReasonNetWork,
    /// 参考错误
    JCAccountReasonInvalid,
    /// 内部获得 Agent 失败
    JCAccountReasonGetAgent,
    /// 服务器错误
    JCAccountReasonServer,
    /// 更新时间无效
    JCAccountReasonUpdateTimeInvalid,
    /// 禁止操作
    JCAccountReasonPermissionDenied,
    /// Uid 找不到
    JCAccountReasonUidNotFound,
    /// 关系不存在
    JCAccountReasonChangeNotExists,
    /// 关系已存在
    JCAccountReasonAddAlreadyExists,
    /// 不能添加自己
    JCAccountReasonAddSelf,
    /// 关系类型错误
    JCAccountReasonRelationTypeInvalid,
    /// 删除的关系不存在
    JCAccountReasonRemoveNotExist,
    /// 状态类型错误
    JCAccountReasonStatusTypeError,
    /// 只允许一个创建者
    JCAccountReasonWriteOwnerError,
    /// 写入属性错误
    JCAccountReasonSetWriteProperty,
    /// 类型不被允许
    JCAccountReasonApplyTypeGranted,
    /// 缺少群名
    JCAccountReasonLackOfGroupName,
    /// 未知的群类型
    JCAccountReasonUnknownGroupType,
    /// 非群主
    JCAccountReasonOwnerNotInvoker,
    /// 不在群中
    JCAccountReasonNotInGroup,
    /// 在黑名单中
    JCAccountReasonBlacklist,
    /// 群已满
    JCAccountReasonCapacityFull,
    /// 不属于群
    JCAccountReasonNotBelongToGroup,
    /// 权限不够
    JCAccountReasonWriteExceedRight,
    /// 查询Uid错误
    JCAccountReasonQueryUid,
    /// 数据库错误
    JCAccountReasonDBError,
    /// 没找到关系
    JCAccountReasonRelationNotFound,
    /// 无属性
    JCAccountReasonRelationNoProperty,
    /// 其他错误
    JCAccountReasonOther = 100
};
