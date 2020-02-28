//
//  TCCTCatEyeAccountManager.h
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCCTCatEyeAccountManager : NSObject

//储存当前用户的猫眼列表
+ (void)tcSaveCatEyeListDataDict:(NSDictionary *)dataDict;

//根据猫眼对讲账号查询设备机身码
+ (NSString *)tcSelectDeviceCodeByCatEyeAccount:(NSString *)account;

//根据猫眼对讲账号查询猫眼名称
+ (NSString *)tcSelectCatEyeNameByCatEyeAccount:(NSString *)account;

//根据猫眼对讲账号查询猫眼对象
+ (NSDictionary *)tcSelectCatEyeModelByCatEyeAccount:(NSString *)account;


@end

NS_ASSUME_NONNULL_END
