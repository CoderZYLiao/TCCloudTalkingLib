//
//  JCStorage.h
//  JCSDKOC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCStorageItem.h"
#import "JCStorageCallback.h"

extern const int JCStorageFileExpire;

/**
 *  文件存储类
 *
 *  上传文件：将文件上传至服务器，上传成功后服务器会返回文件地址，地址一般会有一定的有效期
 *
 *  下载文件：通过上传文件服务器返回的地址来下载该文件
 */
@interface JCStorage : NSObject

/**
 *  @brief 创建 JCStorage 对象
 *  @param client JCClient 对象
 *  @param callback JCStorageCallback 回调接口，用于接收 JCStorage 相关通知
 *  @return 返回 JCStorage 对象
 */
+(JCStorage*)create:(JCClient*)client callback:(id<JCStorageCallback>)callback;

/**
 *  @brief 销毁接口
 */
+(void)destroy;

/**
 *  @brief 上传文件
 *  @param path 文件路径
 *  @param cookie 标志数据
 *  @param expiredSeconds 过期秒数，-1表示永久
 *  @return 返回 JCStorageItem 对象
 */
-(JCStorageItem*)uploadFileByExpireTime:(NSString*)path expiredSeconds:(int)expiredSeconds cookie:(id)cookie;

/**
 *  @brief 下载文件
 *  @param uri 文件地址
 *  @param savePath 本地文件保存地址
 *  @param cookie 标志数据
 *  @return 返回 JCStorageItem 对象，异常返回 nil
 */
-(JCStorageItem*)downloadFile:(NSString*)uri savePath:(NSString*)savePath cookie:(id)cookie;

/**
 *  @brief 取消正在进行的文件上传下载
 *  @param item JCStorageItem对象，由 uploadFile，downloadFile 返回
 *  @return 成功返回 true，失败返回 false
 */
-(bool)cancelFile:(JCStorageItem*)item;

/**
 *  @brief 通过cookie取消正在进行的文件上传下载
 *  @param cookie 上传下载传入的 cookie
 *  @return 成功返回 true，失败返回 false
 */
-(bool)cancelFileByCookie:(id)cookie;

@end
