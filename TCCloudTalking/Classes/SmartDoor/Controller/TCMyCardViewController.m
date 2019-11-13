//
//  TCMyCardViewController.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/12.
//

#import "TCMyCardViewController.h"
#import "MyCardTableViewCell.h"
#import "TCMyCardModel.h"
#import "Header.h"
static NSString *const MyCardCellID  =@"MyCardCellID";
@interface TCMyCardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *DataSource;

@end

@implementation TCMyCardViewController
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
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的卡";
    
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化tabbleView
    [self tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;//self.DataSource.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 185;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCardCellID];
    if (cell == nil) {
        cell = [MyCardTableViewCell viewFromBundleXib];
    }
    return cell;
    
}


@end
