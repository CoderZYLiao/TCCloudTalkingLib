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
#import "TCPickerView.h"

static NSString *const UnlockRecordID  =@"UnlockRecordID";
@interface TCUnlockRecordViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *DataSource;
@property (strong, nonatomic) TCPickerView *PickerView;
@property(nonatomic, assign) int currentPage;
@property(nonatomic, assign) int totalPage;

@property (nonatomic, strong) NSString *currentMonth;
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
        _tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        // 注册cell(Pods的注册方式)
//        [_tableView registerClass:[UnlockRecordTableViewCell class] forCellReuseIdentifier:UnlockRecordID];
        
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;

        // 删除单元格分隔线的一个小技巧
        self.tableView.tableFooterView = [UIView new];
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
    
    [self.tableView.mj_header beginRefreshing];
    
    [self RightItem];
    
    self.currentMonth = [self getCurrentMonth];
    self.PickerView = [[TCPickerView alloc]init];
    
}

- (void)RightItem
{
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithImage:[[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_option"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarItem)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)clickRightBarItem
{
    NSArray *dateSouce = @[[self beforeDate:0],[self beforeDate:-1],[self beforeDate:-2]];
    self.PickerView.dataSource = [dateSouce copy];
    self.PickerView.pickerTitle = @"选择月份";
    for (NSInteger i=0; i<dateSouce.count; i++) {

        if ([self.currentMonth isEqualToString:dateSouce[i]]) {
            self.PickerView.defaultmodel = dateSouce[i];
        }
    }
    __weak typeof(self) weakSelf = self;
           weakSelf.PickerView.valueDidSelect = ^(NSString *value){
               if (value) {
                   NSLog(@"---%@",value);
                   self.currentMonth = value;
                   [self.tableView.mj_header beginRefreshing];
               }
               
           };
    
    [self.PickerView show];
}

- (void)loadMoreData
{
    if (self.tableView.mj_header.isRefreshing) {
        return;
    }
    if (self.currentPage + 1 > self.totalPage) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }

    NSString *PageIndex = [NSString stringWithFormat:@"%i",self.currentPage+1];
    [TCCloudTalkRequestTool GetMyCommunityWithPageIndex:PageIndex pageSize:@"20" month:self.currentMonth Success:^(id  _Nonnull result) {

        debugLog(@"%@-----开锁记录",result);
        if ([result[@"code"] intValue] == 0) {
            NSArray *dataArray = result[@"data"][@"dataArray"];
            self.currentPage =  [result[@"data"][@"pageIndex"] intValue];
            int pageSize = [result[@"data"][@"pageSize"] intValue];
            int totalCount = [result[@"data"][@"totalCount"] intValue];
            self.totalPage =  ((totalCount + pageSize - 1)/pageSize);
            NSArray *array = [TCUnlcokRecordModel mj_objectArrayWithKeyValuesArray:dataArray];
            [self.DataSource addObjectsFromArray:array];
            [self.tableView reloadData];
            
        }else
        {
            if (result[@"message"]) {
                [MBManager showBriefAlert:result[@"message"]];
            }
            
        }
        [self.tableView.mj_footer resetNoMoreData];
    } faile:^(NSError * _Nonnull error) {
        [self.tableView.mj_footer resetNoMoreData];
    }];
}

- (void)loadNewData
{
    self.currentPage = 0;
    //获取开锁记录
    [self getDataSoure];
}

- (void)getDataSoure
{
    [MBManager showLoading];
    [TCCloudTalkRequestTool GetMyCommunityWithPageIndex:@"0" pageSize:@"20" month:self.currentMonth Success:^(id  _Nonnull result) {
        [MBManager hideAlert];
        [self.tableView.mj_header endRefreshing];
        debugLog(@"%@-----开锁记录",result);
        if ([result[@"code"] intValue] == 0) {
            NSArray *array = result[@"data"][@"dataArray"];
            self.currentPage =  [result[@"data"][@"pageIndex"] intValue];
            int pageSize = [result[@"data"][@"pageSize"] intValue];
            int totalCount = [result[@"data"][@"totalCount"] intValue];
            self.totalPage =  ((totalCount + pageSize - 1)/pageSize);
            [self.DataSource removeAllObjects];
            self.DataSource = [TCUnlcokRecordModel mj_objectArrayWithKeyValuesArray:array];
            
            [self.tableView reloadData];
        }else
        {
            if (result[@"message"]) {
                [MBManager showBriefAlert:result[@"message"]];
                
            }
            
        }
    } faile:^(NSError * _Nonnull error) {
        
    }];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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




- (NSString *)beforeDate:(NSInteger)n {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *nowDateStr = [formatter stringFromDate:currentDate];
    NSLog(@"当前日期：%@",nowDateStr);
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:n];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    NSString *beforeDateStr = [formatter stringFromDate:newdate];
    
    return beforeDateStr;
}


#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_empty"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *text = @"亲 你还有没有开锁记录哦~";

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    // 设置所有字体大小为 #15
    [attStr addAttribute:NSFontAttributeName
                   value:[UIFont systemFontOfSize:15.0]
                   range:NSMakeRange(0, text.length)];
    // 设置所有字体颜色为浅灰色
    [attStr addAttribute:NSForegroundColorAttributeName
                   value:[UIColor colorWithHexString:@"#4073F2"]
                   range:NSMakeRange(0, text.length)];
    // 设置指定4个字体为蓝色
//    [attStr addAttribute:NSForegroundColorAttributeName
//                   value:[UIColor colorWithHexString:@"#007EE5"]
//                   range:NSMakeRange(7, 4)];
    return attStr;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -70.0f;
}

#pragma mark - DZNEmptyDataSetDelegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // button clicked...
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    self.tableView.contentOffset = CGPointZero;
}
@end
