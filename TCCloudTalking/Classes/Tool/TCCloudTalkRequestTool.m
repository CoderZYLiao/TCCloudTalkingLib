//
//  TCCloudTalkRequestTool.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/16.
//

#import "TCCloudTalkRequestTool.h"
#import "Header.h"

@implementation TCCloudTalkRequestTool
//获取我的卡列表
+(void)GetMyCardslistSuccess:(SuccessBlock)successBlock
                       faile:(FailBlock)failBlock{
    
    [[TCHttpTool sharedHttpTool] getWithURL:GetMyCardsURL params:nil success:^(id  _Nonnull json) {
        successBlock(json);
    } failure:^(NSError * _Nonnull error) {
        failBlock(error);
    }];
}

//获取我的小区列表
+(void)GetMyCommunitySuccess:(SuccessBlock)successBlock
                       faile:(FailBlock)failBlock{
    [[TCHttpTool sharedHttpTool] getWithURL:GetMyCardsURL params:nil success:^(id  _Nonnull json) {
        successBlock(json);
    } failure:^(NSError * _Nonnull error) {
        failBlock(error);
    }];
}

//获取我的门口机列表
+(void)GetMyDoorMachinelistWithCoid:(NSString * __nullable)coId
                            Success:(SuccessBlock)successBlock
                              faile:(FailBlock)failBlock
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if(coId){
        [params setObject:coId forKey:@"coId"];
    }
    [[TCHttpTool sharedHttpTool] getWithURL:GetMyDoorURL params:params success:^(id  _Nonnull json) {
        successBlock(json);
    } failure:^(NSError * _Nonnull error) {
        failBlock(error);
    }];
}

//获取获取我的开锁记录
+(void)GetMyCommunityWithPageIndex:(NSString *)pageIndex
                          pageSize:(NSString *)pageSize
                             month:(NSString  *)month
                           Success:(SuccessBlock)successBlock
                             faile:(FailBlock)failBlock
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if(pageIndex){
        [params setObject:pageIndex forKey:@"pageIndex"];
    }
    if(pageSize){
        [params setObject:pageSize forKey:@"pageSize"];
    }
    if(month){
        [params setObject:month forKey:@"month"];
    }
    
    [[TCHttpTool sharedHttpTool] getWithURL:GetMyUnlocklogURL params:params success:^(id  _Nonnull json) {
        successBlock(json);
    } failure:^(NSError * _Nonnull error) {
        failBlock(error);
    }];
}
@end
