//
//  JCDoodle.h
//  JCSDKOC
//
//  Created by young on 2017/12/29.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCDoodleAction.h"
#import "JCDoodleProtocol.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kJCDataTypeDoodle;

/**
 *  @brief 涂鸦类
 */
@interface JCDoodle : NSObject

/**
 *  @brief 创建 JCDoodle 对象
 *  @param callback JCDoodleCallback 回调对象
 *  @return 返回 JCDoodle 对象
 */
+ (JCDoodle *)create:(id<JCDoodleCallback>)callback;

/**
 *  @brief 销毁 JCDoodle 对象
 *
 */
+ (void)destroy;

/**
 *  @brief 把JCDoodleAction对象转换成字符串，转换后的字符串可用于数据传输。
 *  @param doodleAction 不能为nil
 *  @return 字符串
 */
- (nullable NSString *)stringFromDoodleAction:(JCDoodleAction *)doodleAction;


/**
 *  @brief 把字符串转换成JCDoodleAction对象。
 *  @param doodleActionData 必须是用stringFromDoodleAction接口转换的字符串
 *  @return JCDoodleAction对象，当 doodleActionData 不符合条件时返回为空
 *
 */
- (nullable JCDoodleAction *)doodleActionFromString:(NSString *)doodleActionData;


/**
 *  @brief 将 UI 控件产生的 JCDoodleAction 对象注入 SDK。SDK 会通过 onDoodleActionGenerated 回调 doodleAction 对象。
 *  本方法仅供 UI 控件调用。
 *
 *  @param doodleAction 交付的涂鸦对象
 *
 */
- (void)generateDoodleAction:(JCDoodleAction *)doodleAction;


/**
 *  @brief 绑定 Doodle UI 控件
 *  @param interactor 实现<JCDoodleInteractor>的 UI 控件实例
 */
- (void)bindDoodleInteractor:(id<JCDoodleInteractor>)interactor;


@end

NS_ASSUME_NONNULL_END
