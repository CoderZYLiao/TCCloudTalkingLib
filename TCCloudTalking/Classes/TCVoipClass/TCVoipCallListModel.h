//
//  TCVoipCallListModel.h
//  FBSnapshotTestCase
//
//  Created by Huang ZhiBin on 2019/10/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCVoipCallListModel : NSObject
@property (copy, nonatomic) NSString * userId;       // 账号ID
@property (copy, nonatomic) NSString * isTop;        // 是否置顶
@property (copy, nonatomic) NSString * nickName;     // 账号昵称
@property (copy, nonatomic) NSString * time;         // 拨打或者接听时间
@property (copy, nonatomic) NSString * callDuration; // 通话时间
@property (copy, nonatomic) NSString * headPortrait; // 账号头像
@property (copy, nonatomic) NSString * callType;     // 通话类型 (语音通话0，单向外呼1，视频通话2)
@property (copy, nonatomic) NSString * callStatus;   // 通话状态 （接听0，已取消1，未接听2）
@property (copy, nonatomic) NSString * sendCall;     // 来电为0 拨打为1

- (BOOL)checkModelInfo;
@end

NS_ASSUME_NONNULL_END
