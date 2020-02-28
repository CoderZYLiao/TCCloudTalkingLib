//
//  TCCallRecordsModel.h
//  FBSnapshotTestCase
//
//  Created by Huang ZhiBin on 2019/10/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class TCVoipCallListModel;
@interface TCCallRecordsModel : NSObject

@property (copy, nonatomic) NSString * userId;       // 账号ID
@property (copy, nonatomic) NSString * nickName;     // 账号昵称
@property (copy, nonatomic) NSString * time;         // 拨打或者接听时间
@property (copy, nonatomic) NSString * callDuration; // 通话时间
@property (copy, nonatomic) NSString * headPortrait; // 账号头像
@property (copy, nonatomic) NSString * callType;     // 通话类型 (语音通话，单向外呼，视频通话)
@property (copy, nonatomic) NSString * callStatus;   // 通话状态 （接听0，已取消1，未接听2）
@property (copy, nonatomic) NSString * sendCall;     // 来电还是拨打

- (void)getInfoFromCallListModel:(TCVoipCallListModel *)model;
@end

NS_ASSUME_NONNULL_END
