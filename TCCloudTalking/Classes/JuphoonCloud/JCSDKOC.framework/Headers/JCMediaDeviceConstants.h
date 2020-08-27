//
//  JCMediaDeviceConstants.h
//  JCSDK-OC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  窗口与屏幕角度
 */
typedef NS_ENUM(NSInteger, JCMediaDeviceRotateAngle) {
    /// 窗口与屏幕角度 0
    JCMediaDeviceRotateAngle0 = 0,
    /// 窗口与屏幕角度 90
    JCMediaDeviceRotateAngle90 = 90,
    /// 窗口与屏幕角度 180
    JCMediaDeviceRotateAngle180 = 180,
    /// 窗口与屏幕角度 270
    JCMediaDeviceRotateAngle270 = 270,
};

/**
 *  渲染模式
 */
typedef NS_ENUM(NSInteger, JCMediaDeviceRender) {
    /// 视频图像按比例填充整个渲染区域（裁剪掉超出渲染区域的部分区域）
    JCMediaDeviceRenderFullScreen = 0,
    /// 视频图像的内容完全呈现到渲染区域（可能会出现黑边，类似放电影的荧幕）
    JCMediaDeviceRenderFullContent,
    /// 自动
    JCMediaDeviceRenderFullAuto,
};

/**
 *  视频像素格式
 */
typedef NS_ENUM(NSInteger, JCMediaDeviceVideoPixelFormat) {
    /// I420
    JCMediaDeviceVideoPixelFormatI420 = 1,
    /// IYUV
    JCMediaDeviceVideoPixelFormatIYUV = 2,
    /// RGB24
    JCMediaDeviceVideoPixelFormatRGB24 = 3,
    /// ABGR
    JCMediaDeviceVideoPixelFormatABGR = 4,
    /// ARGB
    JCMediaDeviceVideoPixelFormatARGB = 5,
    /// ARGB444
    JCMediaDeviceVideoPixelFormatARGB444 = 6,
    /// RGB565
    JCMediaDeviceVideoPixelFormatRGB565 = 7,
    /// ARGB1555
    JCMediaDeviceVideoPixelFormatARGB1555 = 8,
    /// YUY2
    JCMediaDeviceVideoPixelFormatYUY2 = 9,
    /// YV12
    JCMediaDeviceVideoPixelFormatYV12 = 10,
    /// UYVY
    JCMediaDeviceVideoPixelFormatUYVY = 11,
    /// MJPG
    JCMediaDeviceVideoPixelFormatMJPG = 12,
    /// NV21
    JCMediaDeviceVideoPixelFormatNV21 = 13,
    /// NV12
    JCMediaDeviceVideoPixelFormatNV12 = 14,
    /// BGRA
    JCMediaDeviceVideoPixelFormatBGRA = 15
};

typedef NS_ENUM(NSInteger, JCMediaDeviceVideoAngel) {
    JCMediaDeviceVideoAngelAuto = -1,
    JCMediaDeviceVideoAngel0 = 0,
    JCMediaDeviceVideoAngel90 = 90,
    JCMediaDeviceVideoAngel180 = 180,
    JCMediaDeviceVideoAngel270 = 270
};

typedef NS_ENUM(NSInteger, JCMediaDeviceCameraType) {
    JCMediaDeviceCameraTypeNone = 0,
    JCMediaDeviceCameraTypeFront = 1,
    JCMediaDeviceCameraTypeBack = 2,
    JCMediaDeviceCameraTypeUnknown = 3
};
