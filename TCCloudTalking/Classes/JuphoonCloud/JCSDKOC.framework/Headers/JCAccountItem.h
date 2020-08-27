//
//  JCAccountItem.h
//  JCSDKOC
//
//  Created by Ginger on 2018/6/8.
//  Copyright © 2018年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCAccountConstants.h"

/**
 *  查询账号结果对象
 */
@interface JCAccountItem : NSObject

/**
 *  @brief 查询账号
 */
@property (nonatomic, copy) NSString* __nonnull userId;
/**
 *  @brief 查询账号状态结果
 */
@property (nonatomic, assign) JCAccountUserStatus status;

@end
