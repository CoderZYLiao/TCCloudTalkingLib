//
//  NSDate+ZYAdd.m
//  TCCloudParking
//
//  Created by Huang ZhiBing on 2019/8/22.
//  Copyright © 2019 LiaoZhiyao. All rights reserved.
//

#import "NSDate+ZYAdd.h"
#import "NSString+ZYAdd.h"

@implementation NSDate (ZYAdd)

- (NSString *)dateToLocalStringWithDateFormate:(NSString *)dateForamt
{
    return [self dateToStringWithDateFormate:dateForamt timeZone:[NSTimeZone localTimeZone] locale:[NSLocale systemLocale]];
}

- (NSString*)dateToStringWithDateFormate:(NSString*)dateForamt
{
    return [self dateToStringWithDateFormate:dateForamt timeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"] locale:[NSLocale systemLocale]];
}

- (NSString *)dateToStringWithDateFormate:(NSString*)dateForamt timeZone:(NSTimeZone *)timezone locale:(NSLocale *)locale
{
    NSString *str = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timezone];
    [formatter setLocale:locale];
    [formatter setDateFormat:dateForamt];
    str = [formatter stringFromDate:self];
#if ! __has_feature(objc_arc)
    [formatter release];
#endif
    return str;
}

- (NSDate *)dateWithDateFromate:(NSString *)dateFormate timeZone:(NSTimeZone *)timezone locale:(NSLocale *)locale
{
    NSString *dateStr = [self dateToStringWithDateFormate:dateFormate timeZone:timezone locale:locale];
    return [dateStr stringWithDateFormat:dateFormate timeZone:timezone locale:locale];
}

- (NSDate *)dateWithDateFromate:(NSString *)dateFormate
{
    NSString *dateStr = [self dateToStringWithDateFormate:dateFormate];
    return [dateStr stringWithDateFormat:dateFormate];
}

@end
