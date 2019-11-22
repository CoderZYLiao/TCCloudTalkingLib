//
//  TCPersonalInfoModel.m
//  TCMember
//
//  Created by Huang ZhiBing on 2019/11/6.
//

#import "TCPersonalInfoModel.h"
#import "TCUserModel.h"
#import <MJExtension.h>
#import "MemberBaseHeader.h"
#import "TCPublicKit.h"

@implementation TCPersonalInfoModel

+ (instancetype)shareInstance
{
    static TCPersonalInfoModel *single;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[TCPersonalInfoModel alloc] init];
    });
    return single;
}

- (TCUserModel *)getUserModel
{
    NSString *dataJsonString = [[NSUserDefaults standardUserDefaults] objectForKey:TCMemberInfoKey];
    NSDictionary *memberInfoDict = [NSDictionary dictionaryWithJsonString:dataJsonString];
    return [TCUserModel mj_objectWithKeyValues:memberInfoDict];
}

- (void)updateUserModelName:(NSString *)name
{
    NSString *dataJsonString = [[NSUserDefaults standardUserDefaults] objectForKey:TCMemberInfoKey];
    NSMutableArray *memberInfoDict = [NSDictionary dictionaryWithJsonString:dataJsonString];
    [memberInfoDict setValue:name forKey:@"name"];
    NSData *dataData = [NSJSONSerialization dataWithJSONObject:memberInfoDict options:NSJSONWritingPrettyPrinted error:nil];
    dataJsonString = [[NSString alloc] initWithData:dataData encoding:NSUTF8StringEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:dataJsonString forKey:TCMemberInfoKey];    // 保存用户信息
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalInfoNotification" object:nil];
}

- (void)updateUserModelAvatar:(NSString *)avatar
{
    NSString *dataJsonString = [[NSUserDefaults standardUserDefaults] objectForKey:TCMemberInfoKey];
    NSMutableArray *memberInfoDict = [NSDictionary dictionaryWithJsonString:dataJsonString];
    [memberInfoDict setValue:avatar forKey:@"avatar"];
    NSData *dataData = [NSJSONSerialization dataWithJSONObject:memberInfoDict options:NSJSONWritingPrettyPrinted error:nil];
    dataJsonString = [[NSString alloc] initWithData:dataData encoding:NSUTF8StringEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:dataJsonString forKey:TCMemberInfoKey];    // 保存用户信息
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalInfoNotification" object:nil];
}

- (void)updateUserModelGender:(TCGender)gender
{
    NSString *dataJsonString = [[NSUserDefaults standardUserDefaults] objectForKey:TCMemberInfoKey];
    NSMutableArray *memberInfoDict = [NSDictionary dictionaryWithJsonString:dataJsonString];
    [memberInfoDict setValue:[NSNumber numberWithInteger:gender] forKey:@"gender"];
    NSData *dataData = [NSJSONSerialization dataWithJSONObject:memberInfoDict options:NSJSONWritingPrettyPrinted error:nil];
    dataJsonString = [[NSString alloc] initWithData:dataData encoding:NSUTF8StringEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:dataJsonString forKey:TCMemberInfoKey];    // 保存用户信息
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalInfoNotification" object:nil];
}

- (void)logout
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:TCMemberInfoKey];
}


@end
