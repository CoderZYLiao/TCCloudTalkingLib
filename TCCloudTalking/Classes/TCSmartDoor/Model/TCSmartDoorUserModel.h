//
//  TCSmartDoorUserModel.h
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCSmartDoorUserModel : NSObject
//住户ID
@property (nonatomic, strong) NSString *ID;
//姓名
@property (nonatomic, strong) NSString *name;
//手机号
@property (nonatomic, strong) NSString *mobile;
//账号
@property (nonatomic, strong) NSString *account;
//登录密码
@property (nonatomic, strong) NSString *password;
//地址
@property (nonatomic, strong) NSString *address;
//性别
@property (nonatomic, strong) NSString *gender;
//邮箱
@property (nonatomic, strong) NSString *mail;
//qq号
@property (nonatomic, strong) NSString *qq;
//头像路径
@property (nonatomic, strong) NSString *headImage;
//身份证号
@property (nonatomic, strong) NSString *identityNo;
//生日
@property (nonatomic, strong) NSString *birthDay;
//昵称
@property (nonatomic, strong) NSString *nickName;
//对讲ID
@property (nonatomic, strong) NSString *intercomUserId;
//对讲token
@property (nonatomic, strong) NSString *intercomToken;
//证件类型
@property (nonatomic, strong) NSString *identityType;
//指纹编码(与第一个小社关联的时候生成顺序id),最大支持 65536
@property (nonatomic, strong) NSString *fingerCode;
//RKE 住户指纹base64，这个需要设备来读取
@property (nonatomic, strong) NSString *fingerPrint;
//RKE 呼叫电话,固话请加上区号，如 07568665566
@property (nonatomic, strong) NSString *callPhone;
//人脸信息
@property (nonatomic, strong) NSString *faceImg;
//创建者信息
@property (nonatomic, strong) NSString *creator;
//最近修改时间
@property (nonatomic, strong) NSString *lastModifyTime;
//创建时间
@property (nonatomic, strong) NSString *createTime;
@end

NS_ASSUME_NONNULL_END
