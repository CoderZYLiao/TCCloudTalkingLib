//
//  UCSVOIPViewEngine.m
//
//  Created by  on 15/12/11.
//  Copyright © 2015年 Barry. All rights reserved.
//
#import "UCSVOIPViewEngine.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

NSString* const isRepeatCallStatus = @"isRepeatCallStatus";

@interface UCSVOIPViewEngine()
{
    NSMutableDictionary *muDic;
    int callTypes;                  //保存通话记录类型
}
@property (assign,nonatomic)UIWindow *window;


@property (assign,nonatomic)UCSCallType callType; // WLS，2015-12-11，（通话类型，主叫还是被叫。）
@property (strong,nonatomic)UIViewController * releaseView;
@property (strong,nonatomic)NSTimer *repeatTimer;
@property (strong,nonatomic)NSTimer *repeatCountTimer;
@end

@implementation UCSVOIPViewEngine

UCSVOIPViewEngine * ucsVoipViewEngine = nil;

+(UCSVOIPViewEngine *)getInstance
{
    @synchronized(self){
        if(ucsVoipViewEngine == nil){
            ucsVoipViewEngine = [[self alloc] init];
        }
    }
    return ucsVoipViewEngine;
}


- (id)init
{
    if (self = [super init]){
        self.window =[[UIApplication sharedApplication].delegate window];
        _isCalling = NO;
    }
    return self;
}

- (void)dealloc
{
    self.window = nil;
}

- (void)makingGroupDialViewWithNumbers:(NSArray<NSString *> *)callNumbers callType:(UCSCallTypeEnum)callType{
    
    //标识正在通话
    self.isCalling = YES;
    
    [[UCSVOIPViewEngine getInstance] WriteToSandBox:[NSString stringWithFormat:@"发起同振呼叫：%@",[callNumbers componentsJoinedByString:@","]]];
    
    
    
    if (callType == UCSCallType_VOIP ) {
        
        self.callType = UCS_voipCall;
        
//        TCDoorVoipCallController * voipCallVC = [[TCDoorVoipCallController alloc] initWithCallerNo:@"" andVoipNo:@"" andCallType:callType];
//        voipCallVC.incomingCall = NO;
//        voipCallVC.callType = callType;
//        voipCallVC.isGroupDail = YES;
//        self.callViewController = voipCallVC;
//        [self pushToTheViewController:voipCallVC];
//
        //设置支持IPV6
        [[UCSFuncEngine getInstance] setIpv6:YES];
        [[UCSFuncEngine getInstance] groupDial:callType numbers:callNumbers andUserData:@"语音同振"];
    }else if (callType == UCSCallType_VideoPhone){
        self.callType = UCS_videoCall;
//        TCDoorVideoCallController * videoCallVC = [[TCDoorVideoCallController alloc] initWithCallerName:@"" andVoipNo:@""];
//        videoCallVC.incomingCall = NO;
//        videoCallVC.isGroupDail = YES;
//        self.videoViewController = videoCallVC;
//        [self pushToTheViewController:videoCallVC];
        
        [[UCSFuncEngine getInstance] groupDial:callType numbers:callNumbers andUserData:@"视频同振"];
    }
}

//为免费通话、单向外呼准备
- (void)makingCallViewCallNumber:(NSString *)callNumber callType:(UCSCallTypeEnum)callType callName:(NSString *)callName{
    //标识正在通话
    self.isCalling = YES;
    NSString * nickName = callName;
    //显示名称寻找
    
    NSString * callKitName = nil;//[TCCetUserHouseMachine getMachineNameWithVoipNo:callNumber];
    if (callKitName) {
        nickName = [callKitName copy];
    }
    if (nickName == nil) {
        nickName = callNumber;
    }
    [[UCSVOIPViewEngine getInstance] WriteToSandBox:[NSString stringWithFormat:@"发起通话：%@---%@---%@",callNumber,callName,nickName]];
    if (callType == UCSCallType_VOIP || callType == 1) {
        NSString * userId = @"";
        NSString * phoneNumber = @"";
        if (callType == 1) {
            //单向外呼（直拨）
            phoneNumber = callNumber;
        }else{
            //免费通话
            userId = callNumber;
        }
        self.callType = UCS_voipCall;
//        TCDoorVoipCallController * voipCallVC = [[TCDoorVoipCallController alloc] initWithCallerNo:phoneNumber andVoipNo:userId andCallType:callType];
//        voipCallVC.incomingCall = NO;
//        voipCallVC.callID = callNumber;
//        voipCallVC.callerName = nickName;
//        voipCallVC.callType = callType;
//        self.callViewController = voipCallVC;
//        [self pushToTheViewController:voipCallVC];
        //设置支持IPV6
        //        [[UCSFuncEngine getInstance] setIpv6:YES];
        [[UCSFuncEngine getInstance] dial:callType andCallId:callNumber andUserdata:@"语音通话"];
    }else if (callType == UCSCallType_VideoPhone){
        self.callType = UCS_videoCall;
//        TCDoorVideoCallController * videoCallVC = [[TCDoorVideoCallController alloc] initWithCallerName:nickName andVoipNo:callNumber];
//        videoCallVC.incomingCall = NO;
//        videoCallVC.callID = callNumber;
//        self.videoViewController = videoCallVC;
//        [self pushToTheViewController:videoCallVC];
        [[UCSFuncEngine getInstance] dial:callType andCallId:callNumber andUserdata:@"视频通话"];
    }
}

//为智能呼叫准备
- (void)makingCallViewSmartCallNumber:(NSString *)callNumber callType:(int)callType callName:(NSString *)callName{
    self.isCalling = YES;

    NSString * callUserid = callNumber;
    if ([callUserid hasPrefix:@"+86"]) {
        NSRange range = [callUserid rangeOfString:@"+86"];
        callUserid = [callUserid substringFromIndex:range.length];
    }
    
    
    
    NSString * nickName = callName;
    
    
    [[UCSVOIPViewEngine getInstance] WriteToSandBox:[NSString stringWithFormat:@"发起通话：%@---%@---%@",callUserid,callName,nickName]];
    
    if (callType == 4) {
        
        NSString * userId = @"";
        NSString * phoneNumber = @"";
        if (callType == 4) {
            /**
             @author kcuky, 16-7-21 18:12:55
             
             智能呼叫
             */
            phoneNumber = callUserid;
        }
        
        
        self.callType = UCS_voipCall;
        
//        TCDoorVoipCallController * voipCallVC = [[TCDoorVoipCallController alloc] initWithCallerNo:phoneNumber andVoipNo:userId andCallType:callType];
//        voipCallVC.incomingCall = NO;
//        voipCallVC.callID = callUserid;
//        voipCallVC.callerName = nickName;
//        voipCallVC.callType = callType;
//        self.callViewController = voipCallVC;
//        [self pushToTheViewController:voipCallVC];
        
        [[UCSFuncEngine getInstance] dial:callType andCallId:callUserid andUserdata:@"智能呼叫"];
    }
}

/**
 *  判断开不开震动
 */
- (BOOL)needShake:(NSString *) fromChatter{
    BOOL ret = YES;
    return ret;
}

#pragma  mark - 通话代理

- (void)showNetWorkState:(NSString *)networkStateStr{
   
}

//来电信息
-(void)incomingCallID:(NSString*)callid caller:(NSString*)caller phone:(NSString*)phone name:(NSString*)name callStatus:(int)status callType:(NSInteger)calltype{
    
}

//通话状态回调
-(void)responseVoipManagerStatus:(UCSCallStatus)event callID:(NSString*)callid data:(UCSReason *)data withVideoflag:(int)videoflag{
    
}

/**
 @author WLS, 15-12-15 17:12:47
 
 获取设置的ip地址，如果没有设置，则默认imactivity.ucpaas.com
 */
- (NSString *)getIP
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * asAddress = [defaults stringForKey:@"asAddress"];
    NSString * asPort = [defaults stringForKey:@"asPort"];
    if (asAddress.length == 0) {
        asAddress = @"imactivity.ucpaas.com";
    }
    NSString * address;
    if (asPort.length != 0) {
        address = [NSString stringWithFormat:@"%@:%@",asAddress,asPort];
    }else{
        address = asAddress;
    }
    return address;
}

#pragma mark - 文件写入

- (NSString *)getNowTime
{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

- (void)WriteToSandBox:(NSString *)str
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath=[documentsDirectory stringByAppendingPathComponent:@"UCSVoipLog.txt"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        //如果文件存在并且它的大小大于1M，则删除并且重新创建一个
        long long filesizes  = [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
        if ((filesizes/(1024.0*1024.0))>1) {
            
            //删除当前文件
            [fileManager removeItemAtPath:filePath error:nil];
            //重新创建一个文件
            [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        }
        
        NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
        //找到并定位到outFile的末尾位置(在此后追加文件)
        [outFile seekToEndOfFile];
        
        [outFile writeData:[[NSString stringWithFormat:@"\n\n==========%@=========\n%@",[self getNowTime],str] dataUsingEncoding:NSUTF8StringEncoding]];
        //关闭读写文件
        [outFile closeFile];
    }else{
        // 如果文件不存在 则创建并且将文件写入
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
}

+ (BOOL)isHeadphone
{
    UInt32 propertySize = sizeof(CFStringRef);
    CFStringRef state = nil;
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute
                            ,&propertySize,&state);
    //return @"Headphone" or @"Speaker" and so on.
    //根据状态判断是否为耳机状态
    if ([(__bridge NSString *)state isEqualToString:@"Headphone"] ||[(__bridge NSString *)state isEqualToString:@"HeadsetInOut"])
    {
        return YES;
    }else {
        return NO;
    }
}

- (UIViewController *)xs_getCurrentViewController{
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    //获取根控制器
    UIViewController* currentViewController = window.rootViewController;
    //获取当前页面控制器
    BOOL runLoopFind = YES;
    while (runLoopFind){
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]){
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                currentViewController = currentViewController.childViewControllers.lastObject;
                return currentViewController;
            } else {
                return currentViewController;
            }
        }
    }
    return currentViewController;
}

@end
