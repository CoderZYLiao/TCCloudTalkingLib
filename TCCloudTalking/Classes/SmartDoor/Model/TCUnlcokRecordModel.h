//
//  TCUnlcokRecordModel.h
//  TCCloudTalking-TCCloudTalking
//
//  Created by Huang ZhiBin on 2019/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class TCUnlcokRecordDataModel;
@interface TCUnlcokRecordModel : NSObject
//页面索引，0开始
@property (nonatomic, strong) NSString *pageIndex;
//页面记录大小
@property (nonatomic, strong) NSString *pageSize;
//全部记录条数
@property (nonatomic, strong) NSString *totalCount;

//PriRoomView实体
@property (nonatomic, strong) TCUnlcokRecordDataModel *dataArray;
@end


@interface TCUnlcokRecordDataModel : NSObject
//开锁者类型
@property (nonatomic, strong) NSString *userType;
//住户Id
@property (nonatomic, strong) NSString *account;
//住户姓名
@property (nonatomic, strong) NSString *name;
//住户地址
@property (nonatomic, strong) NSString *address;
//开锁类型
@property (nonatomic, strong) NSString *unlockType;
//图片名称
@property (nonatomic, strong) NSString *imageSrc;
//是否为出状态
@property (nonatomic, strong) NSString *isOut;
//主键
@property (nonatomic, strong) NSString *ID;
//获取或设置租户Id
@property (nonatomic, strong) NSString *tenantId;
//社区ID
@property (nonatomic, strong) NSString *coId;
//社区名称
@property (nonatomic, strong) NSString *coName;
//门口机编号
@property (nonatomic, strong) NSString *eqNum;
//门口机名称
@property (nonatomic, strong) NSString *eqName;
//创建时间
@property (nonatomic, strong) NSString *createTime;
@end


NS_ASSUME_NONNULL_END
