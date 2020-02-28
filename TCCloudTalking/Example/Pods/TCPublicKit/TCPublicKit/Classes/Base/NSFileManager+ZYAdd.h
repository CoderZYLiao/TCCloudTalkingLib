//
//  NSFileManager+ZYAdd.h
//  HuoBanTong
//
//  Created by huobantong on 2018/11/14.
//  Copyright © 2018年 huobantong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (ZYAdd)

+ (NSDictionary *)dictionaryByPlistFilePath:(NSString *)path;
+ (NSArray *)arrayByPlistFilePath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
