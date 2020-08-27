//
//  JCMediaDeviceCallback.h
//  JCSDK-OC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCMediaDeviceConstants.h"

/**
 *  JCMediaDeviceCallback 回调代理
 */
@protocol JCMediaDeviceCallback <NSObject>

/**
 *  @brief 摄像头变化
 */
-(void)onCameraUpdate;

/**
 *  @brief 音频输出变化
 *  @param audioOutputType 音频输出类型
 */
-(void)onAudioOutputTypeChange:(NSString*)audioOutputType;

/**
 *  @brief 收到第一帧数据
 *  @param canvas 渲染对象
 */
-(void)onRenderReceived:(JCMediaDeviceVideoCanvas*)canvas;

/**
 *  @brief 渲染开始
 *  @param canvas 渲染对象
 */
-(void)onRenderStart:(JCMediaDeviceVideoCanvas*)canvas;

/**
 *  @brief 声音中断恢复
 *  @param interrupt true 表示中断，false 表示恢复
 */
-(void)onAudioInerruptAndResume:(BOOL)interrupt;

@end
