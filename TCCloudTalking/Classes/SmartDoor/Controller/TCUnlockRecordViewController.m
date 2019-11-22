//
//  TCUnlockRecordViewController.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/12.
//

#import "TCUnlockRecordViewController.h"
#import "UnlockRecordTableViewCell.h"
#import "TCUnlcokRecordModel.h"
#import "Header.h"

static NSString *const UnlockRecordID  =@"UnlockRecordID";
@interface TCUnlockRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *DataSource;

@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, assign) NSInteger totalPage;
@end

@implementation TCUnlockRecordViewController
- (NSMutableArray *)DataSource
{
    if (!_DataSource) {
        _DataSource = [NSMutableArray array];
    }
    return _DataSource;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TCNaviH, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-TCNaviH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        // 注册cell(Pods的注册方式)
        [_tableView registerClass:[UnlockRecordTableViewCell class] forCellReuseIdentifier:UnlockRecordID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开锁记录";
    
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化tabbleView
    [self tableView];
    //获取开锁记录
    [self getDataSoure];
}

- (void)getDataSoure
{
    [SVProgressHUD showWithStatus:@""];
    [TCCloudTalkRequestTool GetMyCommunityWithPageIndex:@"0" pageSize:@"20" month:[self getCurrentMonth] Success:^(id  _Nonnull result) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        debugLog(@"%@-----开锁记录",result);
        if ([result[@"code"] intValue] == 0) {
            self.DataSource = [TCUnlcokRecordModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            
            [self.tableView reloadData];
        }else
        {
            if (result[@"message"]) {
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
            }
            
        }
    } faile:^(NSError * _Nonnull error) {
        
    }];
}

- (void)loadNewData
{
    self.currentPage = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.DataSource.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 72;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCUnlcokRecordModel *model = self.DataSource[indexPath.row];
    UnlockRecordTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:UnlockRecordID];
    if (cell == nil) {
        cell = [UnlockRecordTableViewCell viewFromBundleXib];
    }
    cell.RecordModel = model;
    return cell;
    
}

- (NSString *)getCurrentMonth
{
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|  NSCalendarUnitMinute|NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags fromDate:dt];
    
    return [NSString stringWithFormat:@"%ld-%ld",comp.year,comp.month];
}



@end
