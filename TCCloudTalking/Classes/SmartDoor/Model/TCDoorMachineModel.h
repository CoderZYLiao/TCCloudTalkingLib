//
//  TCDoorMachineModel.h
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCDoorMachineModel : NSObject

//主键
@property (nonatomic, strong) NSString *ID;
//设备名称
@property (nonatomic, strong) NSString *name;
//社区ID
@property (nonatomic, strong) NSString *coId;
//设备机身号
@property (nonatomic, strong) NSString *num;
//房间Id,户门口机
@property (nonatomic, strong) NSString *rId;
//社区结构ID
@property (nonatomic, strong) NSString *csId;
//对讲Id
@property (nonatomic, strong) NSString *intercomUserId;
//是否关好
@property (nonatomic, strong) NSString *isClosed;
//是否在线
@property (nonatomic, strong) NSString *isOnline;

@end

NS_ASSUME_NONNULL_END
