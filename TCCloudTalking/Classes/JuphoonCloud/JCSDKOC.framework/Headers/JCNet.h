//
//  JCNet.h
//  JCSDKOC
//
//  Created by maikireton on 2017/8/24.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCNetConstants.h"
#import "JCNetCallback.h"

@interface JCNet : NSObject

/**
 *  @brief 单例获得 JCNet 实例
 */
+ (JCNet*)shared;

/**
 *  @brief 网络类型，参见 JCNetType
 */
@property (nonatomic, readonly) JCNetType netType;

/**
 *  @brief 是否有网
 */
@property (nonatomic, readonly) BOOL hasNet;

/**
 *  @brief 设置回调
 *  @param callback 回调对象
 */
-(void)addCallback:(id<JCNetCallback>)callback;

/**
 *  @brief 删除回调
 *  @param callback 回调对象
 */
-(void)removeCallback:(id<JCNetCallback>)callback;

@end
