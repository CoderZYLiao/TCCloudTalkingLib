//
//  NSString+ZYAdd.m
//  HuoBanTong
//
//  Created by huobantong on 2018/10/23.
//  Copyright © 2018年 huobantong. All rights reserved.
//

#import "NSString+ZYAdd.h"

@implementation NSString (ZYAdd)

- (NSString *)stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

//对一个字符串进行base解码
+ (NSString *)base64decodeString:(NSString *)string
{
    NSInteger count = 4 - string.length % 4;
    if (count !=4) {
        for (int i = 0; i < count; i++) {
            string = [string stringByAppendingString:@"="];
        }
    }
    NSString *replacedStr = [[string stringByReplacingOccurrencesOfString:@"-"withString:@"+"] stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:replacedStr options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding: NSUTF8StringEncoding];
    return decodedString;
}

#pragma mark - 字典转字符串json

+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dic
{
    NSArray *keys = [dic allKeys];
    NSString *result = @"{";
    NSMutableArray *values = [NSMutableArray array];
    for (int i = 0; i < [keys count];  i++) {
        NSString *key = [keys objectAtIndex:i];
        id ob = [dic  objectForKey:key];
        NSString *value = [self jsonStringWithObject:ob];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"\"%@\":%@",key,value]];
        }
        
    }
    result = [result stringByAppendingFormat:@"%@",[values componentsJoinedByString:@","]];
    result = [result stringByAppendingFormat:@"}"];
    return result;
}

+ (NSString *)jsonStringWithString:(NSString *)str
{
    return [NSString stringWithFormat:@"\"%@\"",[[str stringByReplacingOccurrencesOfString:@"\n"withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]];
    
}

+ (NSString *)jsonStringWithArray:(NSArray *)array
{
    NSMutableArray *values = [NSMutableArray array];
    NSString *result = @"[";
    for (id ob in array) {
        NSString *value = [self jsonStringWithObject:ob];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    result = [result stringByAppendingFormat:@"%@",[values componentsJoinedByString:@","]];
    result = [result stringByAppendingFormat:@"]"];
    return result;
}

+ (NSString *)jsonStringWithObject:(id)object
{
    if (!object) {
        return nil;
    }
    if ([object isKindOfClass:[NSString class]]) {
        return [self jsonStringWithString:object];
    }else if([object isKindOfClass:[NSArray class]]){
        return [self jsonStringWithArray:object];
    }else if ([object isKindOfClass:[NSDictionary class]]){
        return [self jsonStringWithDictionary:object];
    }else{
        return object;
    }
}

#pragma mark - 验证
// 验证密码
+ (BOOL)valiPassword:(NSString *)password {
    /**
     * 密码8-20位数字和字母组合
     */
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    if (isMatch) {
        return true;
    }else{
        return false;
    }
}

// 验证手机号
+ (BOOL)valiMobile:(NSString *)mobile {
    /**
     * 正则表达式
     */
    NSString *CM_NUM = @"^1((((3[0-3,5-9])|(4[5,7,9])|(5[0-3,5-9])|(66)|(7[1-3,5-8])|(8[0-9])|(9[1,8,9]))[0-9]{8})|((34)[0-8]\d{7}))$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
    
    if (isMatch1) {
        return true;
    }else{
        return false;
    }
}

#pragma mark - NSDate

- (NSDate *)stringWithDateFormat:(NSString*)dateFormat
{
    return [self stringWithDateFormat:dateFormat timeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"] locale:[NSLocale systemLocale]];
}

- (NSDate *)stringWithDateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timezone locale:(NSLocale *)locale
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timezone];
    [formatter setLocale:locale];
    [formatter setDateFormat:dateFormat];
    NSDate *date = [formatter dateFromString:self];
    return date;
}

#pragma mark ---- 将时间戳转换成时间

+ (NSString *)getTimeFromTimestamp:(NSString *)timestamp
{
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

+ (NSString *)getTimeStyle2FromTimestamp:(NSString *)timestamp
{
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

// 以微秒为单位
+ (NSString *)getNowTimeTimestamp
{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([datenow timeIntervalSince1970]*1000)];
    return timeSp;
}

@end
