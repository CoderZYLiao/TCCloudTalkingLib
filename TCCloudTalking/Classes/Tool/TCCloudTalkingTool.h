//
//  TCCloudTalkingTool.h
//  AFNetworking
//
//  Created by Mumu on 2019/11/21.
//

#import <Foundation/Foundation.h>

@interface TCCloudTalkingTool : NSObject

+(instancetype)share;

//存入userdefault
@property (nonatomic,strong)NSString * phoneNumber;


//时间戳变为格式时间
+ (NSString *)ConvertStrToTime:(NSString *)timeStr;

/**
 保存用户的门口机列表
 
 */
+ (void)saveUserMachineList;

/**
 保存用户的门口机列表

 @param jsonstr json数据
 */
+ (void)saveUserMachineList:(id )jsonstr;


/**
 获取门口机数组

 @return 数组
 */
+(NSArray *)getMachineDataArray;
/**
 根据VOIP获取门口机的机身号
 
 @param VoipNo VOIP
 @return 门口机昵称
 */
+ (NSString *)getMachineNumberWithVoipNo:(NSString *)VoipNo;


/**
 根据VOIP获取门口机的昵称

 @param VoipNo VOIP
 @return 门口机昵称
 */
+ (NSString *)getMachineNameWithVoipNo:(NSString *)VoipNo;
@end
