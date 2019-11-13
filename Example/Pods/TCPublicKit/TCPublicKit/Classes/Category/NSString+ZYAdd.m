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
     * 密码6-20位数字和字母组合
     */
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,16}";
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
    if (mobile.length < 11)
    {
        return false;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(175)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return true;
        }else{
            return false;
        }
        
    }
    return nil;
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



@end
