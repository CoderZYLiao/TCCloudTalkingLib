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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TCNaviH, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-TCNaviH) style:UITableViewStyleGrouped];
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
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB"];
    //初始化tabbleView
    [self tableView];
    
    //获取我的卡列表
    [self GetMyCardsDate];
}
- (void)loadNewData
{
    [self GetMyCardsDate];
    
}

- (void)GetMyCardsDate
{
    [SVProgressHUD showWithStatus:@""];
    [TCCloudTalkRequestTool GetMyCardslistSuccess:^(id  _Nonnull result) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        debugLog(@"%@-----卡列表",result);
        if ([result[@"code"] intValue] == 0) {
            self.DataSource = [TCMyCardModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
 
            [self.tableView reloadData];
        }else
        {
            if (result[@"message"]) {
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
            }
            
        }
    } faile:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.DataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCMyCardModel *CardModel = self.DataSource[indexPath.item];
    MyCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCardCellID];
    if (cell == nil) {
        cell = [MyCardTableViewCell viewFromBundleXib];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger rows = indexPath.section%4;
    switch (rows) {
        case 0:
            cell.CardBackImageView.image = [TCCloudTalkingImageTool getToolsBundleImage:@"bg_卡片1"];
            break;
            
        case 1:
            cell.CardBackImageView.image = [TCCloudTalkingImageTool getToolsBundleImage:@"bg_卡片2"];
            break;
        case 2:
            cell.CardBackImageView.image = [TCCloudTalkingImageTool getToolsBundleImage:@"bg_卡片3"];
            break;
        case 3:
            cell.CardBackImageView.image = [TCCloudTalkingImageTool getToolsBundleImage:@"bg_卡片4"];
            break;
        default:
            cell.CardBackImageView.image = [TCCloudTalkingImageTool getToolsBundleImage:@"bg_卡片1"];
            break;
            break;
    }
    cell.CardItems = CardModel;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 10.0f;
    }else
    {
       return 0.01f;//section头部高度
    }
    
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
    
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 7;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
