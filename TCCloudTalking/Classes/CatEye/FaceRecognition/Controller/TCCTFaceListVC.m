//
//  TCCTFaceListVC.m
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/18.
//

#import "TCCTFaceListVC.h"
#import "TCCTCatEyeModel.h"
#import "TCCTFaceModel.h"

#import "TCCTCatEyeHeader.h"
#import "TCCTApiManager.h"

#import "TCCTFaceCell.h"
#import "TCCTAddFaceOneVC.h"
#import "TCCTAddFaceTwoVC.h"

@interface TCCTFaceListVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *memberTableView;
@property (nonatomic, strong) UIView *addMemberView;
@property (nonatomic, strong) UIButton *addMemberBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TCCTFaceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
    self.view.backgroundColor = [UIColor colorWithHexString:Color_bgColor];
    self.navigationItem.title = @"家庭成员";
    self.dataArray = [NSMutableArray array];
    [self initThePageLayout];
    
    [self reloadFindFaceListRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFindFaceListRequest) name:Noti_RefreshFaceList object:nil];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.addMemberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(TccHeight(100));
    }];
    [self.addMemberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(TccWidth(20));
        make.centerX.mas_equalTo(self.addMemberView);
        make.centerY.mas_equalTo(self.addMemberView);
        make.height.mas_equalTo(TccHeight(40));
    }];
    
    [self.memberTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.addMemberView.mas_top);
    }];
}

#pragma mark - Init Page Layout
- (void)initThePageLayout{
    [self.view addSubview:self.addMemberView];
    [self.addMemberView addSubview:self.addMemberBtn];
    [self.view addSubview:self.memberTableView];
    
    self.memberTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadFindFaceListRequest];
    }];
}

#pragma mark - Event Response
//添加家庭成员
- (void)addMemberBtnClick:(id)sender{
    TCCTAddFaceOneVC *addFaceOneVC = [[TCCTAddFaceOneVC alloc] init];
    addFaceOneVC.pushType = AddFacePushType_Add;
    addFaceOneVC.catEyeModel = self.catEyeModel;
    [self.navigationController pushViewController:addFaceOneVC animated:YES];
}

#pragma mark - HTTPS 获取人脸列表
///获取人脸列表
- (void)reloadFindFaceListRequest{
    [MBManager showLoading];
    [TCCTApiManager getFaceListWithDeviceNum:self.catEyeModel.deviceNum success:^(id  _Nonnull responseObject) {
        [MBManager hideAlert];
        if (responseObject && ([[responseObject objectForKey:jsonResult_Code] integerValue] == 0)) {
            [MBManager showBriefAlert:@"获取人脸列表成功"];
            [self.dataArray removeAllObjects];
            NSArray *requestDataArray = [responseObject objectForKey:jsonResult_Data];
            for (NSDictionary *dict in requestDataArray) {
                TCCTFaceModel *model = [TCCTFaceModel modelWithJSON:dict];
                [self.dataArray addObject:model];
            }
            [self.memberTableView reloadData];
        }else{
            [MBManager showBriefAlert:[responseObject objectForKey:jsonResult_Msg]];
        }
        [self stopRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [self stopRefreshing];
        [MBManager hideAlert];
        [MBManager showBriefAlert:https_requestTimeout];
    }];
}

#pragma mark - UITableViewDelegate、UITableViewDataSource
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"TCCTFaceCell";
    TCCTFaceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TCCTFaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TCCTFaceModel *faceModel = (TCCTFaceModel *)self.dataArray[indexPath.row];
    [cell setFaceModel:faceModel];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCCTFaceModel *selectModel = (TCCTFaceModel *)self.dataArray[indexPath.row];
    
    TCCTAddFaceTwoVC *addFaceTwoVC = [[TCCTAddFaceTwoVC alloc] init];
    addFaceTwoVC.pushType = AddFacePushType_Edit;
    addFaceTwoVC.curCatEyeModel = self.catEyeModel;
    addFaceTwoVC.curFaceModel = selectModel;
    [self.navigationController pushViewController:addFaceTwoVC animated:YES];
}

//设置分区头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
//设置分区头视图  (自定义分区头 一定要设置分区头高度)
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

#pragma mark - DZNEmptyDataSetSource,DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_empty"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -32.0f;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *text = @"暂无数据，请点击重试";
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    return attStr;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    [self reloadFindFaceListRequest];
}

#pragma mark - Get And Set
- (UITableView *)memberTableView{
    if (!_memberTableView) {
        _memberTableView = [UITableView new];
        _memberTableView.dataSource = self;
        _memberTableView.delegate = self;
        _memberTableView.emptyDataSetSource = self;
        _memberTableView.emptyDataSetDelegate = self;
        _memberTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _memberTableView;
}

- (UIView *)addMemberView{
    if (!_addMemberView) {
        _addMemberView = [UIView new];
        [_addMemberView setBackgroundColor:[UIColor whiteColor]];
    }
    return _addMemberView;
}

- (UIButton *)addMemberBtn{
    if (!_addMemberBtn) {
        _addMemberBtn = [UIButton new];
        [_addMemberBtn setBackgroundColor:[UIColor colorWithHexString:Color_globalColor]];
        [_addMemberBtn setTitle:@"添加家庭成员" forState:UIControlStateNormal];
        [_addMemberBtn.layer setCornerRadius:Fillet_CornerRadius];
        [_addMemberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addMemberBtn setTarget:self action:@selector(addMemberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addMemberBtn;
}

//停止刷新
- (void)stopRefreshing{
    if ([self.memberTableView.mj_header isRefreshing]){
        [self.memberTableView.mj_header endRefreshing];
    }
    
    if ([self.memberTableView.mj_footer isRefreshing]){
        [self.memberTableView.mj_footer endRefreshing];
    }
}

@end
