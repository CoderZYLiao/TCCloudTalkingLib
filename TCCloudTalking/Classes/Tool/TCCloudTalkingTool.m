//
//  TCCloudTalkingTool.m
//  AFNetworking
//
//  Created by Mumu on 2019/11/21.
//

#import "TCCloudTalkingTool.h"
#import "Header.h"

@implementation TCCloudTalkingTool


static TCCloudTalkingTool *hanle= nil;
static dispatch_once_t predicate;

+ (instancetype)share{
    
    dispatch_once(&predicate, ^{
        hanle = [[self alloc] init];
    });
    
    
    return  hanle;
}

- (NSString *)phoneNumber
{
    TCUserModel *userModel = [[TCPersonalInfoModel shareInstance] getUserModel];
    return userModel.phoneNumber;
}

+ (void)saveUserMachineList:(id )jsonstr
{
    //第一步.设置json文件的保存路径
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/MyMachineJson.json"];
    
    NSLog(@"%@====filePath",filePath);
    
    //第二步.封包数据
    NSData *json_data = [NSJSONSerialization dataWithJSONObject:jsonstr options:NSJSONWritingPrettyPrinted error:nil];
    
    //第三步.写入数据
    [json_data writeToFile:filePath atomically:YES];
}


+ (void)saveUserMachineList
{
    TCUserModel *userModel = [[TCPersonalInfoModel shareInstance] getUserModel];
    [TCCloudTalkRequestTool GetMyDoorMachinelistWithCoid:userModel.defaultCommunity.communityId Success:^(id  _Nonnull result) {
        [SVProgressHUD dismiss];
        debugLog(@"%@-----门口机列表",result);
        if ([result[@"code"] intValue] == 0) {
            [self saveUserMachineList:result];
        }
    } faile:^(NSError * _Nonnull error) {
        
    }];
}


+ (NSString *)getMachineNumberWithVoipNo:(NSString *)VoipNo
{
    //读取本地json数据
    NSString *str = [[NSString alloc] init];
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/MyMachineJson.json"];//获取json文件保存的路径
    NSData *data = [NSData dataWithContentsOfFile:filePath];//获取指定路径的data文件
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]; //获取到json文件的跟数据（字典）
    NSArray *arr = [json objectForKey:@"data"];//获取指定key值的value，是一个数组
    
    for (NSDictionary *dic in arr) {
        
        if ([[dic objectForKey:@"intercomUserId"] isEqualToString:VoipNo]) {
            NSLog(@"%@",[dic objectForKey:@"name"]);//遍历数组
            str =   [dic objectForKey:@"name"];
        }
    }
    return str;
}


//时间戳变为格式时间
+ (NSString *)ConvertStrToTime:(NSString *)timeStr
{
    long long time=[timeStr longLongValue];
    //    如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
    //    long long time=[timeStr longLongValue] / 1000;
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString*timeString=[formatter stringFromDate:date];
    
    return timeString;
    
}
@end
