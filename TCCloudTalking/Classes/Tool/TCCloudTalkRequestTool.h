//
//  TCCloudTalkRequestTool.h
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^SuccessBlock)(id result);
typedef void (^FailBlock)(NSError * error);

@interface TCCloudTalkRequestTool : NSObject

//***********当前tool为智能门禁的所有请求***********//
//*****************2019.11.16******************//
//**********************TYL********************//
//*********************************************//

/**
 获取我的卡列表
 
 @param successBlock 成功
 @param failBlock 失败
 */
+(void)GetMyCardslistSuccess:(SuccessBlock)successBlock
                       faile:(FailBlock)failBlock;

/**
 获取我的小区列表
 
 @param successBlock 成功
 @param failBlock 失败
 */
+(void)GetMyCommunitySuccess:(SuccessBlock)successBlock
                       faile:(FailBlock)failBlock;

/**
 获取我的门口机列表
 
 @param Coid 小区ID
 @param successBlock 成功
 @param failBlock 失败
 */
+(void)GetMyDoorMachinelistWithCoid:(NSString * __nullable)Coid
                            Success:(SuccessBlock)successBlock
                              faile:(FailBlock)failBlock;



/**
 获取获取我的开锁记录
 
 @param pageIndex 页面索引，0开始 最多10页
 @param pageSize 页面大小
 @param month 查询哪个月的数据（2019-08)
 @param successBlock 成功
 @param failBlock 失败
 */
+(void)GetMyCommunityWithPageIndex:(NSString *)pageIndex
                          pageSize:(NSString *)pageSize
                             month:(NSString  *)month
                           Success:(SuccessBlock)successBlock
                             faile:(FailBlock)failBlock;

@end

NS_ASSUME_NONNULL_END
