//
//  TCUserModel.h
//  TCMember
//
//  Created by Huang ZhiBing on 2019/11/6.
//

#import <Foundation/Foundation.h>
@class TCCommunityModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TCGender)
{
    TCGenderUnknow = 0,  // 未知
    TCGenderFemale = 1,  // 女
    TCGenderMale = 2     // 男
};

@interface TCUserModel : NSObject
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, assign) TCGender gender;
@property (nonatomic, strong) NSString *userName; // 用户名
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *defaultCommunityId;
@property (nonatomic, strong) TCCommunityModel *defaultCommunity;
@property (nonatomic, strong) NSArray *communities;
@property (nonatomic, strong) NSString *name; // 昵称
@end

NS_ASSUME_NONNULL_END
