//
//  FMDBBaseTool.h
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/21.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMDBBaseTool : NSObject
@property (strong,nonatomic)FMDatabaseQueue * baseToolQueue;

+ (instancetype)shareInstance;

// 插入数据
- (BOOL)insertDBWithModel:(id)model;

// 删除数据  删除某个模型对应的数据
//- (BOOL)deleteModelToDB:(id)model;

// 根据userid删除所有的会话纪录
//- (BOOL)deleteAllRecordeWothUserId:(NSString *)userId;

// 更新数据
- (BOOL)updateDBWithModel:(id)model;

// 查找通话列表所有数据
//- (NSArray *)getAllDataFromDb:(NSString *)tableName;

// 查找某张表中通话详情
- (id)getDataWithDB:(NSString *)tableName;
@end

NS_ASSUME_NONNULL_END
