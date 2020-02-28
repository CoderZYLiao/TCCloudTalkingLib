//
//  TCCTCatEyeAccountManager.m
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/24.
//

#import "TCCTCatEyeAccountManager.h"

@implementation TCCTCatEyeAccountManager

//储存当前用户的猫眼列表
+ (void)tcSaveCatEyeListDataDict:(NSDictionary *)dataDict{
    //第一步.设置json文件的保存路径
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/CatEyeListJson.json"];
    //第二步.封包数据
    NSData *json_data = [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
    //第三步.写入数据
    [json_data writeToFile:filePath atomically:YES];
}

//根据猫眼对讲账号查询设备机身码
+ (NSString *)tcSelectDeviceCodeByCatEyeAccount:(NSString *)account{
    //读取本地json数据
    NSString *str = [[NSString alloc] init];
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/CatEyeListJson.json"];//获取json文件保存的路径
    NSData *data = [NSData dataWithContentsOfFile:filePath];//获取指定路径的data文件
    if (data) {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]; //获取到json文件的跟数据（字典）
        NSArray *arr = [json objectForKey:@"data"];//获取指定key值的value，是一个数组
        
        for (NSDictionary *dic in arr) {
            if ([[dic objectForKey:@"account"] isEqualToString:account]) {
                str = [dic objectForKey:@"account"];
            }
        }
    }
    return str;
}

//根据猫眼对讲账号查询猫眼名称
+ (NSString *)tcSelectCatEyeNameByCatEyeAccount:(NSString *)account{
    //读取本地json数据
    NSString *str = [[NSString alloc] init];
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/CatEyeListJson.json"];//获取json文件保存的路径
    NSData *data = [NSData dataWithContentsOfFile:filePath];//获取指定路径的data文件
    if (data) {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]; //获取到json文件的跟数据（字典）
        NSArray *arr = [json objectForKey:@"data"];//获取指定key值的value，是一个数组
        
        for (NSDictionary *dic in arr) {
            if ([[dic objectForKey:@"account"] isEqualToString:account]) {
                str =   [dic objectForKey:@"account"];
            }
        }
    }
    return str;
}

//根据猫眼对讲账号查询猫眼对象
+ (NSDictionary *)tcSelectCatEyeModelByCatEyeAccount:(NSString *)account{
    //读取本地json数据
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/CatEyeListJson.json"];//获取json文件保存的路径
    NSData *data = [NSData dataWithContentsOfFile:filePath];//获取指定路径的data文件
    if (data) {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]; //获取到json文件的跟数据（字典）
        NSArray *arr = [json objectForKey:@"data"];//获取指定key值的value，是一个数组
        
        for (NSDictionary *dic in arr) {
            if ([[dic objectForKey:@"account"] isEqualToString:account]) {
                return dic;
            }
        }
    }
    
    return nil;
}


@end
