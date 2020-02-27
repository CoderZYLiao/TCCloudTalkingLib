//
//  UCSVOIPViewEngine.m
//
//  Created by  on 15/12/11.
//  Copyright © 2015年 Barry. All rights reserved.
//

#import "UCSVOIPViewEngine.h"
#import "TCDoorVoipCallController.h"
#import "TCDoorVideoCallController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "TCCVibrationer.h"
#import "TCVoipDBManager.h"
#import "TCVoipCallListModel.h"
#import "TCCallRecordsModel.h"
#import "TCVoipDBManager.h"
#import "TCCAVPlayer.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "PushNotificationManager.h"
#import "UCSChangeTheViewController.h"
#import "FMDBBaseTool.h"
NSString* const isRepeatCallStatus = @"isRepeatCallStatus";

#import "TCCTCatEyeCall.h"
#import "TCCTCatEyeMonitorVC.h"

#import "NSString+UCLog.h"

@interface UCSVOIPViewEngine()
{
    
    NSMutableDictionary *muDic;
    
    int callTypes;  //保存通话记录类型
}
@property (assign,nonatomic)UIWindow * window;


@property (strong,nonatomic)TCDoorVoipCallController *callViewController; // WLS，2015-12-11，（语音通话主叫界面）
@property (strong,nonatomic)TCDoorVoipCallController *incomingCallViewController; // WLS，2015-12-11，（语音通话被叫界面）

@property (strong,nonatomic)TCDoorVideoCallController *videoViewController; // WLS，2015-12-11，（视频主叫界面）
@property (strong,nonatomic)TCDoorVideoCallController *incomingVideoViewController; // WLS，2015-12-11，（视频被叫界面）


@property (assign,nonatomic)UCSCallType callType; // WLS，2015-12-11，（通话类型，主叫还是被叫。）
@property (strong,nonatomic)UIViewController * releaseView;
@property (strong,nonatomic)NSTimer *repeatTimer;
@property (strong,nonatomic)NSTimer *repeatCountTimer;

@property (nonatomic, strong) TCCAVPlayer * player;

@property (nonatomic, assign) NSInteger deviceType;   //设备类型： 1-猫眼 2-门口机
//@property (nonatomic, strong) UIViewController *callVC; //猫眼被叫页面
@property (nonatomic, strong) TCCTCatEyeCall *callVC; //猫眼被叫页面
@end

@implementation UCSVOIPViewEngine



- (TCCAVPlayer *)player{
    if (_player == nil) {
        NSURL * url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"incomingCall" ofType:@"mp3"]];
        _player = [[TCCAVPlayer alloc] initWithContentsOfURL:url];
    }
    return _player;
}

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
        //        [UCSFuncEngine getInstance].UIDelegate = self;
        _isCalling = NO;
        _deviceType = 2;
    }
    
    return self;
}

- (void)dealloc
{
    self.window = nil;
}



- (void)makingGroupDialViewWithNumbers:(NSArray<NSString *> *)callNumbers callType:(UCSCallTypeEnum)callType{
    
    if (self.callViewController || self.incomingCallViewController || self.videoViewController || self.incomingVideoViewController || self.callVC) {
        // 如果界面存在,说明连续拨打了两次同一个号码，这里就不做重复拨打操作。
        [[UCSVOIPViewEngine getInstance] WriteToSandBox:@"已有界面，不能发起同振呼叫"];
        return;
    }
    
    
    
    //标识正在通话
    self.isCalling = YES;
    
    [[UCSVOIPViewEngine getInstance] WriteToSandBox:[NSString stringWithFormat:@"发起同振呼叫：%@",[callNumbers componentsJoinedByString:@","]]];
    
    
    
    if (callType == UCSCallType_VOIP ) {
        
        self.callType = UCS_voipCall;
        
        TCDoorVoipCallController * voipCallVC = [[TCDoorVoipCallController alloc] initWithCallerNo:@"" andVoipNo:@"" andCallType:callType];
        voipCallVC.incomingCall = NO;
        voipCallVC.callType = callType;
        voipCallVC.isGroupDail = YES;
        self.callViewController = voipCallVC;
        [self pushToTheViewController:voipCallVC];
        
        //设置支持IPV6
        [[UCSFuncEngine getInstance] setIpv6:YES];
        [[UCSFuncEngine getInstance] groupDial:callType numbers:callNumbers andUserData:@"语音同振"];
        
    }else if (callType == UCSCallType_VideoPhone){
        
        self.callType = UCS_videoCall;
        
        TCDoorVideoCallController * videoCallVC = [[TCDoorVideoCallController alloc] initWithCallerName:@"" andVoipNo:@""];
        videoCallVC.incomingCall = NO;
        videoCallVC.isGroupDail = YES;
        self.videoViewController = videoCallVC;
        [self pushToTheViewController:videoCallVC];
        
        [[UCSFuncEngine getInstance] groupDial:callType numbers:callNumbers andUserData:@"视频同振"];
        
    }
    
    
}


//为免费通话、单向外呼准备
- (void)makingCallViewCallNumber:(NSString *)callNumber callType:(UCSCallTypeEnum)callType callName:(NSString *)callName{
    
    if ([[callNumber substringToIndex:3] isEqualToString:@"Cat"]) {     //离线猫眼被呼叫后 反呼叫猫眼
        _deviceType = 1;
        TCCTCatEyeCall *VC = [[TCCTCatEyeCall alloc] init];
        //TODO确定透传设备ID
        VC.callID = callNumber;
        self.callVC = VC;
        [self pushToTheViewController:VC];
        
        self.callType = UCS_videoCall;
        [[UCSFuncEngine getInstance] dial:callType andCallId:callNumber andUserdata:@"视频通话"];
    }else{
        _deviceType = 2;
        if (self.callViewController || self.incomingCallViewController || self.videoViewController || self.incomingVideoViewController || self.callVC) {
            // 如果界面存在,说明连续拨打了两次同一个号码，这里就不做重复拨打操作。
            [[UCSVOIPViewEngine getInstance] WriteToSandBox:@"已有界面，不能发起通话"];
            return;
        }
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
            TCDoorVoipCallController * voipCallVC = [[TCDoorVoipCallController alloc] initWithCallerNo:phoneNumber andVoipNo:userId andCallType:callType];
            voipCallVC.incomingCall = NO;
            voipCallVC.callID = callNumber;
            voipCallVC.callerName = nickName;
            voipCallVC.callType = callType;
            self.callViewController = voipCallVC;
            [self pushToTheViewController:voipCallVC];
            //设置支持IPV6
            //        [[UCSFuncEngine getInstance] setIpv6:YES];
            [[UCSFuncEngine getInstance] dial:callType andCallId:callNumber andUserdata:@"语音通话"];
        }else if (callType == UCSCallType_VideoPhone){
            self.callType = UCS_videoCall;
            TCDoorVideoCallController * videoCallVC = [[TCDoorVideoCallController alloc] initWithCallerName:nickName andVoipNo:callNumber];
            videoCallVC.incomingCall = NO;
            videoCallVC.callID = callNumber;
            self.videoViewController = videoCallVC;
            [self pushToTheViewController:videoCallVC];
            [[UCSFuncEngine getInstance] dial:callType andCallId:callNumber andUserdata:@"视频通话"];
        }
    }
    
}


- (void)makingCatEyeCallViewCallNumber:(NSString *)callNumber callType:(UCSCallTypeEnum)callType callName:(NSString *)callName{
    _deviceType = 1;
    self.callType = UCS_videoCall;
    [[UCSFuncEngine getInstance] dial:callType andCallId:callNumber andUserdata:@"视频通话"];
}




//为智能呼叫准备
- (void)makingCallViewSmartCallNumber:(NSString *)callNumber callType:(int)callType callName:(NSString *)callName{
    
    
    if (self.callViewController || self.incomingCallViewController || self.videoViewController || self.incomingVideoViewController || self.callVC) {
        /**
         @author WLS, 15-12-11 19:12:19
         
         如果界面存在,说明连续拨打了两次同一个号码，这里就不做重复拨打操作。
         */
        [[UCSVOIPViewEngine getInstance] WriteToSandBox:@"已有界面，不能发起通话"];
        
        return;
    }
    
    
    
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
        
        TCDoorVoipCallController * voipCallVC = [[TCDoorVoipCallController alloc] initWithCallerNo:phoneNumber andVoipNo:userId andCallType:callType];
        voipCallVC.incomingCall = NO;
        voipCallVC.callID = callUserid;
        voipCallVC.callerName = nickName;
        voipCallVC.callType = callType;
        self.callViewController = voipCallVC;
        [self pushToTheViewController:voipCallVC];
        
        [[UCSFuncEngine getInstance] dial:callType andCallId:callUserid andUserdata:@"智能呼叫"];
    }
}

/**
 @author WLS, 15-12-11 19:12:39
 
 弹起通话界面
 
 @param pushVC 需要弹起的界面
 */
- (void)pushToTheViewController:(UIViewController * )pushVC{
    
    pushVC.view.frame = self.window.bounds;
    [self.window addSubview:pushVC.view];
    [pushVC generyallyAnimationWithView:pushVC.view animationType:GenerallyAnimationSliderFormBottom duration:0.2 delayTime:0 finishedBlock:nil];
    
}


/**
 @author WLS, 15-12-11 18:12:54
 
 移除界面
 
 @param releaseVC 需要移除的界面
 */
- (void)releaseViewControler:(UIViewController *)releaseVC{
    
    if (self.releaseView == releaseVC || releaseVC == nil) {
        
        
        
        return;
    }
    
    self.releaseView = releaseVC;
    
    /**
     @author WLS, 15-12-19 10:12:13
     
     创建数据库模型
     */
    [self makeDBModel:releaseVC callDic:nil];
    
    
    
    [releaseVC generyallyAnimationWithView:releaseVC.view animationType:GenerallyAnimationSliderToBottom duration:0.2 delayTime:0 finishedBlock:^{
        [releaseVC.view removeFromSuperview];
        if (releaseVC == self.callViewController) {
            self.callViewController = nil;
        }else if (releaseVC == self.incomingCallViewController){
            self.incomingCallViewController = nil;
        }else if (releaseVC == self.videoViewController){
            self.videoViewController = nil;
        }else if (releaseVC == self.incomingVideoViewController){
            self.incomingVideoViewController = nil;
        }else if (releaseVC == self.callVC){
            self.callVC = nil;
        }
        self.releaseView =nil;
        
        
    }];
    
    
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
    
    if (self.callType == UCS_voipCall) {
        [self.callViewController networkStatusChange:networkStateStr.integerValue];
    }else if (self.callType == UCS_incomingVoipCall){
        [self.incomingCallViewController networkStatusChange:networkStateStr.integerValue];
    }else if (self.callType == UCS_videoCall){
        [self.videoViewController networkStatusChange:networkStateStr.integerValue];
    }else{
        if (_deviceType == 1) {
            //猫眼暂不处理
        }else{
            [self.incomingVideoViewController networkStatusChange:networkStateStr.integerValue];
        }
    }
    
}


//来电信息
-(void)incomingCallID:(NSString*)callid caller:(NSString*)caller phone:(NSString*)phone name:(NSString*)name callStatus:(int)status callType:(NSInteger)calltype{
    //-(void)incomingCallInfo:(NSDictionary *)callInfo andCallID:(NSString *)callid caller:(NSString*)caller phone:(NSString*)phone name:(NSString*)name callStatus:(int)status callType:(NSInteger)calltype{//门口机使用该代理方法
    
    //如果在开锁页面(关闭开锁页面)
    [[NSNotificationCenter defaultCenter] postNotificationName:UCSNotiClsoeView object:nil];
    NSLog(@"callid===%@---caller==%@--phone===%@---name==%@---calltype===%ld",callid,caller,phone,name,(long)calltype);
    //猫眼特殊处理callInfo
    //    {
    //        "fromId":"xxxxx", // 呼叫方的id
    //        "type":"1" // 呼叫方机器类型，1猫眼，2门口机
    //    }
    //    NSString *catEyeId = [callInfo objectForKey:@"fromId"];
    //    if ([[callInfo objectForKey:@"type"] integerValue] == 1) {
    //        _deviceType = 1;
    //    }else{
    //        _deviceType = 2;
    //    }
    
    NSString *callNumber = caller;//[callInfo objectForKey:@"callerNumber"];
    
    if ([[callNumber substringToIndex:3] isEqualToString:@"Cat"]) {
        _deviceType = 1;
    }else{
        _deviceType = 2;
    }
    
    self.callViewController = nil;
    self.incomingCallViewController  = nil;
    self.videoViewController = nil;
    self.incomingVideoViewController = nil;
    self.callVC = nil;
    
    self.isCalling = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:UCSNotiIncomingCall object:nil];
    
    /**
     @author WLS, 15-12-19 10:12:05
     
     主叫的昵称
     */
    
    NSString * nickName = nil;
    nickName = [TCCloudTalkingTool getMachineNameWithVoipNo:caller];
    
    if (nickName == nil) {
        nickName = caller;
    }
    
    
    
    [[UCSVOIPViewEngine getInstance] WriteToSandBox:@"收到来电"];
    
    NSLog(@"%@---扬声器状态",[[AVAudioSession sharedInstance] category]);
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if (state != UIApplicationStateActive ) {
        [[self player] releasePlayResource];//释放资源,不占用播放句柄
        
        //iOS10以上
        if (@available(iOS 10.0, *)) {
            [[self player] play];//若应用处于前台,播放铃声
            if (_deviceType == 2) {
                [[PushNotificationManager sharedInstance] normalPushNotificationWithTitle:@"门口机来电" subTitle:nil body:[NSString stringWithFormat:@"%@ %@", nickName,  (calltype == 2)? @"视频来电" : @"语音来电"] userInfo:nil identifier:@"identifier" soundName:@"incomingCall.mp3" timeInterval:1 repeat:NO];
            }else{
                [[PushNotificationManager sharedInstance] normalPushNotificationWithTitle:@"猫眼来电" subTitle:nil body:[NSString stringWithFormat:@"%@ %@", nickName, @"视频来电"] userInfo:nil identifier:@"identifier" soundName:@"incomingCall.mp3" timeInterval:1 repeat:NO];
            }
        }else if (UCS_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(8.0)){
            
            if (_deviceType == 2) {
                UILocalNotification *localNot = [[UILocalNotification alloc] init];
                localNot.fireDate = [NSDate date];
                localNot.alertBody = [NSString stringWithFormat:@"%@ %@", nickName,  (calltype == 2)? @"视频来电" : @"语音来电"];
                localNot.soundName = @"incomingCall.mp3";
                localNot.timeZone = [NSTimeZone defaultTimeZone];
                [[UIApplication sharedApplication]  scheduleLocalNotification:localNot];
            }else{
                UILocalNotification *localNot = [[UILocalNotification alloc] init];
                localNot.fireDate = [NSDate date];
                localNot.alertBody = [NSString stringWithFormat:@"%@ %@", nickName,@"视频来电"];
                localNot.soundName = @"incomingCall.mp3";
                localNot.timeZone = [NSTimeZone defaultTimeZone];
                [[UIApplication sharedApplication]  scheduleLocalNotification:localNot];
            }
        }
        
    }else if (state == UIApplicationStateActive ) {
        [[self player] play];//若应用处于前台,播放铃声
    }
    
    
    
    if (calltype == UCSCallType_VOIP)  //语音电话
    {
        self.callType = UCS_incomingVoipCall;
        TCDoorVoipCallController * incomingCallVC = [[TCDoorVoipCallController alloc] initWithCallerNo:phone andVoipNo:caller andCallType:calltype];
        incomingCallVC.incomingCall = YES;
        incomingCallVC.callID = callid;
        incomingCallVC.callerName = nickName;
        self.incomingCallViewController = incomingCallVC;
        [self pushToTheViewController:incomingCallVC];
    }
    else if(calltype == 2)  //视频
    {
        self.callType = UCS_incomingVideoCall;
        if (_deviceType == 1) {
            TCCTCatEyeCall *VC = [[TCCTCatEyeCall alloc] init];
            //TODO确定透传设备ID
            VC.callID = callNumber;
            self.callVC = VC;
            [self pushToTheViewController:VC];
        }else{
            
            TCDoorVideoCallController* incomingVideolView = [[TCDoorVideoCallController alloc] initWithCallerName:nickName andVoipNo:caller];
            //            if ([[callNumber substringToIndex:2] isEqualToString:@"5K"]) {
            //                incomingVideolView.is5KMachine = YES;
            //            }else
            //            {
            //                incomingVideolView.is5KMachine = NO;
            //            }
            incomingVideolView.incomingCall = YES;
            incomingVideolView.callID = callid;
            incomingVideolView.isActivity = NO;
            self.incomingVideoViewController = incomingVideolView;
            
            [self pushToTheViewController:incomingVideolView];
        }
        
    }
    
    //开始震动
    [[TCCVibrationer instance] addVibrate];
    
}



//通话状态回调
-(void)responseVoipManagerStatus:(UCSCallStatus)event callID:(NSString*)callid data:(UCSReason *)data withVideoflag:(int)videoflag{
    
    
    [[TCCVibrationer instance] removeVibrate];
    
    
    [[UCSVOIPViewEngine getInstance] WriteToSandBox:[NSString stringWithFormat:@"收到信令：%d---%@---%@",event,callid,data.msg]];
    
    if (self.callType == UCS_voipCall) {
        [self.callViewController responseVoipManagerStatus:event callID:callid data:data withVideoflag:videoflag];
        if ((event == UCSCallStatus_Released || event == UCSCallStatus_Answered)) {//音频去电模式,若挂断,接听,接听则停止播放铃声
            [[self player] stop];
        }
    }else if (self.callType == UCS_incomingVoipCall){
        [self.incomingCallViewController responseVoipManagerStatus:event callID:callid data:data withVideoflag:videoflag];
        if ((event == UCSCallStatus_Released || event == UCSCallStatus_Answered)) {//音频去电模式,若挂断,接听,接听则停止播放铃声
            [[self player] stop];
        }
    }else if (self.callType == UCS_videoCall){
        if (_deviceType == 1) {
            UIViewController *curVC = [self xs_getCurrentViewController];
            TCCTCatEyeMonitorVC *callVC = (TCCTCatEyeMonitorVC *)curVC;
            [callVC responseVoipManagerStatus:event callID:callid data:data withVideoflag:videoflag];
            if ((event == UCSCallStatus_Released || event == UCSCallStatus_Answered)) {//音频去电模式,若挂断,接听,接听则停止播放铃声
                [[self player] stop];
            }
        }else{
            [self.videoViewController responseVoipManagerStatus:event callID:callid data:data withVideoflag:videoflag];
            if ((event == UCSCallStatus_Released || event == UCSCallStatus_Answered)) {//音频去电模式,若挂断,接听,接听则停止播放铃声
                [[self player] stop];
            }
        }
    }else{
        if (_deviceType == 1) {
            [self.callVC responseVoipManagerStatus:event callID:callid data:data withVideoflag:videoflag];
            if ((event == UCSCallStatus_Released || event == UCSCallStatus_Answered)) {//音频去电模式,若挂断,接听,接听则停止播放铃声
                [[self player] stop];
            }
        }else{
            [self.incomingVideoViewController responseVoipManagerStatus:event callID:callid data:data withVideoflag:videoflag];
            if ((event == UCSCallStatus_Released || event == UCSCallStatus_Answered)) {//音频去电模式,若挂断,接听,接听则停止播放铃声
                [[self player] stop];
            }
        }
    }
    
    
}

- (void)onReceivedPreviewImg:(UIImage *)image  callid:(NSString *)callid error:(NSError *)error{
    //[self.incomingVideoViewController onReceivedPreviewImg:image callid:callid error:error];
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


#pragma mark - 数据库操作
/**
 @author WLS, 15-12-19 10:12:43
 
 存储到数据库
 
 @param releaseVC 点击挂断或者被挂断的通话界面
 @param callDic   没有弹起通话界面，只是在后台被挂断，此时的收到来电的主叫数据
 */
- (void)makeDBModel:(UIViewController *)releaseVC callDic:(NSDictionary *)callDic{
    
    if (releaseVC == nil && callDic == nil) {
        return;
    }
    
    TCVoipCallListModel * callModel = [[TCVoipCallListModel alloc] init];
    callModel.headPortrait = @"";
    callModel.time = [NSString stringWithFormat:@"%ld",time(NULL)];
    if (releaseVC == nil) {
        
        /**
         @author WLS, 15-12-19 10:12:48
         
         此时通话未建立，被叫通话没有接听
         */
        callModel.userId = [callDic objectForKey:@"caller"];
        callModel.nickName = [callDic objectForKey:@"nickName"];
        callModel.callDuration = @"";
        callModel.callType = [NSString stringWithFormat:@"%d",[[callDic objectForKey:@"callType"]isEqualToString:@"语音电话"]?UCSCallType_VOIP:UCSCallType_VideoPhone];
        callModel.callStatus = [NSString stringWithFormat:@"%d",UCS_CallType_Disanswer];
        callModel.sendCall = @"0";
        callTypes = 1;
    }else if ([releaseVC isKindOfClass:[TCDoorVoipCallController class]] ) {
        
        TCDoorVoipCallController * callModelVC = (TCDoorVoipCallController *)releaseVC;
        if (callModelVC.incomingCall) {
            
            /**
             @author WLS, 15-12-19 10:12:36
             
             语音通话被叫
             */
            callModel.userId = callModelVC.voipNo;
            callModel.nickName = callModelVC.callerName;
            callModel.callDuration = callModelVC.callDuration;
            callModel.time = callModelVC.currentTime?callModelVC.currentTime:callModel.time;
            callModel.callType = [NSString stringWithFormat:@"%d",UCSCallType_VOIP];
            if (callModelVC.isCallNow) {
                callModel.callStatus = [NSString stringWithFormat:@"%d",UCS_CallType_Answer];
                callTypes = 1;
            }else{
                callModel.callStatus = [NSString stringWithFormat:@"%d",UCS_CallType_Disanswer];
                callTypes = 2;
            }
            callModel.sendCall = @"0";
            
            
        }else{
            
            /**
             @author WLS, 15-12-19 10:12:26
             
             语音通话主叫
             */
            callModel.userId = callModelVC.voipNo;
            callModel.nickName = callModelVC.callerName;
            callModel.callDuration = callModelVC.callDuration;
            callModel.time = callModelVC.currentTime?callModelVC.currentTime:callModel.time;
            callModel.callType = [NSString stringWithFormat:@"%d",callModelVC.callType];
            if (callModelVC.isCallNow) {
                callModel.callStatus = [NSString stringWithFormat:@"%d",UCS_CallType_Answer];
                callTypes = 1;
            }else{
                if (callModelVC.beReject) {
                    /**
                     @author WLS, 15-12-21 11:12:48
                     
                     被叫拒绝接听
                     */
                    callModel.callStatus = [NSString stringWithFormat:@"%d",UCS_CallType_Cancel];
                    callTypes = 2;
                }else{
                    callModel.callStatus = [NSString stringWithFormat:@"%d",UCS_CallType_Cancel];
                    callTypes = 2;
                }
            }
            callModel.sendCall = @"1";
            
            if (callModelVC.callType == 1) {
                callModel.userId = callModelVC.callerNo;
                
            }
        }
        
        
    }else if ([releaseVC isKindOfClass:[TCDoorVideoCallController class]]){
        
        TCDoorVideoCallController * callModelVC = (TCDoorVideoCallController *)releaseVC;
        if (callModelVC.incomingCall) {
            /**
             @author WLS, 15-12-19 10:12:42
             
             视频通话被叫
             */
            callModel.userId = callModelVC.voipNo;
            callModel.nickName = callModelVC.callerName;
            callModel.callDuration = callModelVC.callDuration;
            callModel.time = callModelVC.currentTime?callModelVC.currentTime:callModel.time;
            callModel.callType = [NSString stringWithFormat:@"%d",UCSCallType_VideoPhone];
            if (callModelVC.isCallNow) {
                callModel.callStatus = [NSString stringWithFormat:@"%d",UCS_CallType_Answer];
                callTypes = 1;
            }else{
                callModel.callStatus = [NSString stringWithFormat:@"%d",UCS_CallType_Disanswer];
                callTypes = 2;
            }
            callModel.sendCall = @"0";
            
        }else{
            /**
             @author WLS, 15-12-19 10:12:42
             
             视频通话主叫
             */
            callModel.userId = callModelVC.voipNo;
            callModel.nickName = callModelVC.callerName;
            callModel.callDuration = callModelVC.callDuration;
            callModel.time = callModelVC.currentTime?callModelVC.currentTime:callModel.time;
            callModel.callType = [NSString stringWithFormat:@"%d",UCSCallType_VideoPhone];
            if (callModelVC.isCallNow) {
                callModel.callStatus = [NSString stringWithFormat:@"%d",UCS_CallType_Answer];
            }else{
                if (callModelVC.beReject) {
                    /**
                     @author WLS, 15-12-21 11:12:48
                     
                     被叫拒绝接听
                     */
                    callModel.callStatus = [NSString stringWithFormat:@"%d",UCS_CallType_Cancel];
                    callTypes = 2;
                }else{
                    callModel.callStatus = [NSString stringWithFormat:@"%d",UCS_CallType_Cancel];
                    callTypes = 2;
                }
            }
            callModel.sendCall = @"1";
            
        }
        
        
        
    }
    
    
    if ([callModel.userId isEqualToString:callModel.nickName]) {
        callModel.nickName = @"";
    }
    
    
    
    if ([callModel checkModelInfo]) {
        return;
    }
    
    TCCallRecordsModel * recordModel = [[TCCallRecordsModel alloc] init];
    [recordModel getInfoFromCallListModel:callModel];
    
    
    
    
    NSLog(@"%@-------%@---------%@",self.incomingVideoViewController.voipNo,callModel.userId,recordModel.userId);
    NSLog(@"%@-------%@---------%@",self.callViewController,callModel.nickName,recordModel.nickName);
    NSLog(@"%@----------------%@",callModel.time,recordModel.time);
    NSLog(@"%@-------%@---------%@",self.callViewController,callModel.callDuration,recordModel.callDuration);
    NSLog(@"%@----------------%@",callModel.headPortrait,recordModel.headPortrait);
    NSLog(@"%@----------------%@",callModel.callType,recordModel.callType);
    NSLog(@"%@----------------%@",callModel.callStatus,recordModel.callStatus);
    NSLog(@"%@----------------%@",callModel.sendCall,recordModel.sendCall);
    
    [[FMDBBaseTool shareInstance] insertDBWithModel:recordModel];
    [[UCSVOIPViewEngine getInstance] WriteToSandBox:[NSString stringWithFormat:@"写入数据库"]];
    
    
    /**
     @author WLS, 15-12-19 14:12:38
     
     当数据库存储完成后，发通知更新呼叫记录界面
     */
    self.isCalling = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:UCSNotiRefreshCallList object:nil];
}




//以本地通知方式弹出数据用于调试pushkit
- (void)debugReleaseShowLocalNotification:(NSString *)str
{
    
    //    UILocalNotification *localNot = [[UILocalNotification alloc] init];
    //    localNot.fireDate = [NSDate date];
    //    localNot.alertBody = [NSString stringWithFormat:@"%@", str];
    //    localNot.soundName = @"receive_msg.caf";
    //    localNot.timeZone = [NSTimeZone defaultTimeZone];
    //    [[UIApplication sharedApplication]  scheduleLocalNotification:localNot];
    
    NSString *contentString = str;
    
    if (IOS_VERSION >= 10.0) {
        
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.body = contentString;
        content.sound = [UNNotificationSound defaultSound];
        
        // 在 0.001s 后推送本地推送
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:0.001 repeats:NO];
        //创建一个通知请求
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"0Second"
                                                                              content:content trigger:trigger];
        
        //将通知请求添加到通知中心
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
        
        
    }else{
        
        UILocalNotification *localNot = [[UILocalNotification alloc] init];
        localNot.fireDate = [NSDate date];
        localNot.alertBody = contentString;
        localNot.soundName = UILocalNotificationDefaultSoundName;
        localNot.timeZone = [NSTimeZone defaultTimeZone];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNot];
        
    }
    
    //设置外面的未读消息数
    long bed = [UIApplication sharedApplication].applicationIconBadgeNumber ;
    [UIApplication sharedApplication].applicationIconBadgeNumber = bed + 1;
    
    
    
    
}

- (void)showincomingCallViewController
{
    if(self.incomingCallViewController){
        
        //动画--淡入
        [UIView beginAnimations:nil context:nil];//标记动画块开始
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];//定义动画加速和减速方式
        [UIView setAnimationDuration:0.5];//动画时长
        [UIView setAnimationDelegate:self];
        //    imgview.alpha = 1.0;
        self.incomingCallViewController.view.hidden = NO;
        //动画结束后回调方法
        [UIView setAnimationDidStopSelector:@selector(showArrowDidStop:finished:context:)];
        [UIView commitAnimations];//标志动滑块结束
    }
    
    
    
}

- (void)showincomingVideoViewController
{
    
    if(self.incomingVideoViewController){
        
        //动画--淡入
        [UIView beginAnimations:nil context:nil];//标记动画块开始
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];//定义动画加速和减速方式
        [UIView setAnimationDuration:0.5];//动画时长
        [UIView setAnimationDelegate:self];
        //    imgview.alpha = 1.0;
        self.incomingVideoViewController.view.hidden = NO;
        //动画结束后回调方法
        [UIView setAnimationDidStopSelector:@selector(showArrowDidStop:finished:context:)];
        [UIView commitAnimations];//标志动滑块结束
        
    }
    
    
    
}
//动画执行完后的将会调用的方法
- (void)showArrowDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    //    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hiddenAnimation) userInfo:Nil repeats:NO];
}


//动画--淡出
-(void)hiddenAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
        //        imgview.alpha=0.0;
    } completion:^(BOOL finished) {
        //        [imgview removeFromSuperview];
        //        [bgView removeFromSuperview];
    }];
    //    [UIView beginAnimations:@"HideArrow" context:nil];
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //    [UIView setAnimationDuration:0.5];
    //    [UIView setAnimationDelay:1.0];
    //    imgview.alpha = 0.0;
    //    [UIView commitAnimations];
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
