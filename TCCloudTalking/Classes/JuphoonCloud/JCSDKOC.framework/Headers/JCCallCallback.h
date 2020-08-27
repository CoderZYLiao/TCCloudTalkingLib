//
//  JCCallCallback.h
//  JCSDK-OC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCCallItem.h"

/**
 *  JCCall 回调代理
 */
@protocol JCCallCallback <NSObject>

/**
 *  @brief 新增通话回调
 *  @param item JCCallItem 对象
 */
-(void)onCallItemAdd:(JCCallItem* __nonnull)item;

/**
 *  @brief 移除通话
 *  @param item JCCallItem 对象
 *  @param reason 通话结束原因
 *  @param description 通话结束原因的描述，只有被动挂断的时候，才会收到这个值，其他情况下则返回空字符串
 *  @see JCCallReason
 */
-(void)onCallItemRemove:(JCCallItem* __nonnull)item reason:(JCCallReason)reason description:(NSString * __nullable)description;

/**
 *  @brief 通话状态更新回调（当上层收到此回调时，可以根据 JCCallItem 对象获得该通话的所有信息及状态，从而更新该通话相关UI）
 *  @param item JCCallItem 对象
 *  @param changeParam 更新标识类
 */
-(void)onCallItemUpdate:(JCCallItem* __nonnull)item changeParam:(JCCallChangeParam * __nullable)changeParam;

/**
 *  @brief 通话中收到消息的回调
 *  @param item JCCallItem 对象
 *  @param type 消息类型
 *  @param content 消息内容
 */
-(void)onMessageReceive:(JCCallItem * __nonnull)item type:(NSString * __nonnull)type content:(NSString * __nonnull)content;

/**
 * @brief上报服务器拉取的未接来电
 * @param item JCCallItem 对象
 */
-(void)onMissedCallItem:(JCCallItem * __nonnull)item;


/// 通话中收到DTMF回调
/// @param item JCCallItem 对象
/// @param value DTMF值
- (void)onDtmfReceived:(JCCallItem *_Nonnull)item value:(JCCallDtmf)value;

/**
 *  @brief 呼叫结果回调
 *  @param result true 表示呼叫成功，false 表示呼叫失败
 *  @param reason 当 result 为 false 时该值有效，参见 JCCallReason
 *  @param item 结果关联的 JCCallItem 对象
 */
//-(void)onCall:(bool)result reason:(JCCallReason)reason item:(JCCallItem*)item;

/**
 *  @brief 呼叫保持结果回调
 *  @param result true 表示呼叫保持成功，false 表示呼叫保持失败
 *  @param reason 当 result 为 false 时该值有效，参见 JCCallReason
 *  @param item 结果关联的 JCCallItem 对象
 */
//-(void)onHold:(bool)result reason:(JCCallReason)reason item:(JCCallItem*)item;

/**
 *  @brief 切换通话音视频结果回调
 *  @param result true 表示呼叫成功，false 表示呼叫失败
 *  @param reason 当 result 为 false 时该值有效，参见 JCCallReason
 *  @param item 结果关联的 JCCallItem 对象
 */
//-(void)onSwitchMedia:(bool)result reason:(JCCallReason)reason item:(JCCallItem*)item;

@end
