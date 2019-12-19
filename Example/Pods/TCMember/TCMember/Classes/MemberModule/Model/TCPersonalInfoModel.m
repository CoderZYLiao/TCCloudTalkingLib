//
//  TCPersonalInfoModel.m
//  TCMember
//
//  Created by Huang ZhiBing on 2019/11/6.
//

#import "TCPersonalInfoModel.h"
#import "TCUserModel.h"
#import <MJExtension/MJExtension.h>
#import "MemberBaseHeader.h"
#import <TCPublicKit/TCPublicKit.h>
#import "TCHousesInfoModel.h"

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
// 获取对讲信息
- (TCHousesInfoModel *)getHousesInfoModel
{
    NSString *dataJsonString = [[NSUserDefaults standardUserDefaults] objectForKey:TCHousesInfoKey];
    NSDictionary *memberInfoDict = [NSDictionary dictionaryWithJsonString:dataJsonString];
    return [TCHousesInfoModel mj_objectWithKeyValues:memberInfoDict];
}

- (void)updateUserModelName:(NSString *)name
{
    NSString *dataJsonString = [[NSUserDefaults standardUserDefaults] objectForKey:TCMemberInfoKey];
    NSDictionary *memberInfoDict = [NSDictionary dictionaryWithJsonString:dataJsonString];
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
    NSDictionary *memberInfoDict = [NSDictionary dictionaryWithJsonString:dataJsonString];
    [memberInfoDict setValue:avatar forKey:@"avatar"];
    NSData *dataData = [NSJSONSerialization dataWithJSONObject:memberInfoDict options:NSJSONWritingPrettyPrinted error:nil];
    dataJsonString = [[NSString alloc] initWithData:dataData encoding:NSUTF8StringEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:dataJsonString forKey:TCMemberInfoKey];    // 保存用户信息
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalInfoNotification" object:nil];
}

- (void)updateUserModelGender:(NSInteger)gender
{
    NSString *dataJsonString = [[NSUserDefaults standardUserDefaults] objectForKey:TCMemberInfoKey];
    NSDictionary *memberInfoDict = [NSDictionary dictionaryWithJsonString:dataJsonString];
    [memberInfoDict setValue:[NSNumber numberWithInteger:gender] forKey:@"gender"];
    NSData *dataData = [NSJSONSerialization dataWithJSONObject:memberInfoDict options:NSJSONWritingPrettyPrinted error:nil];
    dataJsonString = [[NSString alloc] initWithData:dataData encoding:NSUTF8StringEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:dataJsonString forKey:TCMemberInfoKey];    // 保存用户信息
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalInfoNotification" object:nil];
}

- (void)logout
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:TCUsername];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:TCPassword];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:TCMemberInfoKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLogoutNotification" object:nil];
    // 清除之前的HTML缓存
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearHTMLStorageNotification" object:nil];
}


// 更新用户信息
- (void)UpdateUserModel
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:TCUsername];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:TCPassword];
    if (userName && password) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"uhome.ios" forKey:@"client_id"];
        [params setObject:@"123456" forKey:@"client_secret"];
        [params setObject:@"password" forKey:@"grant_type"];
        [params setObject:@"openid profile uhome uhome.rke uhome.o2o uhome.park" forKey:@"scope"];
        [params setObject:userName forKey:@"username"];
        [params setObject:password forKey:@"password"];
        
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
        [mgr.requestSerializer setTimeoutInterval:10];
        [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        WEAKSELF
        [[TCHttpTool sharedHttpTool] postWithURL:LoginURL params:params withManager:mgr success:^(id _Nonnull json) {
            NSString *access_token = [json objectForKey:@"access_token"];
            [[TCHttpTool sharedHttpTool] updateMgrRequestAccessToken:access_token];
            [weakSelf UpdateUserInfoRequest];
        } failure:^(NSError * _Nonnull error) {
            [self logout];
            NSLog(@"更新Token失败");
        }];
    }
}

// 更新用户信息接口
- (void)UpdateUserInfoRequest
{
    [[TCHttpTool sharedHttpTool] getWithURL:UserInfoURL params:nil success:^(id  _Nonnull json) {
        NSInteger code = [[json objectForKey:@"code"] integerValue];
        if (code == 0) {
            NSDictionary *dict = [json objectForKey:@"data"];
            NSData *dataData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *dataJsonString = [[NSString alloc] initWithData:dataData encoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults] setObject:dataJsonString forKey:TCMemberInfoKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalInfoNotification" object:nil];
        } else {
            [MBManager showBriefAlert:[json objectForKey:@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [self logout];
        NSLog(@"更新用户信息失败");
    }];
}
@end
