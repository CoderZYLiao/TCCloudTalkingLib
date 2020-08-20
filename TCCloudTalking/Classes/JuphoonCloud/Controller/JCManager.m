//
//  JCManager.m
//  JCSampleOC
//
//  Created by maikireton on 2017/8/22.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "JCManager.h"
#import <PushKit/PushKit.h>
#import <UserNotifications/UserNotifications.h>
#import "JCDoorVideoCallController.h"
#import "TCVoipDBManager.h"
#import "TCVoipCallListModel.h"
#import "TCCallRecordsModel.h"
#import "FMDBBaseTool.h"
#import "TCCAVPlayer.h"
#import "PushNotificationManager.h"
#import "TCCVibrationer.h"

//#define MY_APP_KEY @"05a47ad899f302041d525097" //菊风测试key
#define MY_APP_KEY @"6c06d1b0d9015e47ec144097" //
NSString * const kClientStateChangeNotification =  @"kClientStateChangeNotification";
NSString * const kClientOnLoginSuccessNotification = @"kClientOnLoginNotification";
NSString * const kClientOnLoginFailNotification = @"kClientOnLoginFailNotification";
NSString * const kClientOnLogoutNotification = @"kClientOnLogoutNotification";
NSString * const kPushApnsTokenNotification = @"kPushApnsTokenNotification";
NSString * const kJCLogNotification = @"kJCLogNotification";

NSString * const kMediaDeviceSpeakerUpdateNotification = @"kMediaDeviceSpeakerUpdateNotification";

NSString * const kCallNotification = @"kCallNotification";
NSString * const kCallIetmKey = @"kCallIetmKey";

NSString * const kCallMessageNotification = @"kCallMessageNotification";
NSString * const kMessageTypeKey = @"kMessageTypeKey";
NSString * const kMessageContentKey = @"kMessageContentKey";

NSString * const kStorageUpdate = @"kStorageUpdate";

NSString * const kStorageResult = @"kStorageResult";



NSString * const kAccountQueryUserStatusNotification = @"kAccountQueryUserStatusNotification";
NSString * const kAccountQueryUserStatusKey = @"kAccountQueryUserStatusKey";

@interface JCManager () <JCClientCallback, JCMediaDeviceCallback, JCCallCallback, JCAccountCallback> {
    NSMutableArray* _logs;
}

@property (nonatomic, strong) TCCAVPlayer * player;

@end

static JCManager* _manager;

@implementation JCManager

- (TCCAVPlayer *)player{
    if (_player == nil) {
        NSURL * url = [NSURL URLWithString:[[NSBundle bundleForClass:[self class]] pathForResource:@"incomingCall" ofType:@"mp3" inDirectory:@"TCCloudTalking.bundle"]];
        _player = [[TCCAVPlayer alloc] initWithContentsOfURL:url];
    }
    return _player;
}

+ (JCManager*)shared
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

-(bool)initialize
{
    JCClientCreateParam *param = [[JCClientCreateParam alloc] init];
    //    param.sdkLogLevel = [StandardUserDefault integerForKey:@"LogLevel"];
    //    param.sdkInfoDir = [self genFullPath:[StandardUserDefault objectForKey:@"SdkDir"]];
    //    param.sdkLogDir = [self genFullPath:[StandardUserDefault objectForKey:@"LogDir"]];
    _client = [JCClient create:MY_APP_KEY callback:self creatParam:param];
    _mediaDevice = [JCMediaDevice create:_client callback:self];
    _call = [JCCall create:_client mediaDevice:_mediaDevice callback:self];
    _push = [JCPush create:_client];
    _account = [JCAccount create:self];
    _logs = [[NSMutableArray alloc] init];
    
    [self addLog:[NSString stringWithFormat:@"*initialize"]];
    
    return _client.state == JCClientStateIdle;
}

-(NSString *)genFullPath:(NSString *)appendInfo
{
    NSString *homePath = NSHomeDirectory();
    NSString *sdkInfoPath = [homePath stringByAppendingPathComponent:appendInfo];
    return sdkInfoPath;
}

-(void)uninitialize
{
    if (_client != nil) {
        [self addLog:[NSString stringWithFormat:@"*uninitialize"]];
        [JCPush destroy];
        [JCStorage destroy];
        [JCCall destroy];
        [JCMediaChannel destroy];
        [JCAccount destroy];
        [JCMediaDevice destroy];
        [JCClient destroy];
        _push = nil;
        _messageChannel = nil;
        _call = nil;
        _mediaDevice = nil;
        _client = nil;
        _account = nil;
    }
}

-(bool)isInited
{
    return _client != nil;
}

-(NSString*)nowLogs {
    NSMutableString* nowLogs = [[NSMutableString alloc] init];
    for (NSString* log in _logs) {
        [nowLogs appendString:@"\n"];
        [nowLogs appendString:log];
    }
    return nowLogs;
}

-(void)addLog:(NSString*)log {
    if (_logs.count >= 100) {
        [_logs removeObjectAtIndex:0];
    }
    [_logs addObject:log];
    [[NSNotificationCenter defaultCenter] postNotificationName:kJCLogNotification object:log];
}

#pragma mark JCClient 回调函数
-(void)onLogin:(bool)result reason:(JCClientReason)reason
{
    if (result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kClientOnLoginSuccessNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kClientOnLoginFailNotification object:nil];
    }
    [self addLog:[NSString stringWithFormat:@"*onLogin result=%d reason=%d", result, (int)reason]];
}

-(void)onLogout:(JCClientReason)reason
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kClientOnLogoutNotification object:nil];
    [self addLog:[NSString stringWithFormat:@"*onLogout reason=%d", (int)reason]];
}

-(void)onClientStateChange:(JCClientState)state oldState:(JCClientState)oldState
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kClientStateChangeNotification object:nil];
    [self addLog:[NSString stringWithFormat:@"*onClientStateChange state=%d oldState=%d", (int)state, (int)oldState]];
}

#pragma mark JCMediaDevice 回调函数

-(void)onCameraUpdate
{
    [self addLog:[NSString stringWithFormat:@"*onCameraUpdate"]];
}

-(void)onAudioOutputTypeChange:(NSString*)audioOutputType
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMediaDeviceSpeakerUpdateNotification object:nil];
    [self addLog:[NSString stringWithFormat:@"*onAudioOutputTypeChange %@", audioOutputType]];
}

-(void)onRenderReceived:(JCMediaDeviceVideoCanvas*)canvas
{
    [self addLog:[NSString stringWithFormat:@"*onRenderReceived videoSource:%@", canvas.videoSource]];
}

-(void)onRenderStart:(JCMediaDeviceVideoCanvas*)canvas
{
    [self addLog:[NSString stringWithFormat:@"*onRenderStart videoSource:%@", canvas.videoSource]];
}

- (void)onAudioInerruptAndResume:(BOOL)interrupt {
    [self addLog:[NSString stringWithFormat:@"*onAudioInerruptAndResume interrupt:%d", interrupt]];
}


#pragma mark JCCallCallback 回调函数

-(void)onCallItemAdd:(JCCallItem*)item
{
    NSDictionary *dic = @{kCallIetmKey:item};
    [[NSNotificationCenter defaultCenter] postNotificationName:kCallNotification object:nil userInfo:dic];
    [self addLog:[NSString stringWithFormat:@"*onCallItemAdd %@", item.userId]];
    if (self.call.callItems.count == 1) {
        //如果在开锁页面(关闭开锁页面)
        [[NSNotificationCenter defaultCenter] postNotificationName:UCSNotiClsoeView object:nil];
        
        _callViewController = [[JCDoorVideoCallController alloc] initWithCallerItem:item];
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (root.presentedViewController) {
            [root.presentedViewController presentViewController:_callViewController animated:YES completion:nil];
        } else {
            [root presentViewController:_callViewController animated:YES completion:nil];
        }
        
        //处理铃声相关
        [self DealWithCallSoundItem:item];
    }
}

- (void)DealWithCallSoundItem:(JCCallItem*)item{
    
    if (item.direction == JCCallDirectionIn) {
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
           if (state != UIApplicationStateActive ) {
               [[self player] releasePlayResource];//释放资源,不占用播放句柄
               
               //iOS10以上
               if (@available(iOS 10.0, *)) {
                   [[self player] play];//若应用处于前台,播放铃声
                   [[PushNotificationManager sharedInstance] normalPushNotificationWithTitle:@"门口机来电" subTitle:nil body:[NSString stringWithFormat:@"%@ %@", item.userId,  item.video? @"视频来电" : @"语音来电"] userInfo:nil identifier:@"identifier" soundName:@"incomingCall.mp3" timeInterval:1 repeat:NO];
               }
               
           }else if (state == UIApplicationStateActive ) {
               [[self player] play];//若应用处于前台,播放铃声
           }
           
           //开始震动
           [[TCCVibrationer instance] addVibrate];
    }
    
   
}

-(void)onCallItemRemove:(JCCallItem*)item reason:(JCCallReason)reason description:(NSString *)description
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCallNotification object:nil];
    if (self.call.callItems.count == 0) {
        [_callViewController dismissViewControllerAnimated:YES completion:nil];
        _callViewController = nil;
    }
    
    [self addLog:[NSString stringWithFormat:@"*onCallItemRemove %@ reason:%d description:%@", item.userId, (int)reason, description]];
    
    [[TCCVibrationer instance] removeVibrate];
    [self.player  stop];
    //写入数据库
    [self makeDBModel:item reason:reason description:description];
    
}


-(void)onCallItemUpdate:(JCCallItem *)item changeParam:(JCCallChangeParam *)changeParam
{
    if (item.direction == JCCallDirectionIn) {
    
        if (item.state == JCCallStateTalking || item.state ==JCCallStateCanceled || item.state ==JCCallStateMissed || item.state ==JCCallStateError) {
            [[TCCVibrationer instance] removeVibrate];
            [self.player  stop];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCallNotification object:nil];
    [self addLog:[NSString stringWithFormat:@"*onCallItemUpdate %@", item.userId]];
    if (self.call.callItems.count == 0) {
        [_callViewController dismissViewControllerAnimated:YES completion:nil];
        _callViewController = nil;
        
    }
}

- (void)onMessageReceive:(JCCallItem *)item type:(NSString *)type content:(NSString *)content
{
    NSDictionary *dict = @{kMessageTypeKey : type ? type : @"",
                           kMessageContentKey : content ? content : @""};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCallMessageNotification object:nil userInfo:dict];
    [self addLog:[NSString stringWithFormat:@"*onMessageReceive %@ type:%@ content:%@", item.userId, type, content]];
}

- (void)onMissedCallItem:(JCCallItem *)item {
    [self addLog:[NSString stringWithFormat:@"*onMissedCallItem %@", item.userId]];
}


#pragma mark JCStorageCallback 回调函数
-(void)onFileUpdate:(JCStorageItem*)item
{
    NSNotification* notification = [[NSNotification alloc] initWithName:kStorageUpdate object:item userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void)onFileResult:(JCStorageItem *)item
{
    NSNotification* notification = [[NSNotification alloc] initWithName:kStorageResult object:item userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark JCGroupCallback 回调函数


#pragma mark JCAccount 回调函数

- (void)onQueryUserStatusResult:(int)operationId
                         result:(BOOL)queryResult
                accountItemList:(NSArray<JCAccountItem*>*)accountItemList {
}


//插入数据库操作
- (void)makeDBModel:(JCCallItem*)item reason:(JCCallReason)reason description:(NSString *)description
{
    TCVoipCallListModel * callModel = [[TCVoipCallListModel alloc] init];
    callModel.userId = item.userId;
    callModel.nickName = item.displayName ? item.displayName : item.userId;
    callModel.sendCall = [NSString stringWithFormat:@"%ld",(long)item.direction];
    callModel.callStatus = [self genCallStatus:reason item:item];
    callModel.time = [NSString stringWithFormat:@"%ld",item.beginTime];
    callModel.callType = @"2";
    callModel.callDuration = @"";
    callModel.headPortrait = @"";
    
    TCCallRecordsModel * recordModel = [[TCCallRecordsModel alloc] init];
    [recordModel getInfoFromCallListModel:callModel];
    
    [[FMDBBaseTool shareInstance] insertDBWithModel:recordModel];
    [[UCSVOIPViewEngine getInstance] WriteToSandBox:[NSString stringWithFormat:@"写入数据库"]];
}

//通话状态 （接听0，已取消1，未接听2）
- (NSString *)genCallStatus:(JCCallReason )reason item:(JCCallItem*)item{
    switch (reason) {
        case JCCallReasonTimeOut:
            return @"1";
        case JCCallReasonNetWork:
            return @"1";
        case JCCallReasonTermBySelf:
            if (item.talkingBeginTime > 0) {//通话时间大于0 说明已经接听
                return @"0";
            }else
            {
                if (item.direction == JCCallDirectionIn) {
                    return @"2";
                }else
                {
                    return @"1";
                }
            }
        case JCCallReasonAnswerFail:
            return @"1";
        case JCCallReasonDecline:
            return @"1";
        case JCCallReasonUserOffline:
            return @"1";
        case JCCallReasonNotFound:
            return @"1";
        case JCCallReasonNone:
            if (item.talkingBeginTime > 0) {//通话时间大于0 说明已经接听
                return @"0";
            }else
            {
                return @"2";
            }
            
        default:
            return @"1";
    }
}

//#pragma mark voip push
//
//- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type
//{
//    [_push addPushInfo:[[JCPushTemplate alloc] initWithToken:credentials.token voip:true debug:PushEnv]];
//    [_push addPushInfo:[[JCPushTemplate alloc] initWithCall:nil expiration:2419200]];
//    [_push addPushInfo:[[JCPushTemplate alloc] initWithText:@"text" tip:nil sound:nil expiration:2419200]];
//}
//
//- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type
//{
//    NSDictionary * dictionary = payload.dictionaryPayload;
//    
//    NSDictionary *apsDic = dictionary[@"aps"];
//    NSDictionary *alertDic = apsDic[@"alert"];
//    NSString *content = [[[[[alertDic[@"loc-args"] description] stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""]       stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    
//    NSString *key = [[alertDic[@"loc-key"] description] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    
//    if ([key isEqualToString:@"Voice call from %@"]) {
//        return;
//    }
//    
//    [Local addLocalNotification:content];
//}

@end
