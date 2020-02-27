//
//  TCCTCatEyeModel.h
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCCTCatEyeModel : NSObject

@property (nonatomic,copy)NSString *account;            //对讲账号
@property (nonatomic,copy)NSString *deviceCode;         //硬件码
@property (nonatomic,copy)NSString *deviceName;         //设备名称
@property (nonatomic,copy)NSString *deviceNum;          //机身号
@property (nonatomic,copy)NSString *devicePwd;          //设备密码
@property (nonatomic,copy)NSString *id;                 //猫眼ID
@property (nonatomic,copy)NSString *online;             //猫眼在线状态
@property (nonatomic,copy)NSString *ownFlag;            //是否所属标识
@property (nonatomic,copy)NSString *roomId;             //所属房间ID
@property (nonatomic,copy)NSString *token;              //对讲账号Token

@property (nonatomic,assign)NSInteger devType;          //设备类型  默认为3000
@property (nonatomic,assign)NSInteger electric;         //设备电量
@property (nonatomic,copy) NSString *uid;               //

@end

NS_ASSUME_NONNULL_END
