//
//  TCDoorMachineModel.h
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCDoorMachineModel : NSObject

//设备所在平台 0为v5自身平台
@property (nonatomic, strong) NSString *platform;
//设备名称
@property (nonatomic, strong) NSString *name;
//设备机身号
@property (nonatomic, strong) NSString *num;
//对讲Id
@property (nonatomic, strong) NSString *intercomUserId;
//是否在线
@property (nonatomic, assign) BOOL isOnline;

@end

NS_ASSUME_NONNULL_END
