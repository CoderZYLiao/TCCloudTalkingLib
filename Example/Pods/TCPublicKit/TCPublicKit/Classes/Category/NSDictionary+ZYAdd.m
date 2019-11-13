//
//  NSDictionary+ZYAdd.m
//  HuoBanTong
//
//  Created by huobantong on 2018/10/25.
//  Copyright © 2018年 huobantong. All rights reserved.
//

#import "NSDictionary+ZYAdd.h"

@implementation NSDictionary (ZYAdd)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
