//
//  TCConfigDefine.h
//  项目配置
//
//  Created by Huang ZhiBing on 2019/9/30.
//  Copyright © 2019 LiaoZhiyao. All rights reserved.
//

#ifndef TCConfigDefine_h
#define TCConfigDefine_h
/*
 APP登录相关
 */
#define TCAccessToken @"access_token"
#define TCUsername @"username"
#define TCPassword @"password"
#define TCUserId @"userId"
/*
 Web基链接
 */
//#define KProjectWebBaseURL @"http://o2o.v5.taichuan.net"  // 测试
#define KProjectWebBaseURL @"http://o2o.ucloud.taichuan.net"  // 正式
/*
 Api基链接
 */
//#define KProjectO2OAPIBaseURL @"http://o2o.v5.taichuan.net/o2o/" // 正式
#define KProjectO2OAPIBaseURL @"http://o2o.ucloud.taichuan.net/o2o/"   // 测试
/*
 Api基链接
 */
//#define KProjectAPIBaseURL @"https://v5.taichuan.net"  // 测试
#define KProjectAPIBaseURL @"https://ucloud.taichuan.net"    // 正式

/*
 获取token
 */
#define GetTokenURL [NSString stringWithFormat:@"%@/connect/token", KProjectAPIBaseURL]

/*
 地图AppID,当前项目集成百度地图
 */
#define MapAppID @"FMAmRDt2mYGy3qT9iN7HztsRb9dEleGj"

//极光测试 com.ulife.zhihuiUlife     19adfdd05d8db4635daa6e8b
//总部极光 com.myulife.nanjing      ba0971b8181ac1c5d3967f01
//南京极光 com.myulife.nanjing      e9fba78f0bfed0167fe059b7
/*
 第三方推送Appkey,目前为极光推送
 */
#define ThirdPushAppKey @"19adfdd05d8db4635daa6e8b"     //

/*
 微信支付分享
 */
#define WXAppID @"wxd0f55d37d871324b"
#define WXAppSecret @"d4624c36b6795d1d99dcf0547af5443d"

/*
 支付宝支付
 */
#define ZFBPartner  @"2088021653385023"
#define ZFBSeller  @"2088021653385023"
#define ZFBScheme  @"UHomeAliPay"

//weakSelf && strongSelf;
#define WEAKSELF __typeof(self) __weak weakSelf = self;
#define STRONGSELF __typeof(weakSelf) __strong strongSelf = weakSelf;

/*
 ----------debug模式下使用--------
 */
#ifdef DEBUG
#define DDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define debugLog( s, ... ) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String] )
#define debugMethod() NSLog(@" %s ,%d",__FUNCTION__,__LINE__);
#define debugReleaseMark() NSLog(@"Release %s ,%d",__FUNCTION__,__LINE__);

#else
#define DDLog(...)
#define debugLog(...)
#define debugMethod()
#define debugReleaseMark()
#endif

#pragma mark - 通知
// 强制登录通知
#define ForceToLoginNotification @"ForceToLoginNotification"

#endif /* TCConfigDefine_h */
