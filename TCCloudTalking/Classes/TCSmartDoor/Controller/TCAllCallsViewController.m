//
//  TCAllCallsViewController.m
//  TCCloudTalking
//
//  Created by Huang ZhiBin on 2019/11/13.
//

#import "TCAllCallsViewController.h"
#import "TCVoipDBManager.h"
#import "Header.h"
#import "UnlockRecordTableViewCell.h"
#import "TCUnlcokRecordModel.h"
#import "FMDBBaseTool.h"
#import "TCCallRecordsModel.h"

static NSString *const UnlockRecordID  =@"UnlockRecordID";
@interface TCAllCallsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSurce;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation TCAllCallsViewController
- (NSMutableArray *)dataSurce
{
    if (!_dataSurce) {
        _dataSurce = [NSMutableArray array];
    }
    return _dataSurce;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TCNaviH+50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-TCNaviH-50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)refreshRecordDataSuorce
{
    [self getDataSuorce];
}
-(void)loadNewData
{
    [self getDataSuorce];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化tabbleView
    [self tableView];
    [self getDataSuorce];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRecordDataSuorce) name:UCSNotiRefreshCallList object:nil];
}

#pragma mark 刷新界面
- (void)getDataSuorce{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.dataSurce = [[FMDBBaseTool shareInstance] getDataWithDB:@"TCCallRecordsModel"];
        dispatch_async(dispatch_get_main_queue(), ^{
            //            debugLog(@"%@",callList);
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        });
    });
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSurce.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 72;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    TCUnlcokRecordModel *model = self.dataSurce[indexPath.row];
    TCCallRecordsModel *model = self.dataSurce[indexPath.row];
    UnlockRecordTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:UnlockRecordID];
    if (cell == nil) {
        cell = [UnlockRecordTableViewCell viewFromBundleXib];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.callRecordModel = model;
    return cell;
    
}

@end
