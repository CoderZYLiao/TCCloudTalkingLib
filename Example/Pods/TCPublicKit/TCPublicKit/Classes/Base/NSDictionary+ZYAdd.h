//
//  NSDictionary+ZYAdd.h
//  HuoBanTong
//
//  Created by huobantong on 2018/10/25.
//  Copyright © 2018年 huobantong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ZYAdd)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
