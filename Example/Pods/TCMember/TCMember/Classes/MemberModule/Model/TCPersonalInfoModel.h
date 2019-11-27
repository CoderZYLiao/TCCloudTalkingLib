//
//  TCPersonalInfoModel.h
//  TCMember
//
//  Created by Huang ZhiBing on 2019/11/6.
//

#import <Foundation/Foundation.h>
@class TCUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface TCPersonalInfoModel : NSObject
+ (instancetype)shareInstance;
- (TCUserModel *)getUserModel;
- (void)UpdateUserModel;
- (void)updateUserModelName:(NSString *)name;
- (void)updateUserModelAvatar:(NSString *)avatar;
- (void)updateUserModelGender:(NSInteger)gender;
- (void)logout;
@end

NS_ASSUME_NONNULL_END
