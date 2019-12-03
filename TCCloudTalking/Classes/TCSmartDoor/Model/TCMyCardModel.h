//
//  TCMyCardModel.h
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCMyCardModel : NSObject
//主键
@property (nonatomic, strong) NSString *ID;
//卡号
@property (nonatomic, strong) NSString *num;
//住户ID
@property (nonatomic, strong) NSString *houseId;
//过期时间
@property (nonatomic, strong) NSString *expirationTime;
//创建者
@property (nonatomic, strong) NSString *creator;
//最后修改时间
@property (nonatomic, strong) NSString *lastModifyTime;
//创建时间
@property (nonatomic, strong) NSString *createTime;
//备注
@property (nonatomic, strong) NSString *remark;
@end

NS_ASSUME_NONNULL_END
