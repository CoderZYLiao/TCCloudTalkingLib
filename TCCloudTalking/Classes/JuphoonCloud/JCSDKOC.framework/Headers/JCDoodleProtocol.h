//
//  JCDoodleCallback.h
//  JCSDKOC
//
//  Created by young on 2017/12/29.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCDoodleAction.h"

/**
 *  @brief 代理事件
 */
@protocol JCDoodleCallback <NSObject>
/**
 *  @brief 涂鸦回调
 *  @param doodleAction JCDoodleAction对象
 *
 */
- (void)onDoodleActionGenerated:(JCDoodleAction *)doodleAction;

@end

/**
 *  @brief 代理事件
 */
@protocol JCDoodleInteractor <NSObject>
/**
 *  @brief 向 UI 控件回调收到的JCDoodleAction对象，该回调由用户收到涂鸦数据后调用 doodleActionFromString 接口触发。
 *  @param doodleAction JCDoodleAction对象
 */
- (void)onDoodleActionReceived:(JCDoodleAction *)doodleAction;

@end


