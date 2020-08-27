//
//  JCMediaChannel.h
//  JCSDK-OC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCMediaChannelCallback.h"
#import "JCMediaChannelParticipant.h"
#import "JCMediaChannelConstants.h"
#import "JCMediaChannelQueryInfo.h"

@interface JCMediaChannelSipParamExtra : NSObject
/// JCMediaChannel.inviteSipUser 参数 userId 是号码还是 sipUri
@property (nonatomic) bool sipUri;
/// sipUri 为 true 才生效，决定 sip 信令是否路由到 userId 的 sip 域里
@property (nonatomic) bool route;
/// sip用户加入会议后的昵称
@property (nonatomic, strong) NSString* __nullable displayName;
/// JCMediaChannel.inviteSipUser 参数 userId 是否为 Mcu 会议
@property (nonatomic) bool mcu;
/// 是否需要视频接入
@property (nonatomic) bool video;
/// dtmf 密码
@property (nonatomic, strong) NSString* __nullable dtmfPassowrd;
/// 生成json字符串
-(NSString* __nonnull)toParamString;

@end

/**
 *  @brief Sip 参数类
 */
@interface JCMediaChannelSipParam : NSObject

/// SIP呼叫 主叫号码
@property (nonatomic, strong) NSString* __nullable callerNumber;
/// 核心网ID
@property (nonatomic, strong) NSString* __nullable coreNetwork;
/// 额外信息
@property (nonatomic) JCMediaChannelSipParamExtra* __nullable extra;

@end

/**
 *  @brief 录制其他参数
 */
@interface JCMediaChannelRecordParam : NSObject

/// 录制字符串
@property (nonatomic, strong) NSString* __nonnull recoredString;

/**
 * @brief 七牛录制参数构造
 *
 * @param video 是否是视频录制
 * @param bucketName 七牛云 bucketName
 * @param secretKey 七牛云 secretKey
 * @param accessKey 七牛云 accessKey
 * @param fileName 录制文件名
 * @return 录制参数字符串
 */
+(NSString* __nonnull)buildQiniuRecordParam:(BOOL)video bucketName:(NSString* __nonnull)bucketName secretKey:(NSString* __nonnull)secretKey accessKey:(NSString* __nonnull)accessKey fileName:(NSString* __nonnull)fileName;

@end

/**
 *  @brief 加入会议参数类
 */
@interface JCMediaChannelJoinParam : NSObject

/// 会议最大人数
@property (nonatomic) int capacity;
/// 推流参数
@property (nonatomic, strong) NSString* __nullable cdn;
/// 录制参数
@property (nonatomic, strong) JCMediaChannelRecordParam * __nullable record;
/// 密码
@property (nonatomic, strong) NSString* __nonnull password;
/// 平滑模式
@property (nonatomic) bool smooth;
/// 会议最大分辨率 JCMediaChannelMaxResolution
@property (nonatomic) JCMediaChannelMaxResolution maxResolution;
/// uri 模式, join 函数的参数为会议 uri
@property (nonatomic) bool uriMode;
/// 心跳间隔
@property (nonatomic) int heartbeatTime;
/// 心跳超时
@property (nonatomic) int heartbeatTimeout;
/// 帧率 1-30, 默认 24
@property (nonatomic) int framerate;
/// 最大码率
//@property (nonatomic) int maxBitrate;
/// 自定义属性
@property (nonatomic, strong) NSString* __nullable customProperty;
/**
 *  @brief自定义媒体每层参数
 * 1、格式
 * 高基数 第一层高倍数 第一层码率 第二层高倍数 第二层码率 第三层高倍数 第三层码率 第四层高倍数 第四层码率
 * 说明
 * 1）默认宽高比16:9
 * 2）编码宽高最后被裁成16整除
 * 3）码率计算可大致参考文件 《码流甜点区域》
 * 例如 "120 3 750 4 950 6 1200 9 1600"
 * 第一层 分辨率 宽640（120*3/9*16）高 360（120*3）； 码率750kbps
 * 第二层 分辨率 宽848（120*4/9*16）高 480（120*4）； 码率950kbps
 * 第三层 分辨率 宽1280（120*6/9*16）高 720（120*6）； 码率1200kbps
 * 第四层 分辨率 宽1920（120*9/9*16）高 1080（120*9）； 码率1600kbps
 * 2、作用
 * 自定义分层参数和码率
 * 3、其他说明
 * 二层或多层配置参数一致
 * 1）无意义，会增编码损耗。
 * 2）不会节约码率，码率取决于设置订阅层的码率；想减少流量，降低分层分配的码率。
 * 如 "120 3 750 3 750 6 1200 9 1600" 第一层和第二层一样
 * 当第一层和第二层都被订阅，实际第一层和第二层都在编码，没必要；可改成"120 3 750 6 1200 9 1600”，都订阅一层。
 * 以上情况设置成”120 3 750 6 1200 9 1600”会比”120 3 750 3 750 6 1200 9 1600" ，节约上行码率和减少编码损毁。
 */
@property (nonatomic, strong) NSString* __nullable customVideoResolution;
/// 会议画面比例，默认16:9，传入值为宽高比浮点数
@property (nonatomic) float videoRatio;

@end

/**
 *  @brief 属性变化标识类
 */
@interface JCMediaChannelPropChangeParam : NSObject

/**
 *  @brief 上传声音是否变化
 */
@property (nonatomic) bool uploadLocalAudio;

/**
 *  @brief 上传视频是否变化
 */
@property (nonatomic) bool uploadLocalVideo;

/**
 *  @brief 输出声音是否变化
 */
@property (nonatomic) bool audioOutput;

/**
 *  @brief CDN状态是否变化
 */
@property (nonatomic) bool cdnState;

/**
 *  @brief 录制状态是否变化
 */
@property (nonatomic) bool recordState;

/**
 *  @brief 屏幕分享是否变化
 */
@property (nonatomic) bool screenShare;

/**
 *  @brief 标题是否变化
 */
@property (nonatomic) bool title;

@end

/**
 *   @brief 媒体频道模块，类似音视频房间的概念，可以通过频道号加入此频道，从而进行音视频通话
 */
@interface JCMediaChannel : NSObject

/**
 * @brief 频道 Uri
 */
@property (nonatomic, readonly, copy) NSString* __nullable channelUri;

/**
 *  @brief 频道标识
 */
@property (nonatomic, readonly, copy) NSString* __nullable channelId;

/**
 *  @brief 频道号
 */
@property (nonatomic, readonly) int channelNumber;

/**
 *  @brief 会议号
 */
@property (nonatomic, readonly) long confId;

/**
 *  @brief 频道密码
 */
@property (nonatomic, readonly) NSString* __nonnull password;

/**
 *  @brief 返回当前频道中的状态，参见 JCMediaChannelState
 */
@property (nonatomic, readonly) JCMediaChannelState state;

/**
 *  @brief 获得所有通道成员
 */
@property (nonatomic, readonly, strong) NSArray* __nonnull participants;

/**
 *  @brief 是否上传音频数据
 */
@property (nonatomic, readonly) bool uploadLocalAudio;

/**
 *  @brief 是否上传视频数据
 */
@property (nonatomic, readonly) bool uploadLocalVideo;

/**
 *  @brief 是否音频输出
 */
@property (nonatomic, readonly) bool audioOutput;

/**
 *  @brief 屏幕共享渲染标识，没有屏幕共享则为nil
 */
@property (nonatomic, readonly, copy) NSString* __nullable screenRenderId;

/**
 *  @brief 屏幕共享用户标识，没有屏幕共享则为nil
 */
@property (nonatomic, readonly, copy) NSString* __nullable screenUserId;

/**
 *  @brief 频道标题
 */
@property (nonatomic, readonly, copy) NSString* __nullable title;

/**
 *  @brief 视频录制状态
 */
@property (nonatomic, readonly) JCMediaChannelRecordState recordState;

/**
 *  @brief cdn状态
 */
@property (nonatomic, readonly) JCMediaChannelCdnState cdnState;

/**
 *  @brief 自身 JCMediaChannelParticipant 对象
 */
@property (nonatomic, readonly) JCMediaChannelParticipant* __nullable selfParticipant;

/**
 *  @brief 是否通知成员音量变化
 */
@property (nonatomic) bool volumeChangeNotify;

/**
 *  @brief 创建 JCMediaChannel 对象
 *  @param client       JCClient 对象
 *  @param mediaDevice  JCMediaDevice 对象
 *  @param callback     JCMediaChannelCallback 回调接口，用于接收 JCMediaChannel 相关通知
 *  @return             返回 JCMediaChannel 对象
 */
+(JCMediaChannel* __nullable)create:(JCClient* __nonnull)client mediaDevice:(JCMediaDevice* __nonnull)mediaDevice callback:(id<JCMediaChannelCallback> __nonnull)callback;

/**
 *  @brief 销毁接口
 */
+(void)destroy;

/**
 *  @brief              查询媒体频道相关信息，例如是否存在，人数等
 *  @param channelId    媒体通道标识
 *  @return             返回操作id，与 onQuery 回调中的 operationId 对应
 */
-(int)query:(NSString* __nonnull)channelId;

/**
 * 加入频道
 *  @param channelIdOrUri    媒体频道标识或者频道Uri，当 param 中 uriMode 设置为 true 时表示频道 Uri，其他表示频道标识
 *  @param joinParam               加入会议参数，没有则填null
 *  @return               返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)join:(NSString* __nonnull)channelIdOrUri joinParam:(JCMediaChannelJoinParam* __nullable)joinParam;

/**
 *  离开媒体频道，当前只支持同时加入一个媒体通道
 *  @return 返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)leave;

/**
 *  @brief  关闭频道，所有成员都将被退出
 *  @return 返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)stop;

/**
 *  @brief 开启关闭发送本地音频流
 *      1.在频道中将会与服务器进行交互，服务器会更新状态并同步给其他用户
 *      2.未在频道中则标记是否上传音频流，在join时生效
 *      3.建议每次join前设置
 *  @param enable 是否开启本地音频流
 *  @return 返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)enableUploadAudioStream:(bool)enable;

/**
 *  @brief 开启关闭发送本地视频流
 *      1.在频道中将会与服务器进行交互，服务器会更新状态并同步给其他用户
 *      2.未在频道中则标记是否上传音频流，在join时生效
 *      3.建议每次join前设置
 *  @param enable 是否开启本地视频流
 *  @return 返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)enableUploadVideoStream:(bool)enable;

/**
 *  @brief 开启关闭音频输出，可实现静音功能，建议每次join前设置
 *  @param enable 是否开启音频输出
 *  @return 返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)enableAudioOutput:(bool)enable;

/**
 *  @brief 请求频道中其他用户的视频流
 *  @param participant 频道中其他成员对象
 *  @param pictureSize  视频请求尺寸类型
 *  @return 返回 true 表示正常执行调用流程，false 表示调用异常
 *  @see JCMediaChannelPictureSize
 *  @warning 当 pictureSize 为 JCMediaChannelPictureSizeNone 表示关闭请求
 */
-(bool)requestVideo:(JCMediaChannelParticipant* __nonnull)participant pictureSize:(JCMediaChannelPictureSize)pictureSize;

/**
 * @brief 开关屏幕共享
 * @param enable 是否开启屏幕共享
 * @return 返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)enableScreenShare:(bool)enable;

/**
 *  @brief 请求屏幕共享的视频流
 *  @param screenUri 屏幕分享uri
 *  @param pictureSize  视频请求尺寸类型
 *  @return 返回 true 表示正常执行调用流程，false 表示调用异常
 *  @see JCMediaChannelPictureSize
 *  @warning 当 pictureSize 为 JCMediaChannelPictureSizeNone 表示关闭请求
 */
-(bool)requestScreenVideo:(NSString* __nonnull)screenUri pictureSize:(JCMediaChannelPictureSize)pictureSize;

/**
 *  @brief 开关Cdn推流
 *  @param enable 是否开启Cdn推流
 *  @param keyInterval 推流关键帧间隔(毫秒)，当 enable 为 true 时有效，-1表示使用默认值(5000毫秒)，有效值需要>=1000
 *  @return 返回 true 表示正常执行调用流程，false 表示调用异常
 *  @warning 在收到 onMediaChannelPropertyChange 回调后检查是否开启
 */
-(bool)enableCdn:(bool)enable keyInterval:(int)keyInterval;

/**
 *  @brief 开关视频录制
 *  @param enable 是否开启屏幕录制
 *  @param recordParam 录制参数，当 enable 为 true 时，可以更改由 join 时传入的录制参数，不需更改则填 nil
 *  @return 返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)enableRecord:(bool)enable recordParam:(JCMediaChannelRecordParam* __nullable)recordParam;

/**
 *  @brief 获得频道成员
 *  @param userId 用户唯一标识
 *  @return 成员对象
 */
-(JCMediaChannelParticipant* __nullable)getParticipant:(NSString* __nonnull)userId;

/**
 * @brief 获得统计信息，以Json字符串形式返回，其中包含 "Config"， "Network"，"Transport" 和 "Participants" 4个节点
 *
 * @return 统计信息
 */
-(NSString * __nullable)getStatistics;

/**
 * 设置媒体频道中的自定义属性（设置涂鸦拥有者等）
 * 调用此接口来设置频道自定义属性
 * @param property 自定义属性
 * @return 返回 true 表示正常执行调用流程，false 表示调用异常
 */
-(bool)setCustomProperty:(NSString * __nonnull)property;

/**
 * 获取自定义频道属性。
 * 调用此接口来获取自定义频道属性
 *
 * @return 自定义属性
 */
-(NSString * __nullable)getCustomProperty;

/**
 * @brief 发送消息
 *
 * @param type 消息类型
 * @param content 消息内容，当 toUserId 不为 nil 时，content 不能大于 4k
 * @param toUserId 接收者id，null则发给频道所有人员
 * @return 返回 true 表示成功，false表示失败
 */
-(bool)sendMessage:(NSString * __nonnull)type content:(NSString * __nonnull)content toUserId:(NSString * __nullable)toUserId;

/**
 * @brief 邀请Sip用户，一般用于对接落地网关等
 *
 * @param userId 一般为号码
 * @param sipParam sip参数对象
 * @return 成功返回值 >= 0，失败返回 -1
 */
-(int)inviteSipUser:(NSString * __nonnull)userId sipParam:(JCMediaChannelSipParam* __nonnull)sipParam;

/**
 * @brief 发送会议指令
 *
 * 指令名: StartForward   指令作用：请求服务器开始转发音视频
 * 参数格式: {"MtcConfUserUriKey": "用户Uri", "MtcConfMediaOptionKey": "类型"}
 * 用户Uri: 通过调用底层Mtc接口获取 MtcUser.Mtc_UserFormUri(EN_MTC_USER_ID_USERNAME, userId);
 * 类型: 服务器转发分三种 音频、视频、音视频，具体可参考底层mtc_conf.h下的MtcConfMedia的枚举值。
 * 注意: 指令发送成功后会收到 onParticipantUpdate 回调
 * 举例: {"MtcConfUserUriKey": "[username:justin@sample.cloud.justalk.com]", "MtcConfMediaOptionKey": 3}
 *
 * 指令名: StopForward    指令作用：请求服务器停止转发音视频
 * 参数格式: {"MtcConfUserUriKey": "用户URi", "MtcConfMediaOptionKey": "类型"}
 * 用户Uri: 通过调用底层Mtc接口获取 MtcUser.Mtc_UserFormUri(EN_MTC_USER_ID_USERNAME, userId);
 * 类型: 服务器转发分三种 音频、视频、音视频，具体可参考底层mtc_conf.h下的MtcConfMedia的枚举值。
 * 注意: 指令发送成功后会收到 onParticipantUpdate 回调
 * 举例: {"MtcConfUserUriKey": "[username:justin@sample.cloud.justalk.com]", "MtcConfMediaOptionKey": 3}
 *
 * 指令名: ChangeTitle    指令作用：请求修改会议主题
 * 参数格式: {"MtcConfTitleKey":"修改的内容"}
 * 修改的内容: 比如原来主题设置的是"123"，现在改为"321"。
 * 注意1:指令发送成功后会收到 onMediaChannelPropertyChange 回调
 * 注意2:可通过 JCManager.shared.mediaChannel.title 获取主题
 * 举例:{"MtcConfTitleKey": "321"}
 *
 * 指令名: SetPartpProp    指令作用：批量修改成员状态，角色，昵称。
 * 参数格式: {"MtcConfStateKey":要修改的成员状态,"MtcConfDisplayNameKey":"要修改的成员昵称","MtcConfPartpLstKey":["用户Uri",...],"MtcConfRoleKey":7}
 * 要修改的成员状态: 具体可参考底层 mtc_conf.h 下的 MtcConfState 的枚举值
 * 要修改的成员角色: 具体可参考底层 mtc_conf.h 下的 MtcConfRole 的枚举值
 * 要修改的成员昵称: 比如"123"
 * 用户Uri:通过调用底层Mtc接口获取 MtcUser.Mtc_UserFormUri(EN_MTC_USER_ID_USERNAME, userId);
 * 注意1:指令发送成功后会收到 onParticipantUpdate 回调
 * 注意2:MtcConfStateKey、MtcConfDisplayNameKey、MtcConfRoleKey这三个字段，可根据用户想修改哪个值，就在json字符串里面加入哪个。
 * 注意3:MtcConfPartpLstKey 可包含多个用户uri进行批量修改
 * 举例:{"MtcConfStateKey":1,"MtcConfDisplayNameKey":"1314","MtcConfPartpLstKey":["[username:10086@sample.cloud.justalk.com]"],"MtcConfRoleKey":7}
 *
 * 指令名：ReplayApplyMode 指令作用：设置推流布局模式
 * 指令参数格式：{"MtcConfCompositeModeKey": 参数值}
 * 参数值：
 * 1 平铺模式,所有视频均分平铺
 * 2 讲台模式,共享为大图,其他视频为小图
 * 3 演讲模式,共享为大图,共享者视频为小图,其他不显示
 * 4 自定义模式,由ReplayApplyLayout指令设置所有视频布局
 * 5 智能模式。
 * 举例：输入指令参数{"MtcConfCompositeModeKey": 2}就是讲台模式
 *
 * 指令名：ReplayApplyLayout 指令作用：为多用户设置自定义推流布局
 * 指令参数格式：{[{"MtcConfUserUriKey": "用户uri",
 * "MtcConfPictureSizeKey": 视频尺寸,"MtcConfRectangleKey": 图像矩形的具体方位和长宽}]，...}
 * 用户uri：通过调用底层Mtc接口获取 Mtc_UserFormUri((uint)EN_MTC_USER_ID_TYPE.EN_MTC_USER_ID_USERNAME，userId)
 * 视频尺寸：一共5个枚举值，具体枚举值请参考底层 mtc_conf.h 下的 MtcConfPs 枚举
 * 图像矩形的具体方位和长宽：这是一个Json格式的Array对象表示这个图像的位置和大小，第一个值是图像左上角的x坐标(0~1)
 * 第二个值是图像左上角的y坐标(0~1)。第三个值是图像的宽(0~1)。第四个值是图像的高(0~1)。比如[0.5,0.5,0.5,0.5]表示图像在右下角长宽是原始屏幕的一半
 * 举例：
 * [{"MtcConfUserUriKey":"[username:zhang@xxxx.cloud.justalk.com]","MtcConfPictureSizeKey":512,"MtcConfRectangleKey":[0.5,0.5,0.5,0.5]}]
 * 表示成员zhang小尺寸的视频在屏幕右下角位置，长宽是原始屏幕的一半
 *
 * @param name 指令名
 * @param param 指令参数
 * @return 返回 true 表示成功，false 表示失败
 */
-(bool)sendCommand:(NSString * __nonnull)name commandParam:(NSString * __nonnull)param;

/**
 * @brief 设置长宽比
 */
//- (void)setRatio:(float)ratio;


/**
 * @brief 设置自定义角色
 *
 * @param customRole 自定义角色, 参看 JCMediaChannelCustomRole
 * @param participant 成员，nil 则默认设置自己
 */
-(void)setCustomRole:(JCMediaChannelCustomRole)customRole participant:(JCMediaChannelParticipant * __nullable)participant;

/**
 * @brief 获得自定义角色
 *
 * @return 自定义角色
 */
-(JCMediaChannelCustomRole)getCustomRole;

/**
 * @brief 设置自定义状态
 *
 * @param customState 自定义状态, 参看 JCMediaChannelCustomState
 * @param participant 成员，nil 则默认设置自己
 */
-(void)setCustomState:(JCMediaChannelCustomState)customState participant:(JCMediaChannelParticipant * __nullable)participant;

/**
 * @brief 获得自定义状态
 *
 * @return 自定义状态
 */
-(JCMediaChannelCustomState)getCustomState;

/**
 * @brief 将成员踢出会议
 *
 * @param participant 成员
 * @return true表示成功，false表示失败
 */
-(BOOL)kick:(JCMediaChannelParticipant * __nonnull)participant;

/**
 * @brief 发送命令给推流或录制器，只有当推流或录制器成功加入并且为 ready 状态发命令才有效
 *
 * @param command 命令字符串
 * @return 成功返回 true，失败返回 false
 */
-(bool)sendCommandToDelivery:(NSString* __nonnull)command;

/// 设置自身视频宽高比，必须加入成功后设置
/// @param enable 是否开启自身视频宽高比
/// @param ratio 视频宽高比
-(void)enableSelfVideoRatio:(bool)enable ratio:(float)ratio;

/**
 * @brief 启动屏幕分享视频渲染
 * @param type 渲染模式
 * @param pictureSize 视频请求的尺寸类型
 * @return 渲染对象
 */
-(JCMediaDeviceVideoCanvas*)startScreenShareVideo:(JCMediaDeviceRender)type pictureSize:(JCMediaChannelPictureSize)pictureSize;

/**
 * @brief 停止屏幕分享视频渲染
 */
-(void)stopScreenShareVideo;


@end
