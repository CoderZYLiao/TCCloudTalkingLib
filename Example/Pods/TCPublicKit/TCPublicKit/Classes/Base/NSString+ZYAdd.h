//
//  NSString+ZYAdd.h
//  HuoBanTong
//
//  Created by huobantong on 2018/10/23.
//  Copyright © 2018年 huobantong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZYAdd)

/**
 Trim blank characters (space and newline) in head and tail.
 @return the trimmed string.
 */
- (NSString *)stringByTrim;

#pragma mark - 字符串加解码
//对一个字符串进行base解码
+ (NSString *)base64decodeString:(NSString *)string;
#pragma mark - 字典转字符串json
+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dic;
+ (NSString *)jsonStringWithArray:(NSArray *)array;
#pragma mark - 验证
+ (BOOL)valiPassword:(NSString *)password;
+ (BOOL)valiMobile:(NSString *)mobile;
#pragma mark - NSDate
- (NSDate *)stringWithDateFormat:(NSString*)dateFormat;
- (NSDate *)stringWithDateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timezone locale:(NSLocale *)locale;
#pragma mark ---- 将时间戳转换成时间
+ (NSString *)getTimeFromTimestamp:(NSString *)timestamp;
+ (NSString *)getTimeStyle2FromTimestamp:(NSString *)timestamp;
#pragma mark ---- 获取时间戳
+ (NSString *)getNowTimeTimestamp;

#pragma mark ---- 将时间字符串转换成时间再转换成时间字符串
+ (NSString *)getTimeTimestampWithTimeStr:(NSString *)timeStr;
@end

NS_ASSUME_NONNULL_END
