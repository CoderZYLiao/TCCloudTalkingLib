//
//  JCIMCallback.h
//  JCSDKOC
//
//  Created by maikireton on 2017/8/11.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCStorageItem.h"

/**
 *  JCStorage 回调代理
 */
@protocol JCStorageCallback <NSObject>

/**
 *  @brief 文件状态更新通知
 *  @param item 文件消息对象，通过该对象可以获得当前文件传输的属性及状态
 *  @see JCStorageItem
 */
-(void)onFileUpdate:(JCStorageItem*)item;

/**
 *  @brief 文件传输结果通知
 *  @param item 文件消息对象，通过该对象可以获得当前文件传输的属性及状态
 *  @see JCStorageItem
 */
-(void)onFileResult:(JCStorageItem*)item;

@end
