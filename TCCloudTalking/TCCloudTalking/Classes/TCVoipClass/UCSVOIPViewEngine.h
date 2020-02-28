//
//  UCSVOIPViewEngine.h

//
//  Created by  on 15/12/11.
//  Copyright © 2015年 Barry. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UCSFuncEngine.h"

#define GetViewWidth(view) view.frame.size.width

#define GetViewHeight(view) view.frame.size.height

#define GetViewX(view) view.frame.origin.x

#define GetViewY(view) view.frame.origin.y

#define CurrentBounds [UIScreen mainScreen].bounds

#define CurrentWidth [UIScreen mainScreen].bounds.size.width

#define CurrentHeight [UIScreen mainScreen].bounds.size.height

#define DevicesScale ([UIScreen mainScreen].bounds.size.height==480?1.00:[UIScreen mainScreen].bounds.size.height==568?1.00:[UIScreen mainScreen].bounds.size.height==667?1.17:1.29)

#define Adaptation(n) (n)*DevicesScale

#define CenterPoint(x,y) ((x)-(y))/2.0 //居中


#define RGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define GetRGBColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//ps(px*2)字体转化成pt字体
#define PSToPtFont(ps) (ps)*3/4
#define GetTextFont(n) CurrentHeight==480?(n):(CurrentHeight==568?(n):(CurrentHeight==667?(n+2):(n+4)))



#define UCSNotiLocalNotification @"NotiLocalNotification"









typedef enum{
    UCS_CallType_Answer, //通话类型，接听
    UCS_CallType_Cancel, //通话类型，取消
    UCS_CallType_Disanswer,//通话类型，未接听
    UCS_CallType_reject   //通话类型，被叫拒绝接听
}UCSCallAction;


typedef enum{
    UCS_voipCall, // WLS，2015-12-11，（语音通话主叫）
    UCS_incomingVoipCall, // WLS，2015-12-11，（语音通话被叫）
    UCS_videoCall, // WLS，2015-12-11，（视频通话主叫）
    UCS_incomingVideoCall // WLS，2015-12-11，（视频通话被叫）
}UCSCallType;

@interface UCSVOIPViewEngine : NSObject<UCSEngineUIDelegate>

@property (assign,nonatomic)BOOL isCalling; //WLS，2016-01-15，是否处于通话中


+(UCSVOIPViewEngine *)getInstance;





/**
 @author WLS, 15-12-11 18:12:11
 
 发起通话
 
 @param callNumber 被叫userid或者被叫的手机号
 @param callType   发起通话类型
 */
- (void)makingCallViewCallNumber:(NSString *)callNumber callType:(UCSCallTypeEnum)callType callName:(NSString *)callName;
- (void)makingCatEyeCallViewCallNumber:(NSString *)callNumber callType:(UCSCallTypeEnum)callType callName:(NSString *)callName;

/**
 @author WLS, 16-07-11 18:12:11
 
 发起智能通话
 
 @param callNumber 被叫userid或者被叫的手机号
 @param callType   发起通话类型
 */
- (void)makingCallViewSmartCallNumber:(NSString *)callNumber callType:(int)callType callName:(NSString *)callName;


/**
 视频或者音频同振
 */
- (void)makingGroupDialViewWithNumbers:(NSArray<NSString *>*)callNumbers callType:(UCSCallTypeEnum)callType;


//移除通话界面 add by WLS 20151116
- (void)releaseViewControler:(UIViewController *)releaseVC;





/**
 @author WLS, 15-12-14 17:12:15
 
 设置自定义编解码
 */
- (void)setVideoDecAndVideoEnc;




/**
 @author WLS, 16-01-11 18:01:51
 
 写入文件
 
 @param str 需要写入文件的字符串
 */
- (void)WriteToSandBox:(NSString *)str;

+ (BOOL)isHeadphone;


/**
 @author kcuky  17-10-18 14:32
 
 
 @param str 以本地通知方式弹出数据用于调试pushkit
 */
- (void)debugReleaseShowLocalNotification:(NSString *)str;

- (void)showincomingCallViewController;

- (void)showincomingVideoViewController;
@end
