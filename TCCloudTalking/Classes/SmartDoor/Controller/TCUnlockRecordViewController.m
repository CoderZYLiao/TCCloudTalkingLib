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
//    [self getDataSoure];
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

    UnlockRecordTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:UnlockRecordID];
    if (cell == nil) {
        cell = [UnlockRecordTableViewCell viewFromBundleXib];
    }
    return cell;

}

@end
