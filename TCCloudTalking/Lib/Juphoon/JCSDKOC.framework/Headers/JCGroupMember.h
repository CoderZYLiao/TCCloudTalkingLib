//
//  JCGroupMember.h
//  JCSDKOC
//
//  Created by maikireton on 2017/8/15.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCGroupConstants.h"

/**
 *  群组成员类
 */
@interface JCGroupMember : NSObject

/*
 *  @return 群组标识
 */
@property (nonatomic, copy) NSString* groupId;

/*
 *  @return 用户标识
 */
@property (nonatomic, copy) NSString* userId;

/*
 *  @return 服务器端用户标识
 *  @warning 当通知成员变化时，changeState 为 JCGroupChangeStateRemove 时只能通过此参数来判断，不能通过 userId
 */
@property (nonatomic, copy) NSString* uid;

/*
 *  @return 用户昵称
 */
@property (nonatomic, copy) NSString* displayName;

/*
 *  @return 角色类型，参见 JCGroupMemberType
 */
@property (nonatomic) JCGroupMemberType memberType;

/**
 *  @brief 成员改变状态
 */
@property (nonatomic,) JCGroupChangeState changeState;

/**
 *  @brief 构造 JCGroupMember
 *  @param groupId 群组唯一标识
 *  @param userId 用户标识
 *  @param displayName 昵称
 *  @param memberType 成员类型
 *  @param changeState 成员变化状态
 *  @return 返回 JCGroupItem 对象
 */
-(instancetype)init:(NSString*)groupId userId:(NSString*)userId uid:(NSString*)uid displayName:(NSString*)displayName memberType:(JCGroupMemberType)memberType changeState:(JCGroupChangeState)changeState;

@end
