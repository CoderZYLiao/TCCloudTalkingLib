//
//  NSDate+ZYAdd.h
//  TCCloudParking
//
//  Created by Huang ZhiBing on 2019/8/22.
//  Copyright © 2019 LiaoZhiyao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ZYAdd)
- (NSString *)dateToLocalStringWithDateFormate:(NSString *)dateForamt;
- (NSString*)dateToStringWithDateFormate:(NSString*)dateForamt;
- (NSString *)dateToStringWithDateFormate:(NSString*)dateForamt timeZone:(NSTimeZone *)timezone locale:(NSLocale *)locale;
- (NSDate *)dateWithDateFromate:(NSString *)dateFormate;
- (NSDate *)dateWithDateFromate:(NSString *)dateFormate timeZone:(NSTimeZone *)timezone locale:(NSLocale *)locale;
@end

NS_ASSUME_NONNULL_END
