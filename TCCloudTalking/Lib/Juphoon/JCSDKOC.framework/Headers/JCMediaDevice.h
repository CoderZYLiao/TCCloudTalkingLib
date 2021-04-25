//
//  JCMediaDevice.h
//  JCSDK-OC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCClient.h"
#import "JCMediaDeviceVideoCanvas.h"
#import "JCMediaDeviceCallback.h"
#import "JCMediaDeviceConstants.h"

/// 摄像头对象
@interface JCMediaDeviceCamera : NSObject

/// 摄像头id
@property (nonatomic, readonly) NSString* __nonnull cameraId;

/// 摄像头名字
@property (nonatomic, readonly) NSString* __nonnull cameraName;

/// 摄像头类型
@property (nonatomic, readonly) JCMediaDeviceCameraType cameraType;

@end

/// 音频设备对象，mac 使用
@interface JCMediaDeviceAudio : NSObject

/// 音频设备id
@property (nonatomic, readonly) NSString* __nonnull audioId;

/// 音频设备名字
@property (nonatomic, readonly) NSString* __nonnull audioName;

/// 输入还是输出设备
@property (nonatomic, readonly) bool input;

@end

/// 窗口对象，mac 使用
@interface JCMediaDeviceWindow : NSObject

/// 窗口id
@property (nonatomic, readonly) NSString* __nonnull windowId;

/// 窗口名字
@property (nonatomic, readonly) NSString* __nonnull windowName;

@end


@interface JCMediaDeviceAudioParam : NSObject

/// 音频采样率，0 表示自动选择，手表等设备可以设置为8000
@property (nonatomic) int audioInputSamplingRate;

/// 音频采样率，0 表示自动选择，手表等设备可以设置为8000
@property (nonatomic) int audioOutputSamplingRate;

/// 0 表示自动选择
@property (nonatomic) int audioInputChannelNumber;

/// 0 表示自动选择
@property (nonatomic) int audioOutputChannelNumber;

@end

/**
 *  设备模块
 */
@interface JCMediaDevice : NSObject

/**
 *  @brief 摄像头是否打开
 */
@property (nonatomic, readonly) bool cameraOpen;

/**
 *  @brief 文件播放是否打开
 */
@property (nonatomic, readonly) bool videoFileOpen;

/**
 *  @brief 正在使用的摄像头
 */
@property (nonatomic, strong, readonly) JCMediaDeviceCamera* __nullable camera;

/// 摄像头列表
@property (nonatomic, readonly) NSArray<JCMediaDeviceCamera*> *  __nonnull cameras;

/// 默认摄像头
@property (nonatomic, strong) JCMediaDeviceCamera* __nullable defaultCamera;

/// 音频参数
@property (nonatomic, strong) JCMediaDeviceAudioParam * _Nonnull audioParam;

/**
 *  @brief 视频文件作为本地视频源的渲染标识
 */
@property (nonatomic, strong, readonly) NSString* __nonnull videoFileId;

/**
 *  @brief 是否声音被中断
 */
@property (nonatomic, readonly) bool audioInterrupt;

/**
 *  @brief 视频角度
 */
@property (nonatomic) JCMediaDeviceVideoAngel videoAngle;

/**
 * 是否使用内部音频设备逻辑
 *
 * 1.打开扬声器 -> 使用扬声器输出声音
 * 2.连上蓝牙耳机 -> 使用蓝牙耳机输出声音，如果扬声器开着则关闭扬声器
 * 3.插入耳机 -> 使用耳机输出声音，如果扬声器开着则关闭扬声器
 * 4.蓝牙耳机和有线耳机以最后连上的作为输出
 * 5.关闭扬声器 -> (蓝牙耳机|有线耳机) > 听筒
*/
@property (nonatomic) bool useInternalAudioDeviceLogic;

/**
 * @biref 音频是否启动
 */
@property (nonatomic, readonly) bool audioStart;

#if TARGET_OS_OSX
/// 音频输入设备列表，mac 使用
@property (nonatomic, readonly) NSArray<JCMediaDeviceAudio*>* __nonnull audioInputs;

/// 当前音频输入设备，mac 使用
@property (nonatomic, strong) JCMediaDeviceAudio* __nullable audioInput;

/// 音频输出设备列表，mac 使用
@property (nonatomic, readonly) NSArray<JCMediaDeviceAudio*>* __nonnull audioOutputs;

/// 当前音频输出设备，mac 使用
@property (nonatomic, strong) JCMediaDeviceAudio* __nullable audioOutput;

/// 桌面列表，mac 使用
@property (nonatomic, readonly) NSArray<JCMediaDeviceWindow*>* __nonnull desktops;

/// 窗口列表，mac 使用
@property (nonatomic, readonly) NSArray<JCMediaDeviceWindow*>* __nonnull windows;

/// 屏幕分享的窗口
@property (nonatomic, strong) JCMediaDeviceWindow* __nullable screenshareWindow;
#endif

/**
 *  @brief 创建 JCMediaDevice 对象
 *  @param client JCClient 对象
 *  @param callback JCMediaDeviceCallback 回调接口，用于接收 JCMediaDevice 相关通知
 *  @return 返回 JCMediaDevice 对象
 */
+(JCMediaDevice* __nullable)create:(JCClient* __nonnull)client callback:(id<JCMediaDeviceCallback> __nonnull)callback;

/**
 *  @brief 销毁接口
 */
+(void)destroy;

/**
 *  @brief 获得预览视频对象，通过此对象能获得视图用于UI显示
 *  @param type 渲染模式，@ref JCMediaDeviceRender
 *  @return JCMediaDeviceVideoCanvas 对象
 */
-(JCMediaDeviceVideoCanvas* __nullable)startCameraVideo:(JCMediaDeviceRender)type;

/**
 *  @brief 获得预览视频对象，通过此对象能获得视图用于UI显示
 *  @param type 渲染模式，@ref JCMediaDeviceRender
 *  @param view        视图view
 *  @return JCMediaDeviceVideoCanvas 对象
 */
-(JCMediaDeviceVideoCanvas* __nullable)startCameraVideo:(JCMediaDeviceRender)type view:(JCView* __nonnull)view;

/**
 *  @brief 获得预览视频对象，通过此对象能获得视图用于UI显示
 *  @param videoSource 渲染标识串，比如 JCMediaChannelParticipant JCCallItem 中的 renderId，当videoSource 为 videoFileId 时，内部会调用 startVideoFile
 *  @param type        渲染模式，@ref JCMediaDeviceRender
 *  @return JCMediaDeviceVideoCanvas 对象
 */
-(JCMediaDeviceVideoCanvas* __nullable)startVideo:(NSString* __nonnull)videoSource renderType:(JCMediaDeviceRender)type;

/**
 *  @brief 获得预览视频对象，通过此对象能获得视图用于UI显示
 *  @param videoSource 渲染标识串，比如 JCMediaChannelParticipant JCCallItem 中的 renderId，当videoSource 为 videoFileId 时，内部会调用 startVideoFile
 *  @param type        渲染模式，@ref JCMediaDeviceRender
 *  @param view        视图view
 *  @return JCMediaDeviceVideoCanvas 对象
 */
-(JCMediaDeviceVideoCanvas* __nullable)startVideo:(NSString* __nonnull)videoSource renderType:(JCMediaDeviceRender)type view:(JCView* __nonnull)view;

/**
 *  @brief 停止视频
 *  @param canvas JCMediaDeviceVideoCanvas 对象，由 startVideo 获得
 */
-(void)stopVideo:(JCMediaDeviceVideoCanvas* __nonnull)canvas;

/**
 *  @brief 启动音频，一般正式开启通话前需要调用此接口
 *  @return 成功返回 true，失败返回 false
 */
-(bool)startAudio;

/**
 *  @brief 停止音频，一般在通话结束时调用
 *  @return 成功返回 true，失败返回 false
 */
-(bool)stopAudio;

/**
 *  @breif 开启摄像头
 *  @return 成功返回 true，失败返回 false
 */
-(bool)startCamera;

/**
 *  @breif 关闭摄像头
 *  @return 成功返回 true，失败返回 false
 */
-(bool)stopCamera;

/**
 *  @breif 切换摄像头，内部会根据当前摄像头类型来进行切换
 *  @return 成功返回 true，失败返回 false
 */
-(bool)switchCamera;

/// 切换指定摄像头
/// @param camera 摄像头
-(bool)switchCamera:(JCMediaDeviceCamera* __nonnull)camera;

/**
 *  @breif 设置摄像头采集属性
 *  @param width 采集宽度，默认640
 *  @param height 采集高度，默认360
 *  @param framerate 帧速率，默认30
 */
- (void)setCameraProperty:(int)width height:(int)height framerate:(int)framerate;

/**
 *  @breif 设置屏幕共享采集属性
 *  @param width 采集宽度，默认640
 *  @param height 采集高度，默认360
 *  @param framerate 帧速率，默认10
 */
- (void)setScreenCaptureProperty:(int)width height:(int)height framerate:(int)framerate;

/**
 *  @brief 开启视频文件作为视频输入源，文件和摄像头作为视频输入源只能存在一种，当前摄像头开启的话会关闭摄像头
 *  @return 是否成功
 */
-(bool)startVideoFile;

/**
 *  @brief 向文件视频源逐帧添加视频数据
 *  @param srcFrame 画面二进制数据
 *  @param format 视频像素格式
 *  @param width 宽
 *  @param height 高
 */
-(void)setVideoFileFrame:(NSData* __nonnull)srcFrame format:(JCMediaDeviceVideoPixelFormat)format width:(int)width height:(int)height;

/**
 *  @brief 向文件视频源逐帧添加视频数据
 *  @param srcFrame  视频数据
 *  @param angle 角度, 为 90 的倍数
 *  @param mirror 是否镜像，0 不镜像，1 镜像
 */
-(void)setVideoFileFrame:(CVPixelBufferRef __nonnull)srcFrame angle:(int)angle mirror:(int)mirror;

/**
 *  @brief 关闭文件视频源
 *  @return ture表示关闭成功，false表示关闭失败
 */
-(bool)stopVideoFile;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

/**
 *  @brief 没有插入耳机或外接蓝牙时是否默认开启扬声器，iOS 使用
 */
@property (nonatomic) bool defaultSpeakerOn;

/**
 *  @brief 开启关闭扬声器，iOS 使用
 *  @param enable 是否开启
 */
-(void)enableSpeaker:(bool)enable;

/**
 *  @brief 获得当前音频模式，目前只支持听筒和扬声器，iOS 使用
 *  @return 音频模式
 */
-(NSString* __nullable)getAudioOutputType;

/**
 *  @brief 是否开启了扬声器，iOS 使用
 *  @return ture表示开启，false表示未开启
 */
-(bool)isSpeakerOn;

#endif
@end
