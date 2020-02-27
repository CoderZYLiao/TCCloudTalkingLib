//
//  TCCTApiManager.h
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/17.
//

#import <Foundation/Foundation.h>
#import "TCCTCatEyeHeader.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *https_requestSuccess = @"请求成功";
static NSString *https_requestTimeout = @"请求超时,请重试";

static NSString *https_deviceCtrlSuccess = @"设备控制成功";
static NSString *https_deviceCtrlFailure = @"设备控制失败";
static NSString *https_deviceCtrlTimeout = @"设备控制超时,请重试";

static NSString *jsonResult_Code = @"code";
static NSString *jsonResult_Msg = @"message";
static NSString *jsonResult_Data = @"data";
static NSString *jsonResult_Type = @"type";

typedef void(^successBlock)(id responseObject);
typedef void(^failureBlock)(NSError * error);



@interface TCCTApiManager : NSObject

#pragma mark - 图片抓拍、上传
/// POST 上传抓拍图片
/// @param photImageData 抓拍图片数据
/// @param imageName 图片名称
/// @param success 成功回调
/// @param failure 失败回调
+ (void)uploadPhotoImagesWithPhotoImageData:(NSData *)photImageData andImageName:(NSString *)imageName success:(successBlock)success failure:(failureBlock)failure;

#pragma mark - 猫眼基本操作
/// POST 添加猫眼
/// @param deviceName 设备名称
/// @param deviceNum 设备机身号
/// @param deviceCode 设备硬件码
/// @param devicePwd 设备密码
/// @param success <#success description#>
/// @param failure <#failure description#>
+ (void)addCatEyeWithDeviceName:(NSString *)deviceName andDeviceNum:(NSString *)deviceNum andDeviceCode:(NSString *)deviceCode andDevicePwd:(NSString *)devicePwd success:(successBlock)success failure:(failureBlock)failure;

/// GET 获取猫眼列表
/// @param success <#success description#>
/// @param failure <#failure description#>
+ (void)getCatEyeListWithSuccess:(successBlock)success failure:(failureBlock)failure;

/// GET 获取指定猫眼
/// @param catEyeID <#success description#>
/// @param success <#success description#>
/// @param failure <#failure description#>
+ (void)getCatEyeListWithCatEyeID:(NSString *)catEyeID Success:(successBlock)success failure:(failureBlock)failure;

/// PUT   编辑猫眼
/// @param catEyeID <#deviceNum description#>
/// @param deviceName <#deviceName description#>
/// @param devicePwd <#devicePwd description#>
/// @param success <#success description#>
/// @param failure <#failure description#>
+ (void)editCatEyeWithCatEyeID:(NSString *)catEyeID andDeviceName:(NSString *)deviceName andDevicePwd:(NSString *)devicePwd success:(successBlock)success failure:(failureBlock)failure;


/// DELETE 删除猫眼
/// @param deviceID 猫眼ID
/// @param success <#success description#>
/// @param failure <#failure description#>
+ (void)deleteCatEyeWithDeviceID:(NSString *)deviceID success:(successBlock)success failure:(failureBlock)failure;

#pragma mark - 猫眼人脸操作
/// POST 设置或编辑人脸
/// @param deviceNum 猫眼机身号
/// @param type 新增、编辑
/// @param faceID 人脸ID
/// @param faceImage 人脸图片url地址
/// @param nickName 人脸昵称
/// @param success <#success description#>
/// @param failure <#failure description#>
+ (void)addAndEditFaceWithDeviceNum:(NSString *)deviceNum andType:(CatEyeFaceType)type andFaceID:(NSString *)faceID andFaceImage:(NSString *)faceImage andNickName:(NSString *)nickName success:(successBlock)success failure:(failureBlock)failure;

/// GET 获取人脸列表
/// @param deviceNum 猫眼机身号
/// @param success <#success description#>
/// @param failure <#failure description#>
+ (void)getFaceListWithDeviceNum:(NSString *)deviceNum success:(successBlock)success failure:(failureBlock)failure;

/// DELETE 删除人脸
/// @param deviceNum 猫眼机身号
/// @param faceID 人脸ID
/// @param success <#success description#>
/// @param failure <#failure description#>
+ (void)deleteFaceWithDeviceNum:(NSString *)deviceNum andFaceID:(NSString *)faceID success:(successBlock)success failure:(failureBlock)failure;


#pragma mark - 猫眼其他操作
/// GET 唤醒猫眼
/// @param deviceNum <#deviceNum description#>
/// @param success <#success description#>
/// @param failure <#failure description#>
+ (void)awakenCatEyeWithDeviceNum:(NSString *)deviceNum success:(successBlock)success failure:(failureBlock)failure;

/// GET 睡眠猫眼
/// @param deviceNum <#deviceNum description#>
/// @param success <#success description#>
/// @param failure <#failure description#>
+ (void)dormantCatEyeWithDeviceNum:(NSString *)deviceNum success:(successBlock)success failure:(failureBlock)failure;

/// POST 控制抓拍/录像
/// @param deviceNum <#deviceNum description#>
/// @param cameraType 抓拍类型,0:抓拍一张,1:录像10秒
/// @param success <#success description#>
/// @param failure <#failure description#>
+ (void)cameraCatEyeWithDeviceNum:(NSString *)deviceNum andCameraType:(CatEyeCameraType)cameraType success:(successBlock)success failure:(failureBlock)failure;

/// @param recordType 文件记录类型
/// @param deviceNum <#deviceNum description#>
/// @param pageNum <#pageNum description#>
/// @param pageSize <#pageSize description#>
/// @param success <#success description#>
/// @param failure <#failure description#>
+ (void)getRecordListWithType:(CatEyeRecordType)recordType andDeviceNum:(NSString *)deviceNum andPageNum:(NSInteger)pageNum andPageSize:(NSInteger)pageSize success:(successBlock)success failure:(failureBlock)failure;

/// DELETE 删除信息记录
/// @param recordID 记录ID
/// @param success <#success description#>
/// @param failure <#failure description#>
+ (void)deleteRecordWothID:(NSString *)recordID success:(successBlock)success failure:(failureBlock)failure;

@end

NS_ASSUME_NONNULL_END
