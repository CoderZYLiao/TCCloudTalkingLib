//
//  JCNetCallback.h
//  JCSDKOC
//
//  Created by maikireton on 2017/8/24.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCNetConstants.h"

@protocol JCNetCallback <NSObject>

/**
 *  @brief 网络变化
 *  @param newNetType 当前网络类型
 *  @param oldNetType 之前网络类型
 *  @see JCNetJudgeType JCNetType
 */
-(void)onNetChange:(JCNetType)newNetType oldNetType:(JCNetType)oldNetType;

@end
