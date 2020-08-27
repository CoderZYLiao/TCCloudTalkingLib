//
//  JCGroupItem.h
//  JCSDKOC
//
//  Created by maikireton on 2017/8/15.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCGroupConstants.h"

/**
 *  群组对象类
 */
@interface JCGroupItem : NSObject

/**
 *  @brief 群组标识
 */
@property (nonatomic, copy, readonly) NSString* groupId;

/**
 *  @brief 群备注名称，仅自己可见
 */
@property (nonatomic, copy, readonly) NSString* nickName;

/**
 *  @brief 扩展信息，仅自己可见
 */
@property (nonatomic, copy, readonly) NSString* tag;

/**
 *  @brief 群名称
 */
@property (nonatomic, copy, readonly) NSString* name;

/**
 *  @brief 免打扰
 */
@property (nonatomic, readonly) bool dnd;

/**
 *  @brief 群组类型
 */
@property (nonatomic, readonly) JCGroupType type;

/**
 *  @brief 自定义属性
 */
@property (nonatomic, readonly) NSDictionary<NSString*, NSObject*>* customProperties;

/**
 *  @brief 群组改变状态
 */
@property (nonatomic, readonly) JCGroupChangeState changeState;

/**
 *  @return 最新一次更新时间
 */
//@property (nonatomic, readonly) long long updateTime;

/**
 *  @brief 构造 JCGroupItem
 *  @param groupId 群组唯一标识
 *  @param nickName 群备注名
 *  @param changeState 群组变化状态
 *  @return 返回 JCGroupItem 对象
 */
-(instancetype)init:(NSString*)groupId nickName:(NSString*)nickName tag:(NSString*)tag dnd:(bool)dnd changeState:(JCGroupChangeState)changeState;

-(instancetype)init:(NSString*)groupId name:(NSString*)name type:(JCGroupType)type customProperties:(NSDictionary<NSString*, NSObject*>*)customProperties;

-(instancetype)init:(NSString*)groupId changeState:(JCGroupChangeState)changeState;

@end
