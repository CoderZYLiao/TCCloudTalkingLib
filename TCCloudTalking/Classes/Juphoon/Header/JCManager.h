//
//  JCManager.h
//  JCSampleOC
//
//  Created by maikireton on 2017/8/22.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

extern NSString * const kClientStateChangeNotification;
extern NSString * const kClientOnLoginSuccessNotification;
extern NSString * const kClientOnLoginFailNotification;
extern NSString * const kClientOnLogoutNotification;
extern NSString * const kCallNotification;
extern NSString * const kCallIetmKey;
extern NSString * const kPushApnsTokenNotification;
extern NSString * const kJCLogNotification;

extern NSString * const kMediaDeviceSpeakerUpdateNotification;

extern NSString * const kCallMessageNotification;
extern NSString * const kMessageTypeKey;
extern NSString * const kMessageContentKey;

extern NSString * const kStorageUpdate;
extern NSString * const kStorageResult;

extern NSString * const kAccountQueryUserStatusNotification;
extern NSString * const kAccountQueryUserStatusKey;


@interface JCManager : NSObject

@property (nonatomic, strong) JCClient* client;
@property (nonatomic, strong) JCMediaDevice* mediaDevice;
@property (nonatomic, strong) JCMessageChannel* messageChannel;
@property (nonatomic, strong) JCCall* call;
@property (nonatomic, strong) JCPush* push;
@property (nonatomic, strong) JCAccount* account;

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, readonly) bool isInited;
@property (nonatomic, strong, readonly) NSString* nowLogs;

+ (JCManager*)shared;

-(bool)initialize;

-(void)uninitialize;

@end
