//
//  JCMediaDeviceVideoCanvas.h
//  JCSDK-OC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCMediaDeviceConstants.h"
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIKit.h>
#define JCView UIView
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#define JCView NSView
#endif

/**
 *  视频对象，用于UI层方便操作视频
 */
@interface JCMediaDeviceVideoCanvas : NSObject

/**
 *  @brief 渲染标识
 */
@property (nonatomic, readonly) NSString* videoSource;

/**
 *  @return 视频视图，用于UI显示
 */
@property (nonatomic, readonly, strong) JCView* videoView;

/**
 *  @brief 渲染模式
 */
@property (nonatomic, readonly) int renderType;

/**
 *  @brief 自定义数据
 */
@property (nonatomic) id customData;

/**
 *  @breif 更新视频渲染标识
 *  @param videoSource 视频源
 *  @return 成功返回 true，失败返回 false
 */
-(bool)replace:(NSString*)videoSource;

/**
 *  @brief 暂停视频渲染
 */
-(void)pause;

/**
 *  @brief 恢复视频渲染
 */
-(void)resume;

/**
 * @brief 旋转角度，必须是90的倍数，该角度表示与屏幕正方向旋转后的夹角
 * @param angle 角度值
 */
-(void)rotate:(int)angle;

/**
 *  @breif 视频通话截图
 *  @param width 截屏宽度像素，-1为视频源像素
 *  @param height 截屏高度像素，-1为视频源像素
 *  @param filePath 文件路径
 */
-(bool)snapshot:(int)width heigh:(int)height filePath:(NSString*)filePath;

@end
