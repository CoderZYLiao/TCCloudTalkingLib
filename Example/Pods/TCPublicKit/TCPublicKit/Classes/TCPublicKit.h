//
//  TCPublicKit.h
//  TCCloudParking
//
//  Created by Huang ZhiBing on 2019/9/30.
//  Copyright © 2019 LiaoZhiyao. All rights reserved.
//

#ifndef TCPublicKit_h
#define TCPublicKit_h
/* 分类头文件添加start */
#import "UIViewController+ZYAdd.h"
#import "UIImage+ZYAdd.h"
#import "NSDictionary+ZYAdd.h"
#import "UIView+ZYAdd.h"
#import "NSFileManager+ZYAdd.h"
#import "UIColor+ZYAdd.h"
#import "UILabel+ZYAdd.h"
#import "TCConfigDefine.h"
#import "NSDate+ZYAdd.h"
#import "NSString+ZYAdd.h"
/* 分类头文件添加end */

/* 第三方库添加start */
#import "SVProgressHUD.h"
#import "TCHttpTool.h"
/* 第三方库添加end */

#pragma mark - 屏幕适配相关
/** 屏幕bounds */
#define MainScreenCGRect [[UIScreen mainScreen] bounds]
#define kMainScreenHeight  MainScreenCGRect.size.height
#define kMainScreenWidth  MainScreenCGRect.size.width
/** 状态栏高度 (适配iPhone X) */
#define TCStatusH ([[UIApplication sharedApplication] statusBarFrame].size.height>20?44:20)
/** 导航栏高度 (适配iPhone X) */
#define TCNaviH ([[UIApplication sharedApplication] statusBarFrame].size.height>20?88:64)
/** 底部tab高度 (适配iPhone X) */
#define TCBottomTabH ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
/** 宽度比例 */
#define TCFrameRatioWidth ([[UIScreen mainScreen] bounds].size.width != 375.0f ? [[UIScreen mainScreen] bounds].size.width / 375.0f : 1.0)
/** 高度比例 */
#define TCFrameRatioHeight ([[UIScreen mainScreen] bounds].size.height != 667.0f ? [[UIScreen mainScreen] bounds].size.height / 667.0f : 1.0)
/** 判断是否是ipad **/
#define TCIsPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
/** 判断iPhone4系列 **/
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !TCIsPad : NO)
/** 判断iPhone5系列 **/
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !TCIsPad : NO)
/** 判断iPhone6系列 **/
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !TCIsPad : NO)
/** 判断iphone6+系列 **/
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !TCIsPad : NO)
/** 判断iPhoneX **/
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !TCIsPad : NO)
/** 判断iPHoneXr **/
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !TCIsPad : NO)
/** 判断iPhoneXs **/
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !TCIsPad : NO)
/** 判断iPhoneXs Max **/
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !TCIsPad : NO)
/** 判断iPHone11 **/
#define IS_IPHONE_11 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !TCIsPad : NO)
/** 判断iPhone11Pro **/
#define IS_IPHONE_11Pro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !TCIsPad : NO)
/** 判断iPhone11Pro_Max **/
#define IS_IPHONE_11Pro_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !TCIsPad : NO)
/** 判断是否是IPhoneX，iphone11系列 **/
#define IS_IPHONE_X_orMore (IS_IPHONE_X==YES || IS_IPHONE_Xr== YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES)


#pragma mark - 颜色配置相关
//Color
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBONECOLOR(r) [UIColor colorWithRed:(r)/255.0f green:(r)/255.0f blue:(r)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define MainColor @"#4073F2"
#define LineColor @"#DCDFE6"
#define TCPingFangSC_Regular @"PingFangSC-Regular"
#define TCPingFangSC_Light @"PingFangSC-Light"

#pragma mark - 验证相关
/**让字符串变非空*/
#define FULLSTR(str) (str == nil || [str isKindOfClass:[NSNull class]])? @"" : str
/*
 *检查字符串是否为空
 */
#define CheckUnNilStr(str) (str != nil && [str isKindOfClass:[NSString class]])
#define CheckUnNilArray(arr) (arr && [arr isKindOfClass:[NSArray class]])
#define CheckUnNilDictionary(dict) (dict && [dict isKindOfClass:[NSDictionary class]])
///检查接口获取的数据是否正常
#define CheckResult [result xyValueForKey:@"resultCode"] && [[result xyValueForKey:@"resultCode"] isEqualToString:@"0"]
#define TCBlockSafeRun(block, ...) block ? block(__VA_ARGS__) : nil
/**判断请求的结果是否成功*/
#define RequestResult(result) [result[@"resultCode"] isEqualToString:@"0"]



#pragma mark - 云对讲相关
//云对讲组件添加
#define UCS_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([UIDevice currentDevice].systemVersion.floatValue >= v)


#pragma mark - 其他

//获取登录的storyboard
#define LoginStoryBoard [UIStoryboard storyboardWithName:@"LoginNative" bundle:[NSBundle mainBundle]]
#define KeyWindow [UIApplication sharedApplication].keyWindow
//当前设备的系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#endif /* TCPublicKit_h */
