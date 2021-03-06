//
//  Header.h
//  TCCommunityAssociation
//
//  Created by Huang ZhiBin on 2017/7/4.
//  Copyright © 2017年 Zhuhai Taichuan Cloud Technology. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import "UCConst.h"
#import "TCCPubEnum.h"
#import "UCSCommonClass.h"
#import "UCSVOIPViewEngine.h"
#import "NSString+UCLog.h"
#import "UCSFuncEngine.h"
#import "UCSTCPSDK.h"
#import "UCSTCPDelegateBase.h"
#import "UCConst.h"

//菊风SDK头文件
#import <JCSDKOC/JCSDKOC.h>
#import "JCManager.h"

#import "CloudTalkingManager.h"

// Notification for UI Action
#define NOTIFICATION_ANSWERCALL_UI          @"Notification_AnswerCall_UI"
#define NOTIFICATION_ANSWERCALL             @"Notification_AnswerCall"
#define NOTIFICATION_ENDCALL                @"Notification_EndCall"

#define USE720P   @"use720p"   //720p
#define USEHardCode  @"useHardCode"   //硬编硬解
#define UCS_StartBitrate @"UCS_StartBitrate"
#define UCS_uMaxBitrate  @"UCS_uMaxBitrate"
#define UCS_uMinBitrate   @"UCS_uMinBitrate"
#define UCS_PreViewStatu @"UCS_PreViewStatu"
#endif /* Header_h */


//测试数据
//token
#define UserTccToken @"UserTccToken"
//userID
#define UserTccUserID @"UserTccUserID"
/*
 *检查字符串是否为空
 */
#define CheckUnNilStr(str) (str != nil && [str isKindOfClass:[NSString class]])
#define CheckUnNilArray(arr) (arr && [arr isKindOfClass:[NSArray class]])
#define CheckUnNilDictionary(dict) (dict && [dict isKindOfClass:[NSDictionary class]])

#define ShowErrorNoti(string) [SVProgressHUD showErrorWithStatus:string];
#define ShowNoti(string) [SVProgressHUD showInfoWithStatus:string];
#define ShowSucessNoti(string) [SVProgressHUD showSuccessWithStatus:string];

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
//Color
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBONECOLOR(r) [UIColor colorWithRed:(r)/255.0f green:(r)/255.0f blue:(r)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//主颜色
#define NavBarColor [UIColor colorWithRed:64/255.0 green:115/255.0 blue:242/255.0 alpha:1.0]

//当前设备的系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define UCS_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([UIDevice currentDevice].systemVersion.floatValue >= v)

#define StandardUserDefault [NSUserDefaults standardUserDefaults]
