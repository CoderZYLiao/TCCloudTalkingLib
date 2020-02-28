//
//  TCPersonalInfoModel.h
//  TCMember
//
//  Created by Huang ZhiBing on 2019/11/6.
//

#import <Foundation/Foundation.h>
@class TCUserModel;
@class TCHousesInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface TCPersonalInfoModel : NSObject
+ (instancetype)shareInstance;
- (TCUserModel *)getUserModel;
- (TCHousesInfoModel *)getHousesInfoModel;   // 获取对讲信息
- (void)UpdateUserModel;
- (void)updateUserModelName:(NSString *)name;
- (void)updateUserModelAvatar:(NSString *)avatar;
- (void)updateUserModelGender:(NSInteger)gender;
- (void)logout;
@end

NS_ASSUME_NONNULL_END
