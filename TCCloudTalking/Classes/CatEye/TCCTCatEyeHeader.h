//
//  TCCTCatEyeHeader.h
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/17.
//

#ifndef TCCTCatEyeHeader_h
#define TCCTCatEyeHeader_h

#import "UIImage+HLS.h"
#import "Header.h"
#import <SDWebImage.h>

#pragma mark - Enum
//猫眼设备操作类型：添加、编辑
typedef NS_ENUM(NSInteger, CatEyeDeviceOperate) {
    CatEyeDeviceOperate_Add = 0,
    CatEyeDeviceOperate_Edit = 1
};

//猫眼抓拍、录像
typedef  NS_ENUM(NSInteger, CatEyeCameraType){
    CatEyeCameraType_Photograph = 0,
    CatEyeCameraType_Video = 1
};

//猫眼人脸新增、编辑
typedef  NS_ENUM(NSInteger, CatEyeFaceType){
    CatEyeFaceType_Add = 0,
    CatEyeFaceType_Edit = 1
};
//信息记录类型：0文件记录,1通话记录,2报警记录.3人脸识别记录 ps:-1不传则为所有
typedef  NS_ENUM(NSInteger, CatEyeRecordType){
    CatEyeRecordType_All = -1,
    CatEyeRecordType_File = 0,
    CatEyeRecordType_Call = 1,
    CatEyeRecordType_Police = 2,
    CatEyeRecordType_Face = 3
};

//人脸识别添加成员照片页面push类型
typedef NS_ENUM(NSInteger,AddFacePushType){
    AddFacePushType_Add = 1,    //1-初次添加成员拍摄
    AddFacePushType_Edit = 2    //2-修改成员信息拍摄
};

//猫眼设备状态
typedef NS_ENUM(NSInteger, CatEyeDeviceStatus) {
    CatEyeDeviceStatus_OFFLINE,    //离线
    CatEyeDeviceStatus_SLEEP,      //休眠
    CatEyeDeviceStatus_ONLINE      //在线
};

#pragma mark - SMLog输出
#ifdef DEBUG
# define TCCTLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define TCCTLog(...);
#endif

#pragma mark - Color、Font...
#define Color_bgColor               @"#F5F6FB"
#define Color_globalColor           @"#4073F2"

#define Font_Title_System20         [UIFont boldSystemFontOfSize:20]
#define Font_Title_System18         [UIFont systemFontOfSize:18]
#define Font_Title_System17         [UIFont systemFontOfSize:17]
#define Font_Text_System14          [UIFont systemFontOfSize:14]
#define Font_Text_System13          [UIFont systemFontOfSize:13]
#define Font_assist_System12        [UIFont systemFontOfSize:12]
#define Font_Number_System10        [UIFont systemFontOfSize:10]

#define Fillet_CornerRadius         6.0
#define SplitLine_Height            0.5

#pragma mark - 屏幕适配相关
/** 屏幕bounds */
#define TCCMainScreenCGRect [[UIScreen mainScreen] bounds]
#define TCCMainScreenHeight  TCCMainScreenCGRect.size.height
#define TCCMainScreenWidth  TCCMainScreenCGRect.size.width
/** 状态栏高度 (适配iPhone X) */
#define TCCStatusH ([[UIApplication sharedApplication] statusBarFrame].size.height>20?44:20)
/** 导航栏高度 (适配iPhone X) */
#define TCCNaviH ([[UIApplication sharedApplication] statusBarFrame].size.height>20?88:64)
/** 底部tab高度 (适配iPhone X) */
#define TCCBottomTabH ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
/** 宽度比例 */
#define TCCFrameRatioWidth (TCCMainScreenWidth != 375.0f ? TCCMainScreenWidth / 375.0f : 1.0)
/** 高度比例 */
#define TCCFrameRatioHeight (TCCMainScreenHeight != 667.0f ? TCCMainScreenHeight / 667.0f : 1.0)

#define TccHeight(num)  (num * TCCFrameRatioHeight)
#define TccWidth(num)  (num * TCCFrameRatioWidth)

#define KTimeOut        @(10)
#define KPageSize       @(10)

#pragma mark - 猫眼请求
//新增猫眼
#define GetMyDoorURL [NSString stringWithFormat:@"%@/smarthome/api/catEye",KProjectAPIBaseURL]

#pragma mark - 通知
//刷新猫眼列表
#define Noti_RefreshCatEyeList          @"RefreshCatEyeList"
//刷新历史信息记录列表
#define Noti_RefreshRecordList          @"RefreshRecordList"
//刷新人脸成员列表
#define Noti_RefreshFaceList            @"RefreshFaceList"

#endif /* TCCTCatEyeHeader_h */
