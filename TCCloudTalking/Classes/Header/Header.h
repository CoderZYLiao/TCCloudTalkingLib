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
#import "UCSChangeTheViewController.h"
#import "UCSTCPSDK.h"
#import "UCSTCPDelegateBase.h"
#import "UCConst.h"
#import "InfoManager.h"
#import "TCCUserDefaulfManager.h"
#import "Masonry.h"
#import "TCCloudTalkingImageTool.h"
#import "MJExtension.h"
#import <MJRefresh/MJRefresh.h>
#import <YYKit/YYKit.h>
//公共库头文件
//#import "TCPublicKit.h"
//#import "UIImage+ZYAdd.h"

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

//当前设备的系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define UCS_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([UIDevice currentDevice].systemVersion.floatValue >= v)
#ifdef DEBUG
#define DDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@" %s ,%d",__FUNCTION__,__LINE__);
#define debugReleaseMark() NSLog(@"Release %s ,%d",__FUNCTION__,__LINE__);

#else
#define DDLog(fmt, ...)
#define debugLog(...)
#define debugMethod()
#define debugReleaseMark()
#endif
