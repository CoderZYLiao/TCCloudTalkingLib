//
//  NSFileManager+ZYAdd.m
//  HuoBanTong
//
//  Created by huobantong on 2018/11/14.
//  Copyright © 2018年 huobantong. All rights reserved.
//

#import "NSFileManager+ZYAdd.h"

@implementation NSFileManager (ZYAdd)

+ (NSDictionary *)dictionaryByPlistFilePath:(NSString *)path{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *fullPath = [bundle pathForResource:path ofType:@"plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fullPath isDirectory:NULL]) {
        return nil;
    }
    return [NSDictionary dictionaryWithContentsOfFile:fullPath];
}

+ (NSArray *)arrayByPlistFilePath:(NSString *)path{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *fullPath = [bundle pathForResource:path ofType:@"plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fullPath isDirectory:NULL]) {
        return nil;
    }
    return [NSArray arrayWithContentsOfFile:fullPath];
}

@end
