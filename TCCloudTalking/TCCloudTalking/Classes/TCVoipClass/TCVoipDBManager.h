//
//  TCVoipDBManager.h
//  FBSnapshotTestCase
//
//  Created by Huang ZhiBin on 2019/10/23.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;
@interface TCVoipDBManager : NSObject
@property (strong,nonatomic)FMDatabaseQueue * voipQueue;
@property (assign,nonatomic)NSInteger topCount;
+ (instancetype)shareInstance;

// 插入数据
- (BOOL)insertDBWithModel:(id)model;

// 删除数据  删除某个模型对应的数据
- (BOOL)deleteModelToDB:(id)model;

// 根据userid删除所有的会话纪录
- (BOOL)deleteAllRecordeWothUserId:(NSString *)userId;

// 更新数据
- (BOOL)updateDBWithModel:(id)model;

// 查找通话列表所有数据
- (NSArray *)getAllDataFromDb:(NSString *)tableName;

// 查找某张表中userId对应的通话详情
- (id)getDataWithDB:(NSString *)tableName UserId:(NSString *)userId;
@end

