//
//  JCMediaChannelQueryInfo.h
//  JCSDKOC
//
//  Created by maikireton on 2017/8/25.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  媒体频道查询信息结果
 */
@interface JCMediaChannelQueryInfo : NSObject

/**
 *  @brief 频道标识
 */
@property (nonatomic, readonly, copy) NSString* channelId;

/**
 *  @brief 频道号
 */
@property (nonatomic, readonly) int number;

/**
 *  @brief 成员数
 */
@property (nonatomic, readonly) int clientCount;

/**
 *  @brief 获取成员列表
 */
@property (nonatomic, readonly, strong) NSMutableArray *members;

@end
