//
//  FMDBBaseTool.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/21.
//

#import "FMDBBaseTool.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import <objc/runtime.h>
#import "Header.h"
#import "TCCallRecordsModel.h"


#define TCCloudTalk_DB_NAME @"TCCloudTalk.sqlite3"
#define TCCloudTalk_Machine_LIST @"TCDoorMachineModel"  // 门口机表
#define TCCloudTalk_CALL_RECORD @"TCCallRecordsModel" // 通话记录表
@implementation FMDBBaseTool

+ (instancetype)shareInstance
{
    static FMDBBaseTool * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FMDBBaseTool alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    
    return self;
}

- (NSString *)pathForUserId:(NSString *)userId {
    
    if (!userId || [userId isEqualToString:@""]) {
        userId = @"0";
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath=[documentsDirectory stringByAppendingPathComponent:userId];
    BOOL isDirectory = TRUE;
    if (![fileManager fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:TRUE attributes:nil error:nil];
    }
    return filePath;
}

- (FMDatabaseQueue *)baseToolQueue
{
    if (_baseToolQueue == nil) {
        TCUserModel *userModel = [[TCPersonalInfoModel shareInstance] getUserModel];
        NSString * userId = userModel.phoneNumber;
        NSString * filepath = [[self pathForUserId:userId] stringByAppendingPathComponent:TCCloudTalk_DB_NAME];
        debugLog(@"fileoath is %@",filepath);
        _baseToolQueue = [[FMDatabaseQueue alloc] initWithPath:filepath];
        [_baseToolQueue inDatabase:^(FMDatabase *db) {
            
            // 检查表是否存在 不存在则创建
            if (![db tableExists:TCCloudTalk_Machine_LIST]) {
                NSString * callListSql1 = [NSString stringWithFormat:@"create table if not exists %@ ",TCCloudTalk_Machine_LIST];
                NSArray * propertyList = [self getPropertyList:TCCloudTalk_Machine_LIST];
                NSMutableString * callListSql2 = [NSMutableString string];
                for ( int i = 0; i < propertyList.count; i++) {
                    (i == 0)?[callListSql2 appendFormat:@"%@ text",propertyList[i]]:[callListSql2 appendFormat:@",%@ text",propertyList[i]];
                }
                NSString * callListSpl = [NSString stringWithFormat:@"%@(%@)",callListSql1,callListSql2];
                // 创建对应的表
                if (![db executeUpdate:callListSpl]) {
                    debugLog(@">>>>>>>creat %@ table error ",TCCloudTalk_Machine_LIST);
                }
            }
            
            // 检查表是否存在 不存在则创建
            if (![db tableExists:TCCloudTalk_CALL_RECORD]) {
                NSString * callRecordsSql1 = [NSString stringWithFormat:@"create table if not exists %@ ",TCCloudTalk_CALL_RECORD];
                NSArray * propertyList = [self getPropertyList:TCCloudTalk_CALL_RECORD];
                NSMutableString * callRecordsSql2 = [NSMutableString string];
                for ( int i = 0; i < propertyList.count; i++) {
                    (i == 0)?[callRecordsSql2 appendFormat:@"%@ text",propertyList[i]]:[callRecordsSql2 appendFormat:@",%@ text",propertyList[i]];
                }
                NSString * callRecordsSql = [NSString stringWithFormat:@"%@(%@)",callRecordsSql1,callRecordsSql2];
                // 创建对应的表
                if (![db executeUpdate:callRecordsSql]) {
                    debugLog(@">>>>>>>>>creat %@ table error ",TCCloudTalk_CALL_RECORD);
                }
            }
        }];
    }
    
    return _baseToolQueue;
}

// 获取表名对应的模型的所有成员属性
- (NSMutableArray *)getPropertyList:(NSString *)tableName {
    unsigned int count;
    // Ivar：模型对应的成员变量名 成员变量类型
    Ivar * vars = class_copyIvarList(NSClassFromString(tableName), &count);
    NSMutableArray * propertyArr = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        Ivar var = vars[i];
        [propertyArr addObject:[NSString stringWithUTF8String:ivar_getName(var)]];
    }
    return propertyArr;
}

- (BOOL)insertDBWithModel:(id)model
{
    __block BOOL result;
    // 获取表名
    NSString * className = NSStringFromClass(object_getClass(model));
    // 查找数据库中的数据条数，如果大于100条 则删除最后一条
    //    NSArray * allArray = [self getAllDataFromDb:className];
    //    if (allArray.count >= 140) {
    //        id m = allArray.lastObject;
    //        [self deleteWithModelTime:m];
    //    }
    NSArray * propertyList = [self getPropertyList:className];
    NSString * sql1 = [NSString stringWithFormat:@"insert into %@",className];
    NSMutableString * key = [NSMutableString string]; //
    NSMutableString * value = [NSMutableString string];
    NSMutableArray * argumentsArr = [NSMutableArray array]; // 保存所有参数的值的数组
    for (int i = 0; i < propertyList.count; i++) {
        (i == 0)?[key appendFormat:@"%@",propertyList[i]]:[key appendFormat:@",%@",propertyList[i]];
        (i == 0)?[value appendString:@"?"]:[value appendString:@",?"];
        // 模型里面每一个属性的值
        [argumentsArr addObject:[model valueForKey:propertyList[i]]];
    }
    NSString * sql = [NSString stringWithFormat:@"%@ (%@) values (%@)",sql1,key,value];
    debugLog(@">>>>>>>>>插入数据库sql is %@",sql);
    [self.baseToolQueue inDatabase:^(FMDatabase *db) {
        if (![db executeUpdate:sql withArgumentsInArray:argumentsArr]) {
            result = NO;
            debugLog(@">>>>>>>insert error %@",className);
        }
    }];
    [self.baseToolQueue close];
    return result;
}

- (BOOL)updateDBWithModel:(id)model
{
    __block BOOL result;
    NSString * className = NSStringFromClass(object_getClass(model));
    NSArray * propertyList = [self getPropertyList:className];
    NSString * sql1 = [NSString stringWithFormat:@"update %@ set ",className];
    NSMutableString * key = [NSMutableString string];
    NSMutableArray * argumentsArr = [NSMutableArray array];
    for (int i = 0; i < propertyList.count; i++) {
        (i == 0)?[key appendFormat:@"%@=?",propertyList[i]]:[key appendFormat:@",%@=?",propertyList[i]];
        [argumentsArr addObject:[model valueForKey:propertyList[i]]];
    }
    // 参数部分还缺少 where 字段N=?
    [argumentsArr addObject:[model valueForKey:propertyList[0]]];
    // update %@ set 字段1=?,字段2=?,... where 字段1=?
    NSString * sql = [NSString stringWithFormat:@"%@%@ where %@=?",sql1,key,propertyList[0]];
    debugLog(@">>>>>>>>>>>更新数据库sql is %@",sql);
    [self.baseToolQueue inDatabase:^(FMDatabase *db) {
        if (![db executeUpdate:sql withArgumentsInArray:argumentsArr]) {
            debugLog(@">>>>>>update error %@",className);
            result = NO;
        }
    }];
    [self.baseToolQueue close];
    return result;
}

- (id)getDataWithDB:(NSString *)tableName
{
    NSArray * propertyList = [self getPropertyList:tableName];
    NSString * sql = [NSString stringWithFormat:@"select * from %@",tableName];
    __block NSMutableArray * allArray = [NSMutableArray array];
    debugLog(@"%@",propertyList[0]);
    [self.baseToolQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:sql];
//        debugLog(@"%@",[NSString stringWithFormat:sql]);
        while ([set next]) {
            __block id obj = [[NSClassFromString(tableName) alloc] init];
            for (int i = 0; i < propertyList.count; i++) {
                [obj setValue:[set stringForColumn:propertyList[i]] forKey:propertyList[i]];
            }
            [allArray addObject:obj];
        }
        [set close];
    }];
    [self.baseToolQueue close];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:NO];
    NSArray *descriptoArray = [NSArray arrayWithObjects:descriptor,nil];
    NSArray *array = [allArray sortedArrayUsingDescriptors:descriptoArray];
    [allArray removeAllObjects];
    [allArray addObjectsFromArray:array];
    if (allArray.count > 100) {
        for (int i = 100; i < allArray.count; i++) {
            TCCallRecordsModel * model = allArray[i];
            [self deleteWithModelTime:model];
        }
        NSRange range ;
        range.location = 100;
        range.length = allArray.count - 100;
        [allArray removeObjectsInRange:range];
        
    }
    return allArray;
}

// 删除某个表的一条数据
- (BOOL)deleteModelToDB:(id)model{
    __block BOOL result;
    NSString * className = [NSString stringWithUTF8String:object_getClassName(model)];
    NSArray * propertyList = [self getPropertyList:className];
    NSString * sql = [NSString stringWithFormat:@"delete from %@ where %@=?",className,propertyList[0]];
    [_baseToolQueue inDatabase:^(FMDatabase *db) {
        
        result =[db executeUpdate:sql,[model valueForKey:propertyList[0]]];
        
    }];
    if (result) {
        [self deleteAllRecordeWothUserId:[model valueForKey:propertyList[0]]];
    }
    return result;
}

// 根据时间删除某个表的一条数据
- (BOOL)deleteWithModelTime:(id)model{
    __block BOOL result;
    NSString * className = [NSString stringWithUTF8String:object_getClassName(model)];
    NSString * sql = [NSString stringWithFormat:@"delete from %@ where _time=?",className];
    [_baseToolQueue inDatabase:^(FMDatabase *db) {
        
        result =[db executeUpdate:sql,[model valueForKey:@"time"]];
        
    }];
    return result;
}

// 根据userid删除所有的会话纪录
- (BOOL)deleteAllRecordeWothUserId:(NSString *)userId{
    __block BOOL result;
    NSString * sql = [NSString stringWithFormat:@"delete from TCCallRecordsModel where _userId=?"];
    [_baseToolQueue inDatabase:^(FMDatabase *db) {
        
        result =[db executeUpdate:sql,userId];
        
    }];
    return result;
}
@end
