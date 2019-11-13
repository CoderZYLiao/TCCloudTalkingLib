#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CollectionButtonModel.h"
#import "NSString+UCLog.h"
#import "Singleton.h"
#import "SynthesizeSingleton.h"
#import "TCCUserDefaulfManager.h"
#import "Header.h"
#import "TCSmartDoorViewController.h"
#import "TCSmartDoorCollectionCell.h"
#import "UCSError.h"
#import "UCSTcpClient.h"
#import "UCSTCPCommonClass.h"
#import "UCSTcpDefine.h"
#import "UCSTCPDelegateBase.h"
#import "UCSTCPSDK.h"
#import "InfoManager.h"
#import "PushNotificationManager.h"
#import "TCCallRecordsModel.h"
#import "TCCAVPlayer.h"
#import "TCCPubEnum.h"
#import "TCCVibrationer.h"
#import "TCVoipCallListModel.h"
#import "TCVoipDBManager.h"
#import "UCConst.h"
#import "UCSChangeTheViewController.h"
#import "UCSFuncEngine.h"
#import "UCSVOIPViewEngine.h"
#import "TCVideoCallController.h"
#import "TCVoipCallController.h"
#import "UCSCommonClass.h"
#import "UCSEvent.h"
#import "UCSService.h"
#import "UCSVideoDefine.h"

FOUNDATION_EXPORT double TCCloudTalkingVersionNumber;
FOUNDATION_EXPORT const unsigned char TCCloudTalkingVersionString[];

