//
//  TCMissedCallViewController.m
//  TCCloudTalking
//
//  Created by Huang ZhiBin on 2019/11/13.
//

#import "TCMissedCallViewController.h"
#import "Header.h"
#import "UnlockRecordTableViewCell.h"
#import "TCUnlcokRecordModel.h"
#import "FMDBBaseTool.h"
#import "TCCallRecordsModel.h"

static NSString *const UnlockRecordID  =@"UnlockRecordID";
@interface TCMissedCallViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray *dataSurce;
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation TCMissedCallViewController
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
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;

        // 删除单元格分隔线的一个小技巧
        self.tableView.tableFooterView = [UIView new];
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
    //初始化tabbleView
    [self tableView];
    [self getDataSuorce];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRecordDataSuorce) name:UCSNotiRefreshCallList object:nil];
}

#pragma mark 刷新界面
- (void)getDataSuorce{
    
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *ary = [[FMDBBaseTool shareInstance] getDataWithDB:@"TCCallRecordsModel"];

        [self.dataSurce removeAllObjects];
        for (int i = 0; i < ary.count; i++) {
            TCCallRecordsModel * model = ary[i];
            if ([model.callStatus intValue] == 2) {
                debugLog(@"%@----",model);
                [self.dataSurce addObject:model];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            debugLog(@"%@",self.dataSurce);
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

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_empty"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *text = @"亲 你还有没有未接记录哦~";

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
