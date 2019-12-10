//
//  TCCloudTalkingTool.m
//  AFNetworking
//
//  Created by Mumu on 2019/11/21.
//

#import "TCCloudTalkingTool.h"
#import "Header.h"

static inline int min(int a, int b) {
    return a < b ? a : b;
}

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

//获取门口机数组
+(NSArray *)getMachineDataArray
{
    //读取本地json数据
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/MyMachineJson.json"];//获取json文件保存的路径
    NSData *data = [NSData dataWithContentsOfFile:filePath];//获取指定路径的data文件
    if (data) {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]; //获取到json文件的跟数据（字典）
        NSArray *arr = [json objectForKey:@"data"];//获取指定key值的value，是一个数组
        return arr;
    }else
    {
        return 0;
    }
    
}

+(NSDictionary *)getMatchMachineDataArrayWithResult:(NSString *)Result
{
    //读取本地json数据
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/MyMachineJson.json"];//获取json文件保存的路径
    NSData *data = [NSData dataWithContentsOfFile:filePath];//获取指定路径的data文件
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]; //获取到json文件的跟数据（字典）
    NSArray *arr = [json objectForKey:@"data"];//获取指定key值的value，是一个数组
    float max_number = 0;
    int max_index = 0;
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dic = arr[i];
        //取最大值和最大值的对应下标
        float a = [self likePercentByCompareOriginText:[dic objectForKey:@"name"] targetText:Result];
        debugLog(@"%f-----相似度计算",a);
        if (a > max_number) {
            max_index = i;
        }
        max_number = a>max_number?a:max_number;
    }
    
    return arr[max_index];
}

+(float)likePercentByCompareOriginText:(NSString *)originText targetText:(NSString *)targetText{
    
    //length
    int n = (int)originText.length;
    int m = (int)targetText.length;
    if (n == 0 || m == 0) {
        return 0.0;
    }
    
    //Construct a matrix, need C99 support
    int N = n+1;
    int **matrix;
    matrix = (int **)malloc(sizeof(int *)*N);
    
    int M = m+1;
    for (int i = 0; i < N; i++) {
        matrix[i] = (int *)malloc(sizeof(int)*M);
    }
    
    for (int i = 0; i<N; i++) {
        for (int j=0; j<M; j++) {
            matrix[i][j]=0;
        }
    }
    
    for(int i=1; i<=n; i++) {
        matrix[i][0]=i;
    }
    for(int i=1; i<=m; i++) {
        matrix[0][i]=i;
    }
    for(int i=1;i<=n;i++)
    {
        unichar si = [originText characterAtIndex:i-1];
        for(int j=1;j<=m;j++)
        {
            unichar dj = [targetText characterAtIndex:j-1];
            int cost;
            if(si==dj){
                cost=0;
            }
            else{
                cost=1;
            }
            const int above = matrix[i-1][j]+1;
            const int left = matrix[i][j-1]+1;
            const int diag = matrix[i-1][j-1]+cost;
            matrix[i][j] = min(above, min(left,diag));
        }
    }
    return 100.0 - 100.0*matrix[n][m]/MAX(m,n);
}

//根据对讲账号获取门口机机身号
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
            NSLog(@"%@",[dic objectForKey:@"id"]);//遍历数组
            str =   [dic objectForKey:@"id"];
        }
    }
    return str;
}

//根据对讲账号获取门口机名称
+ (NSString *)getMachineNameWithVoipNo:(NSString *)VoipNo
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
