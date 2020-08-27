//
//  JCIMMessage.h
//  JCSDKOC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCStorageConstants.h"

/**
 *  文件消息对象类
 */
@interface JCStorageItem : NSObject

/**
 *  @brief 文件唯一标识符
 */
@property (nonatomic, readonly, copy) NSString* fileId;
           
/**
 *  @brief 文件链接，上传文件可获得
 */
@property (nonatomic, readonly, copy) NSString* uri;

/**
 *  @brief 文件本地路径，发送时表明发送文件路径，接收时表明文件下载保存路径
 */
@property (nonatomic, readonly, copy) NSString* path;

/**
 *  @brief 上传还是下载，参见 JCStorageDirection
 */
@property (nonatomic, readonly) JCStorageItemDirection direction;

/**
 *  @brief 传输状态，参见 JCStorageState
 */
@property (nonatomic, readonly) JCStorageItemState state;

/**
 *  @brief 错误码，当文件状态未 JCStorageStateFail 时有效，参见 JCStorageReason
 */
@property (nonatomic, readonly) JCStorageReason error;

/**
 *  @brief 文件传输进度
 */
@property (nonatomic, readonly) int progress;

/**
 *  @brief 文件大小
 */
@property (nonatomic, readonly) int fileSize;

/**
 *  @brief cookie
 */
@property (nonatomic, strong) id cookie;

/**
 *  @brief operationId
 */
@property (nonatomic) unsigned int operationId;

@end
