//
//  TCCTCatEyeMonitorVC.m
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/20.
//

#import "TCCTCatEyeMonitorVC.h"
#import "TCCTCatEyeHeader.h"
#import "TCCTCatEyeModel.h"
#import "TCCTCatEyeSetVC.h"
#import "TCCTApiManager.h"
#import "TCCTRecordModel.h"
#import "TCCTRecordCell.h"
#import "TCCTRecordDetailVC.h"

#import "TCCTApiManager.h"

@interface TCCTCatEyeMonitorVC ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    NSInteger _pageNo ;   //页码数
    NSInteger _pageSize;     //行数
}

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *yzxVideoView;         //云之讯视频视图

@property (nonatomic, strong) UIView *frontVideoView;       //云之讯上层其他信息显示视图
@property (nonatomic, strong) UIView *redPointView;         //录像红点
@property (nonatomic, strong) UILabel *timingLabel;         //视频接通时间以及录像时间
@property (nonatomic, strong) UILabel *elecLabel;           //电量值
@property (nonatomic, strong) UIImageView *elecImageView;       //电量标示图
@property (nonatomic, strong) UILabel *timeLabel;       //日期时间
@property (nonatomic, strong) UIView *statusView;       //图片加载状态
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UIView *beforeAnswerView;     //监视前
@property (nonatomic, strong) UIButton *beforeCallBtn;      //监视前呼叫

@property (nonatomic, strong) UIView *afterAnswerView;      //监视后
@property (nonatomic, strong) UIButton *afterSleepBtn;      //监视后拍照
@property (nonatomic, strong) UIButton *afterIntercomBtn;   //监视后对讲
@property (nonatomic, strong) UIButton *afterPhotoBtn;      //监视后拍照
@property (nonatomic, strong) UIButton *afterVideoBtn;      //监视后录像
@property (nonatomic, strong) UIButton *afterMuteBtn;       //监视后禁对方麦

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *recordView;
@property (nonatomic, strong) UILabel *recordTitleLabel;
@property (nonatomic, strong) UILabel *recordContentLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UITableView *recordTableView;

@property (nonatomic, strong) UIView *refreshView;
@property (nonatomic, strong) UIImageView *refreshImageView;
@property (nonatomic, strong) UILabel *refreshLabel;

@property (nonatomic, strong) NSMutableArray *listDataArray;        //列表数据集合
@property (nonatomic, assign) CatEyeRecordType curRecordType;       //当前信息记录类型

@property (strong,nonatomic) UIView *videoLocationView;     //本地视频视图
@property (strong,nonatomic) UIView *videoRemoteView;       //远程视频视图
@property (nonatomic, assign) CatEyeDeviceStatus curVideoStaus;     //猫眼状态
@property (nonatomic, assign) NSInteger cameraTime;         //录像时间

@property (nonatomic, strong) NSTimer *dateTimer;                   //日期定时器
@property (nonatomic, strong) NSTimer *videoPlayBackimer;           //视频播放定时器
@property (nonatomic, strong) NSTimer *videoRecordTimer;            //视频录像定时器
@property (nonatomic, assign) NSInteger videoPlayBackTotal;         //视频播放时间总数
@property (nonatomic, assign) NSInteger videoRecordTotal;           //视频录像时间总数
@property (nonatomic, assign) NSInteger videoTimeType;              //1-视屏播放 2-录像

@property (nonatomic, assign) NSInteger hangupCallType;             //挂断结束方式：1-返回挂断  2-设置挂断  3-其余挂端(默认)
// 用来存放Cell的唯一标示符
@property (nonatomic, strong) NSMutableDictionary *cellDic;

@end

@implementation TCCTCatEyeMonitorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
    self.view.backgroundColor = [UIColor colorWithHexString:Color_bgColor];
    self.navigationItem.title = self.catEyeModel.deviceName?self.catEyeModel.deviceName:@"未知猫眼";
    [self setRightBarButtonWithImageName:@"sm_navSet"];
    [self initThePageLayout];
    
    UITapGestureRecognizer *recordTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordViewChangeClick:)];
    self.recordView.userInteractionEnabled = YES;
    [self.recordView addGestureRecognizer:recordTag];
    
    self.listDataArray = [NSMutableArray array];
    self.cellDic = [NSMutableDictionary dictionary];
    
    //历史信息记录初始化
    _pageNo = 1;
    _pageSize = 10;
    _curRecordType = CatEyeRecordType_File;         //默认为文件类型
    
    [self reloadAwakenCatEyeRequestWithAwakenType:0];
    [self reloadFindRecordListRequest];
    
    //下拉刷新
    self.recordTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->_pageNo = 1;
        [self reloadFindRecordListRequest];
        self.recordTableView.mj_footer.state = MJRefreshStateIdle;
    }];
    //上拉加载
    self.recordTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self->_pageNo  ++;
        [self reloadFindRecordListRequest];
    }];
    
    [self.topView bringSubviewToFront:self.frontVideoView];
    [self.topView bringSubviewToFront:self.statusView];
    [self.bottomView bringSubviewToFront:self.refreshView];
    
    _cameraTime = 10;
    _hangupCallType = 3;
    _curVideoStaus = self.catEyeModel.online.integerValue;
    if (_curVideoStaus == CatEyeDeviceStatus_OFFLINE) {
        [self setVideoStatusType:0];
    }else{
        [self setVideoStatusType:1];
    }
    
    [self showVideoCallView];
    
    //禁止当前页面滑动返回，处理与猫眼通讯情况下
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(TccHeight(220));
    }];
    
    [self.yzxVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.topView);
        make.height.mas_equalTo(TccHeight(180));
    }];
    
    [self.frontVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.topView);
        make.height.mas_equalTo(TccHeight(180));
    }];
    [self.redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.frontVideoView).offset(20);
        make.width.height.mas_equalTo(15);
    }];
    [self.timingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redPointView.mas_right).offset(TccWidth(5));
        make.centerY.equalTo(self.redPointView.mas_centerY);
    }];
    [self.elecImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.frontVideoView).offset(-20);
        make.centerY.equalTo(self.redPointView.mas_centerY);
    }];
    [self.elecLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.elecImageView.mas_left).offset(-TccWidth(5));
        make.centerY.equalTo(self.redPointView.mas_centerY);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.frontVideoView).offset(-20);
    }];
    
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.topView);
        make.height.mas_equalTo(TccHeight(180));
    }];
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.statusView);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusImageView.mas_bottom).offset(TccHeight(10));
        make.centerX.mas_equalTo(self.statusView);
    }];
    
    [self.beforeAnswerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.frontVideoView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.topView);
    }];
    [self.beforeCallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.mas_equalTo(self.beforeAnswerView);
        make.height.mas_equalTo(TccHeight(35));
        make.width.mas_equalTo((kScreenWidth - 100)/ 5);
    }];
    
    [self.afterAnswerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.frontVideoView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.topView);
    }];
    NSArray *afterAnswerArr =@[self.afterSleepBtn,self.afterMuteBtn,self.afterPhotoBtn,self.afterIntercomBtn,self.afterVideoBtn];
    [afterAnswerArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:50 tailSpacing:50];
    [afterAnswerArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.afterAnswerView);
        make.height.mas_equalTo(TccHeight(35));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.bottomView);
        make.height.mas_equalTo(TccHeight(40));
    }];
    [self.recordTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.recordView.mas_left).offset(TccWidth(20));
        make.centerY.mas_equalTo(self.recordView);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.recordView);
        make.right.mas_equalTo(self.recordView.mas_right).offset(-TccWidth(20));
        make.height.mas_equalTo(TccHeight(16));
        make.width.mas_equalTo(TccWidth(14));
    }];
    [self.recordContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightImageView.mas_left).offset(-TccWidth(10));
        make.centerY.mas_equalTo(self.recordView);
    }];
    
    [self.refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.bottomView);
        make.width.mas_equalTo(TccWidth(300));
        make.height.mas_equalTo(TccWidth(200));
    }];
    [self.refreshImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.refreshView);
        make.centerY.mas_equalTo(self.refreshView).offset(-15);
    }];
    [self.refreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.refreshView);
        make.top.mas_equalTo(self.refreshImageView.mas_bottom);
    }];
    
    [self.recordTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.recordView.mas_bottom).offset(TccHeight(2));
        make.left.right.bottom.mas_equalTo(self.bottomView);
    }];
}

#pragma mark - Init Page Layout
- (void)initThePageLayout{
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.yzxVideoView];
    
    [self.topView addSubview:self.frontVideoView];
    [self.frontVideoView addSubview:self.redPointView];
    [self.frontVideoView addSubview:self.timingLabel];
    [self.frontVideoView addSubview:self.elecLabel];
    [self.frontVideoView addSubview:self.elecImageView];
    [self.frontVideoView addSubview:self.timeLabel];
    
    [self.topView addSubview:self.statusView];
    [self.statusView addSubview:self.statusImageView];
    [self.statusView addSubview:self.statusLabel];
    
    [self.topView addSubview:self.beforeAnswerView];
    [self.beforeAnswerView addSubview:self.beforeCallBtn];
    
    [self.topView addSubview:self.afterAnswerView];
    [self.afterAnswerView addSubview:self.afterSleepBtn];
    [self.afterAnswerView addSubview:self.afterIntercomBtn];
    [self.afterAnswerView addSubview:self.afterPhotoBtn];
    [self.afterAnswerView addSubview:self.afterMuteBtn];
    [self.afterAnswerView addSubview:self.afterVideoBtn];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.recordView];
    [self.recordView addSubview:self.recordTitleLabel];
    [self.recordView addSubview:self.recordContentLabel];
    [self.recordView addSubview:self.rightImageView];


    [self.bottomView addSubview:self.refreshView];
    [self.refreshView addSubview:self.refreshImageView];
    [self.refreshView addSubview:self.refreshLabel];
    
    [self.bottomView addSubview:self.recordTableView];
}

#pragma mark - Event Response
- (void)clickLeftBarButtonItem{
    _hangupCallType = 1;
    if (_curVideoStaus == CatEyeDeviceStatus_ONLINE) {
        [self hangupCall];
    }else{
        [super clickLeftBarButtonItem];
    }
}

//历史信息记录跳转
- (void)recordViewChangeClick:(id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择历史记录类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"文件记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self refreshListDataWithRecordType:CatEyeRecordType_File];
        self.recordContentLabel.text = [self getMessageRecordNameWithRecordType:CatEyeRecordType_File];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"通话记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self refreshListDataWithRecordType:CatEyeRecordType_Call];
        self.recordContentLabel.text = [self getMessageRecordNameWithRecordType:CatEyeRecordType_Call];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"报警记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self refreshListDataWithRecordType:CatEyeRecordType_Police];
        self.recordContentLabel.text = [self getMessageRecordNameWithRecordType:CatEyeRecordType_Police];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"人脸识别记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self refreshListDataWithRecordType:CatEyeRecordType_Face];
        self.recordContentLabel.text = [self getMessageRecordNameWithRecordType:CatEyeRecordType_Face];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

//设置
- (void)clickRightBarButtonItem:(id)sender{
    _hangupCallType = 2;
    if (_curVideoStaus == CatEyeDeviceStatus_ONLINE) {
        [self hangupCall];
    }else{
        TCCTCatEyeSetVC *catEyeSetVC = [TCCTCatEyeSetVC new];
        catEyeSetVC.catEyeModel = self.catEyeModel;
        [self.navigationController pushViewController:catEyeSetVC animated:YES];
    }
}

//呼叫
- (void)callBtnClick:(id)sender{
    [self openExternalCallIntercom];
    [MBManager showWaitingWithTitle:@"设备呼叫中..."];
}

//睡眠
- (void)sleepBtnClick:(id)sender{
    //1、关闭对讲
    [self hangupCall];
    _curVideoStaus = CatEyeDeviceStatus_SLEEP;
    
    //透传猫眼休眠
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    [contentDict setObject:@(3) forKey:@"messageType"];
    [contentDict setObject:@(0) forKey:@"deviceType"];
    [contentDict setObject:self.catEyeModel.account forKey:@"fromId"];
    [contentDict setObject:@"" forKey:@"messageContent"];
    [contentDict setObject:@"" forKey:@"deviceNumber"];
    [contentDict setObject:@{} forKey:@"data"];
    
    //    [MBManager showBriefAlert:@"休眠指令发送中"];
    [self unvarnishedTransmissionDataToCatEyeWithContentDict:contentDict andTitleName:@"sleep"];
}

//抓拍
- (void)photoBtnClick:(id)sender{
    //猫眼抓拍操作
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    [contentDict setObject:@(6) forKey:@"messageType"];
    [contentDict setObject:@(0) forKey:@"deviceType"];
    [contentDict setObject:self.catEyeModel.account forKey:@"fromId"];
    [contentDict setObject:@"" forKey:@"messageContent"];
    [contentDict setObject:@"" forKey:@"deviceNumber"];
    [contentDict setObject:@{} forKey:@"data"];
    
    //    [MBManager showBriefAlert:@"抓拍指令发送中"];
    [self unvarnishedTransmissionDataToCatEyeWithContentDict:contentDict andTitleName:@"snap"];
}

//禁麦
- (void)muteBtnClick:(id)sender{
    //猫眼静音操作
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    if (!self.afterMuteBtn.isSelected) { //禁麦
        //        [MBManager showBriefAlert:@"禁麦指令发送中"];
        [contentDict setObject:@(4) forKey:@"messageType"];
    }else{  //开麦
        //        [MBManager showBriefAlert:@"开麦指令发送中"];
        [contentDict setObject:@(5) forKey:@"messageType"];
    }
    [contentDict setObject:@(0) forKey:@"deviceType"];
    [contentDict setObject:self.catEyeModel.account forKey:@"fromId"];
    [contentDict setObject:@"" forKey:@"messageContent"];
    [contentDict setObject:@"" forKey:@"deviceNumber"];
    [contentDict setObject:@{} forKey:@"data"];
    [self unvarnishedTransmissionDataToCatEyeWithContentDict:contentDict andTitleName:@"mute"];
}

//录像
- (void)videoBtnClick:(id)sender{
    //猫眼录像操作
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    [contentDict setObject:@(7) forKey:@"messageType"];
    [contentDict setObject:@(0) forKey:@"deviceType"];
    [contentDict setObject:self.catEyeModel.account forKey:@"fromId"];
    [contentDict setObject:@"" forKey:@"messageContent"];
    [contentDict setObject:@"" forKey:@"deviceNumber"];
    [contentDict setObject:@{} forKey:@"data"];
    
    //    [MBManager showBriefAlert:@"录像指令发送中"];
    [self unvarnishedTransmissionDataToCatEyeWithContentDict:contentDict andTitleName:@"video"];
}

//对讲
- (void)intercomBtnClick:(id)sender{
    self.afterIntercomBtn.selected = !self.afterIntercomBtn.isSelected;
    [self muteWithIsOpen:self.afterIntercomBtn.selected];
    
    if (self.afterIntercomBtn.selected) {
        [self.afterIntercomBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_callMute"] forState:UIControlStateNormal];
        [self.afterIntercomBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_callMutePre"] forState:UIControlStateHighlighted];
    }else{
        [self.afterIntercomBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_callVol"] forState:UIControlStateNormal];
        [self.afterIntercomBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_callVolPre"] forState:UIControlStateHighlighted];
    }
}

//猫眼状态切换
- (void)statusViewClick:(id)sender{
    if (_curVideoStaus == CatEyeDeviceStatus_OFFLINE) {
        [self reloadGetCatEyeRequestWithCatEyeID:self.catEyeModel.id];
        
    }else if (_curVideoStaus == CatEyeDeviceStatus_SLEEP){
        [self reloadAwakenCatEyeRequestWithAwakenType:1];
        
    }
}

//空数据刷新
- (void)refreshViewClick:(id)sender{
    [self reloadFindRecordListRequest];
}

#pragma mark - UITableViewDelegate、UITableViewDataSource
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *rowDict = self.listDataArray[section];
    NSArray *rowArray = [rowDict objectForKey:jsonResult_Data];
    return rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *rowDict = self.listDataArray[indexPath.section];
    NSArray *rowArray = [rowDict objectForKey:jsonResult_Data];
    TCCTRecordModel *model = (TCCTRecordModel *)rowArray[indexPath.row];
    
//    static NSString *cellID = @"TCCTRecordCell";
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [self.cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", @"TCCTRecordCell", [NSString stringWithFormat:@"%@%ld", indexPath,self.curRecordType]];
        [self.cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
    }
    
    TCCTRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TCCTRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setRecordModel:model andRecordType:_curRecordType];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *rowDict = self.listDataArray[indexPath.section];
    NSArray *rowArray = [rowDict objectForKey:jsonResult_Data];
    TCCTRecordModel *model = (TCCTRecordModel *)rowArray[indexPath.row];
    NSArray *listArray = model.catEyeFileList;
    if (listArray.count > 0) {
        //跳转信息记录详情
        TCCTRecordDetailVC *detailVC = [[TCCTRecordDetailVC alloc] init];
        detailVC.recordModel = model;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        [MBManager showBriefAlert:@"暂无记录详情"];
    }
}

//设置分区头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

//设置分区头视图  (自定义分区头 一定要设置分区头高度)
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
    headerview.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 100, 21)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    [headerview addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 120, 12, 100, 21)];
    contentLabel.textAlignment = NSTextAlignmentRight;
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.textColor = [UIColor grayColor];
    [headerview addSubview:contentLabel];
    
    NSDictionary *rowDict = self.listDataArray[section];
    //显示数据
    NSString *dayStr = [rowDict objectForKey:@"day"];
    if (![dayStr isEqualToString:@""]) {
        titleLabel.text = dayStr;
    }else{
        titleLabel.text = [rowDict objectForKey:@"date"];
    }
    contentLabel.text = [rowDict objectForKey:@"weekday"];
    
    return headerview;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

#pragma mark - HTTP请求  唤醒猫眼、获取文件记录、
- (void)reloadFindRecordListRequest{
    [MBManager showLoading];
    [TCCTApiManager getRecordListWithType:_curRecordType andDeviceNum:self.catEyeModel.deviceNum andPageNum:_pageNo andPageSize:_pageSize success:^(id  _Nonnull responseObject) {
        [MBManager hideAlert];
        NSArray *requestDataArr = [NSArray array];
        if (responseObject && ([[responseObject objectForKey:jsonResult_Code] integerValue] == 0)) {
            requestDataArr = [responseObject objectForKey:jsonResult_Data][@"list"];
            if (self->_curRecordType != CatEyeRecordType_All) {   //特定文件数据
                [self processRequestDataArray:requestDataArr];
            }
            if (requestDataArr.count > 0) {
                self.refreshView.hidden = YES;
            }else{
                self.refreshView.hidden = NO;
            }
            [self.recordTableView reloadData];
            
        }else{
            [MBManager showBriefAlert:[responseObject objectForKey:jsonResult_Msg]];
        }
        
        [self stopRefreshing];
        if (requestDataArr.count < self->_pageSize) {
            [self.recordTableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self stopRefreshing];
        [MBManager hideAlert];
        [MBManager showBriefAlert:https_requestTimeout];
    }];
}

//停止刷新
- (void)stopRefreshing{
    if ([self.recordTableView.mj_header isRefreshing]){
        [self.recordTableView.mj_header endRefreshing];
    }
    
    if ([self.recordTableView.mj_footer isRefreshing]){
        [self.recordTableView.mj_footer endRefreshing];
    }
}

//处理请求数据：requestDataArr-请求数据  isAllData-是否请求返回所有文件数据
- (void)processRequestDataArray:(NSArray *)requestDataArr{
    if (_pageNo == 1) {  //下拉刷新数据先移除数据
        [self.listDataArray removeAllObjects];
    }
    
    //数据格式 [{date:20200202,data:[]},{date:20200202,data:[]},...]
    for (NSDictionary *requestDict in requestDataArr) {
        TCCTRecordModel *model = [TCCTRecordModel modelWithJSON:requestDict];
        
        BOOL isHave = NO;   //当前model所属日期是否存在
        if (self.listDataArray.count > 0) {
            for (NSDictionary *listDataDict in self.listDataArray) {
                if ([[listDataDict objectForKey:@"date"] isEqualToString:[self dateWithTimeIntervalString:[self getTimestampFromTimeWithTimeStr:model.recordDate]]]) {
                    isHave = YES;
                    NSMutableArray *modelDataArray = [listDataDict objectForKey:@"data"];
                    [modelDataArray addObject:model];
                }
            }
        }
        if (!isHave) {
            NSMutableDictionary *modelDict = [NSMutableDictionary dictionary];
            [modelDict setObject:[self dateWithTimeIntervalString:[self getTimestampFromTimeWithTimeStr:model.recordDate]] forKey:@"date"];
            [modelDict setObject:[self weekdayWithTimeIntervalString:[self getTimestampFromTimeWithTimeStr:model.recordDate]] forKey:@"weekday"];
            [modelDict setObject:[self distanceTimeWithTimeIntervalString:[self getTimestampFromTimeWithTimeStr:model.recordDate]] forKey:@"day"];
            NSMutableArray *modelDataArray = [NSMutableArray array];
            [modelDataArray addObject:model];
            [modelDict setObject:modelDataArray forKey:@"data"];
            
            [self.listDataArray addObject:modelDict];
        }
    }
    
}

//选择不同文件类型并刷新数据
- (void)refreshListDataWithRecordType:(CatEyeRecordType)recordType{
    if (_curRecordType != recordType) {
        _curRecordType = recordType;
        _pageNo = 1;
        [self.cellDic removeAllObjects];
        [self.listDataArray removeAllObjects];
        [self reloadFindRecordListRequest];
    }
}

//获取文件类型名称
- (NSString *)getMessageRecordNameWithRecordType:(CatEyeRecordType)recordType{
    NSString *messageRecordName = nil;
    switch (recordType) {
        case CatEyeRecordType_File:
        {
            messageRecordName = @"文件记录";
        }
            break;
        case CatEyeRecordType_Call:
        {
            messageRecordName = @"通话记录";
        }
            break;
        case CatEyeRecordType_Police:
        {
            messageRecordName = @"报警记录";
        }
            break;
        case CatEyeRecordType_Face:
        {
            messageRecordName = @"人脸识别记录";
        }
            break;
        default:
            messageRecordName = @"所有记录";
            break;
    }
    return messageRecordName;
}

/// @param awakenType 类型：0-初始化唤醒  1-呼叫前唤醒
- (void)reloadAwakenCatEyeRequestWithAwakenType:(NSInteger)awakenType{
    [MBManager showLoading];
    [TCCTApiManager awakenCatEyeWithDeviceNum:self.catEyeModel.deviceNum success:^(id  _Nonnull responseObject) {
        [MBManager hideAlert];
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:jsonResult_Code] integerValue] == 0) {
            BOOL operateStatus = [[responseObject objectForKey:@"data"] boolValue];
            if (operateStatus) {
                if (awakenType == 1) {
                    [MBManager showWaitingWithTitle:@"设备唤醒中,请稍后"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBManager hideAlert];
                    });
                }
            }else{
                [MBManager showBriefAlert:@"设备唤醒失败,请重试"];
            }
        }else{
            [MBManager showBriefAlert:[responseObject objectForKey:jsonResult_Msg]];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:@"设备响应超时,请稍后重试"];
    }];
}

///获取猫眼
- (void)reloadGetCatEyeRequestWithCatEyeID:(NSString *)catEyeID{
    [MBManager showLoading];
    [TCCTApiManager getCatEyeListWithCatEyeID:catEyeID Success:^(id  _Nonnull responseObject) {
        [MBManager hideAlert];
        if (responseObject && ([[responseObject objectForKey:jsonResult_Code] integerValue] == 0)) {
            TCCTCatEyeModel *model = [TCCTCatEyeModel modelWithJSON:[responseObject objectForKey:jsonResult_Data]];
            self.catEyeModel.electric = model.electric;
            self.catEyeModel.online = model.online;
            self->_curVideoStaus = model.online.intValue;
            if (self->_curVideoStaus == CatEyeDeviceStatus_SLEEP) {
                [self setVideoStatusType:1];
            }
        }else{
            [MBManager showBriefAlert:@"猫眼数据异常"];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:https_requestTimeout];
    }];
}

#pragma mark - Get And Set
- (UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        [_topView setBackgroundColor:[UIColor blackColor]];
    }
    return _topView;
}

- (UIView *)yzxVideoView{
    if (!_yzxVideoView) {
        _yzxVideoView = [UIView new];
    }
    return _yzxVideoView;
}

- (UIView *)frontVideoView{
    if (!_frontVideoView) {
        _frontVideoView = [UIView new];
    }
    return _frontVideoView;
}

- (UIView *)redPointView{
    if (!_redPointView) {
        _redPointView = [UIView new];
        [_redPointView setBackgroundColor:[UIColor redColor]];
        [_redPointView.layer setCornerRadius:7.5];
    }
    return _redPointView;
}

- (UILabel *)timingLabel{
    if (!_timingLabel) {
        _timingLabel = [UILabel new];
        [_timingLabel setText:@"test: 00:01"];
        [_timingLabel setTextColor:[UIColor whiteColor]];
        [_timingLabel setFont:Font_Text_System14];
    }
    return _timingLabel;
}

- (UILabel *)elecLabel{
    if (!_elecLabel) {
        _elecLabel = [UILabel new];
        [_elecLabel setText:@"test: 70%"];
        [_elecLabel setTextAlignment:NSTextAlignmentRight];
        [_elecLabel setTextColor:[UIColor whiteColor]];
        [_elecLabel setFont:Font_Text_System14];
    }
    return _elecLabel;
}

- (UIImageView *)elecImageView{
    if (!_elecImageView) {
        _elecImageView = [UIImageView new];
        [_elecImageView setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_elec"]];
    }
    return _elecImageView;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        [_timeLabel setText:@"test: 2020-01-01 23:59:59"];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        [_timeLabel setTextColor:[UIColor whiteColor]];
        [_timeLabel setFont:Font_Text_System14];
    }
    return _timeLabel;
}

- (UIView *)statusView{
    if (!_statusView) {
        _statusView = [UIView new];
        [_statusView setBackgroundColor:[UIColor blackColor]];
        _statusView.userInteractionEnabled = YES;
        UITapGestureRecognizer *statusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(statusViewClick:)];
        [_statusView addGestureRecognizer:statusTap];
    }
    return _statusView;
}

- (UIImageView *)statusImageView{
    if (!_statusImageView) {
        _statusImageView = [UIImageView new];
        [_statusImageView setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_cameraLoading"]];
    }
    return _statusImageView;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        [_statusLabel setText:@"图像加载中,请稍等..."];
        [_statusLabel setTextColor:[UIColor whiteColor]];
        [_statusLabel setFont:Font_Title_System17];
    }
    return _statusLabel;
}

- (UIView *)beforeAnswerView{
    if (!_beforeAnswerView) {
        _beforeAnswerView = [UIView new];
        [_beforeAnswerView setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _beforeAnswerView;
}

- (UIButton *)beforeCallBtn{
    if (!_beforeCallBtn) {
        _beforeCallBtn = [UIButton new];
        [_beforeCallBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_call"] forState:UIControlStateNormal];
        [_beforeCallBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_callPre"] forState:UIControlStateHighlighted];
        [_beforeCallBtn setTarget:self action:@selector(callBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beforeCallBtn;
}

- (UIView *)afterAnswerView{
    if (!_afterAnswerView) {
        _afterAnswerView = [UIView new];
        [_afterAnswerView setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _afterAnswerView;
}

- (UIButton *)afterSleepBtn{
    if (!_afterSleepBtn) {
        _afterSleepBtn = [UIButton new];
        [_afterSleepBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_sleep"] forState:UIControlStateNormal];
        [_afterSleepBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_sleepPre"] forState:UIControlStateHighlighted];
        [_afterSleepBtn setTarget:self action:@selector(sleepBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _afterSleepBtn;
}

- (UIButton *)afterIntercomBtn{
    if (!_afterIntercomBtn) {
        _afterIntercomBtn = [UIButton new];
        [_afterIntercomBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_callMute"] forState:UIControlStateNormal];
        [_afterIntercomBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_callMutePre"] forState:UIControlStateHighlighted];
        [_afterIntercomBtn setTarget:self action:@selector(intercomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _afterIntercomBtn;
}

- (UIButton *)afterPhotoBtn{
    if (!_afterPhotoBtn) {
        _afterPhotoBtn = [UIButton new];
        [_afterPhotoBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_photoBtn"] forState:UIControlStateNormal];
        [_afterPhotoBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_photoBtnPre"] forState:UIControlStateHighlighted];
        [_afterPhotoBtn setTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _afterPhotoBtn;
}

- (UIButton *)afterMuteBtn{
    if (!_afterMuteBtn) {
        _afterMuteBtn = [UIButton new];
        [_afterMuteBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_vol"] forState:UIControlStateNormal];
        [_afterMuteBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_volPre"] forState:UIControlStateHighlighted];
        [_afterMuteBtn setTarget:self action:@selector(muteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _afterMuteBtn;
}

- (UIButton *)afterVideoBtn{
    if (!_afterVideoBtn) {
        _afterVideoBtn = [UIButton new];
        [_afterVideoBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_video"] forState:UIControlStateNormal];
        [_afterVideoBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_videoPre"] forState:UIControlStateHighlighted];
        [_afterVideoBtn setTarget:self action:@selector(videoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _afterVideoBtn;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
    }
    return _bottomView;
}

- (UIView *)recordView{
    if (!_recordView) {
        _recordView = [UIView new];
    }
    return _recordView;
}

- (UILabel *)recordTitleLabel{
    if (!_recordTitleLabel) {
        _recordTitleLabel = [UILabel new];
        [_recordTitleLabel setText:@"历史信息记录"];
        [_recordTitleLabel setTextColor:[UIColor blackColor]];
        [_recordTitleLabel setFont:Font_Title_System18];
    }
    return _recordTitleLabel;
}

- (UILabel *)recordContentLabel{
    if (!_recordContentLabel) {
        _recordContentLabel = [UILabel new];
        [_recordContentLabel setText:@"文件记录"];
        [_recordContentLabel setTextAlignment:NSTextAlignmentRight];
        [_recordContentLabel setTextColor:[UIColor grayColor]];
        [_recordContentLabel setFont:Font_Title_System17];
    }
    return _recordContentLabel;
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
        [_rightImageView setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_cellRight"]];
    }
    return _rightImageView;
}

- (UIView *)refreshView{
    if (!_refreshView) {
        _refreshView = [UIView new];
        UITapGestureRecognizer *refreshTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshViewClick:)];
        _refreshView.userInteractionEnabled = YES;
        [_refreshView addGestureRecognizer:refreshTap];
    }
    return _refreshView;
}

- (UIImageView *)refreshImageView{
    if (!_refreshImageView) {
        _refreshImageView = [UIImageView new];
        [_refreshImageView setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_empty"]];
    }
    return _refreshImageView;
}

- (UILabel *)refreshLabel{
    if (!_refreshLabel) {
        _refreshLabel = [UILabel new];
        [_refreshLabel setText:@"暂无数据，请点击重试"];
        [_refreshLabel setTextAlignment:NSTextAlignmentCenter];
        [_refreshLabel setTextColor:[UIColor blackColor]];
        [_refreshLabel setFont:Font_Title_System17];
    }
    return _refreshLabel;
}

- (UITableView *)recordTableView{
    if (!_recordTableView) {
        _recordTableView = [UITableView new];
        _recordTableView.dataSource = self;
        _recordTableView.delegate = self;
        _recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _recordTableView;
}

#pragma mark - 辅助逻辑处理代码
- (NSString *)getTimestampFromTimeWithTimeStr:(NSString *)timeStr{
    // 时间转时间戳的方法:
    NSDate *strDate = [NSDate dateWithString:timeStr format:@"YYYY-MM-dd HH:mm:ss"];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[strDate timeIntervalSince1970]];
    return timeSp;
}

//时间戳转换日期年月月对象
- (NSString *)dateWithTimeIntervalString:(NSString *)timeString{
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[timeString doubleValue]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:nd];
    return dateString;
}

//时间戳转换日期时分秒对象
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString{
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[timeString doubleValue]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:nd];
    return dateString;
}

//时间戳转星期对象
- (NSString*)weekdayWithTimeIntervalString:(NSString *)timeString{
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[timeString doubleValue]];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六",  nil];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:nd];
    return [weekdays objectAtIndex:theComponents.weekday];
}

//时间戳转今天或明天
- (NSString *)distanceTimeWithTimeIntervalString:(NSString *)timeString{
    double beTime = [timeString doubleValue] / 1000;
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    //    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    //    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        return @"今天";
    }
    if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            return @"昨天";
        }
    }
    return @"";
}

#pragma mark - 视屏上层状态设置
//设置视频监听状态：0-离线状态、1-睡眠状态、2-在线状态、
- (void)setVideoStatusType:(NSInteger)type{
    switch (type) {
        case 0:
        {
            [self isHiddenfrontVideoView:YES andElectricValue:0];
            [self isHiddenBeforeAnswerView:YES andIsHiddenAfterAnswerView:YES];
            [self isHiddenStatusView:NO];
        }
            break;
        case 1:
        {
            [self isHiddenfrontVideoView:YES andElectricValue:0];
            [self isHiddenBeforeAnswerView:NO andIsHiddenAfterAnswerView:YES];
            [self isHiddenStatusView:NO];
        }
            break;
        case 2:
        {
            [self isHiddenfrontVideoView:NO andElectricValue:self.catEyeModel.electric];
            [self isHiddenBeforeAnswerView:YES andIsHiddenAfterAnswerView:NO];
            [self isHiddenStatusView:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 接通后视频 -上层- 视图数据变化显示、相关定时器设置显示
- (void)isHiddenStatusView:(BOOL)isHidden{
    self.statusView.hidden = isHidden;
    if (!isHidden) {
        if (_curVideoStaus == CatEyeDeviceStatus_OFFLINE) {
            self.statusLabel.text = @"设备已离线,点击刷新";
            [self.statusImageView setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_offline"]];
        }else if (_curVideoStaus == CatEyeDeviceStatus_SLEEP) {
            self.statusLabel.text = @"设备休眠中,点击唤醒";
            [self.statusImageView setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_sleepShow"]];
        }else{}
    }
}

//是否隐藏视频功能区视图
- (void)isHiddenBeforeAnswerView:(BOOL)isBeforeHidden andIsHiddenAfterAnswerView:(BOOL)isAfterHidden{
    self.beforeAnswerView.hidden = isBeforeHidden;
    self.afterAnswerView.hidden = isAfterHidden;
}

//是否隐藏视频上层数据视图
- (void)isHiddenfrontVideoView:(BOOL)isHidden andElectricValue:(NSInteger)electricValue{
    self.frontVideoView.hidden = isHidden;
    if (isHidden) {     //隐藏
        [self stopDateViewTimer];
        [self stopVideoRecordTimer];
        [self stopVideoPlaybackTimer];
        
        _videoTimeType = 1;
        _videoRecordTotal = 0;
    }else{
        //设置日期时间、监视播放时间、电量
        [self startDateViewTimer];
        
        [self isStartVideoPlay:NO];
        
        self.elecLabel.text = [NSString stringWithFormat:@"%ld %%",(long)electricValue];
        if (electricValue < 20) {
            self.elecImageView.image = [TCCloudTalkingImageTool getToolsBundleImage:@"sm_elecLow"];
        }else{
            self.elecImageView.image = [TCCloudTalkingImageTool getToolsBundleImage:@"sm_elec"];
        }
    }
}

//是否开启视频录像，开启即开始录像
- (void)isStartVideoPlay:(BOOL)isStart{
    if (isStart) {
        _videoTimeType = 2;
        self.redPointView.hidden = NO;
        [self startVideoRecordTimer];
    }else{
        _videoTimeType = 1;
        self.redPointView.hidden = YES;
        [self stopVideoRecordTimer];
        [self startVideoPlaybackTimer];
    }
}

//日期视图定时器
- (void)startDateViewTimer{
    if (!self.dateTimer) {
        self.dateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dateViewTimerClick) userInfo:nil repeats:YES];
        [self.dateTimer fire];
    }
}

- (void)stopDateViewTimer{
    if (self.dateTimer) {
        [self.dateTimer invalidate];
        self.dateTimer = nil;
    }
}

- (void)dateViewTimerClick{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    [dataFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    self.timeLabel.text = [dataFormatter stringFromDate:currentDate];
}

//视频播放定时器
- (void)startVideoPlaybackTimer{
    _videoPlayBackTotal = 0;
    if (!self.videoPlayBackimer) {
        self.videoPlayBackimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(videoPlayBackimerClick) userInfo:nil repeats:YES];
        [self.videoPlayBackimer fire];
    }
}

- (void)stopVideoPlaybackTimer{
    if (self.videoPlayBackimer) {
        [self.videoPlayBackimer invalidate];
        self.videoPlayBackimer = nil;
    }
}

- (void)videoPlayBackimerClick{
    _videoPlayBackTotal ++;
    if (_videoTimeType == 1) {
        self.timingLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)_videoPlayBackTotal/60,(long)_videoPlayBackTotal%60];
    }
}

//录像定时器
- (void)startVideoRecordTimer{
    _videoRecordTotal = 0;
    if (!self.videoRecordTimer) {
        self.videoRecordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(videoRecordTimerClick) userInfo:nil repeats:YES];
        [self.videoRecordTimer fire];
    }
}

- (void)stopVideoRecordTimer{
    if (self.videoRecordTimer) {
        [self.videoRecordTimer invalidate];
        self.videoRecordTimer = nil;
    }
}

- (void)videoRecordTimerClick{
    _videoRecordTotal ++;
    if (_videoTimeType == 2) {
        self.timingLabel.text = [NSString stringWithFormat:@"正在录像%02ld秒",(long)_videoRecordTotal];
    }
    
    //录像已完成
    if (_videoRecordTotal >= 30) {
        self.afterVideoBtn.userInteractionEnabled = YES;
        [self stopVideoRecordTimer];
        _videoTimeType = 1;
        self.redPointView.hidden = YES;
    }
}

#pragma mark - 云之讯
/**
 *  显示通话视频图像
 */
- (void)showVideoCallView{
    //本地视频窗口和远程视频窗口
    self.videoRemoteView = [[UCSFuncEngine getInstance] allocCameraViewWithFrame:CGRectMake(0, 0, kMainScreenWidth,TccHeight(180))];
    self.videoRemoteView.backgroundColor = [UIColor clearColor];
    [self.yzxVideoView addSubview:self.videoRemoteView];
    
    self.videoLocationView = [[UCSFuncEngine getInstance] allocCameraViewWithFrame:CGRectMake(Adaptation(0), Adaptation(0), Adaptation(0), Adaptation(1))];
    self.videoLocationView.backgroundColor = [UIColor clearColor];
    [self.yzxVideoView addSubview:self.videoLocationView];
    
//    // 设置通话过程中自动感应，黑屏，避免耳朵按到其他按键
//    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
//    // 设置不自动进入锁屏待机状态
//    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    // 需要在通话中成为firstResponder，否则切换回前台后，听不到声音
    [self becomeFirstResponder];
    //初始化视频界面
    [[UCSFuncEngine getInstance] initCameraConfig:self.videoLocationView withRemoteVideoView:self.videoRemoteView withRender:RENDER_ALLFULLSCREEN];
    
    //增加通知
    [self addNotification];
}

-(void)addNotification{
    //注册耳机监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headPhoneChangeNotification:) name:UCSNotiHeadPhone object:nil];
    //踢线通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KickOffNotification:) name:TCPKickOffNotification object:nil];
}

//移除通知
-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCSNotiHeadPhone object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TCPKickOffNotification object:nil];
}

// 需要在通话中成为firstResponder，否则切换回前台后，听不到声音
- (BOOL)canBecomeFirstResponder {
    return YES;
}

//自定义视频编码和解码参数
- (void)setVideoEnc{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    UCSVideoEncAttr *vEncAttr = [[UCSVideoEncAttr alloc] init] ;
    if([defaults boolForKey:USE720P]){
        //720P自定义视频编码参数如下：
        vEncAttr.uStartBitrate = [defaults integerForKey:UCS_StartBitrate] ? [defaults integerForKey:UCS_StartBitrate] : 400;
        vEncAttr.uMaxBitrate = [defaults integerForKey:UCS_uMaxBitrate]?[defaults integerForKey:UCS_uMaxBitrate] : 1000;
        vEncAttr.uMinBitrate = [defaults integerForKey:UCS_uMinBitrate] ?[defaults integerForKey:UCS_uMinBitrate] : 300;
    }else{
        //非720P自定义视频编码参数如下：
        vEncAttr.uStartBitrate = [defaults integerForKey:UCS_StartBitrate] ? [defaults integerForKey:UCS_StartBitrate] : 300;
        vEncAttr.uMaxBitrate = [defaults integerForKey:UCS_uMaxBitrate]?[defaults integerForKey:UCS_uMaxBitrate] : 900;
        vEncAttr.uMinBitrate = [defaults integerForKey:UCS_uMinBitrate] ?[defaults integerForKey:UCS_uMinBitrate] : 150;
    }
    //------------------------最大码率、最小码率、起始码率 参数设置------------------------//
    [[UCSFuncEngine getInstance] setVideoAttr:vEncAttr];
    //设置视频来电时是否支持预览。
    [[UCSFuncEngine getInstance] setCameraPreViewStatu:YES];
}

//自定义视频分级编码参数
- (void)setHierEncArrt{
    UCSHierEncAttr * hierEncAttr = [[UCSHierEncAttr alloc]init];
    hierEncAttr.low_complexity_w240 = 2;
    hierEncAttr.low_complexity_w360 = 1;
    hierEncAttr.low_complexity_w480 = 1;
    hierEncAttr.low_complexity_w720 = 0;
    hierEncAttr.low_bitrate_w240 =  200;
    hierEncAttr.low_bitrate_w360 =  -1;
    hierEncAttr.low_bitrate_w480 =  -1;
    hierEncAttr.low_bitrate_w720 =  -1;
    hierEncAttr.low_framerate_w240 = 12;
    hierEncAttr.low_framerate_w360 = 14;
    hierEncAttr.low_framerate_w480 = -1;
    hierEncAttr.low_framerate_w720 = 14;
    
    hierEncAttr.medium_complexity_w240 = 3;
    hierEncAttr.medium_complexity_w360 = 2;
    hierEncAttr.medium_complexity_w480 = 1;
    hierEncAttr.medium_complexity_w720 = 0;
    hierEncAttr.medium_bitrate_w240 = 200;
    hierEncAttr.medium_bitrate_w360 = 400;
    hierEncAttr.medium_bitrate_w480 = -1;
    hierEncAttr.medium_bitrate_w720  = -1;
    hierEncAttr.medium_framerate_w240 = 14;
    hierEncAttr.medium_framerate_w360 = 14;
    hierEncAttr.medium_framerate_w480 = 13;
    hierEncAttr.medium_framerate_w720 = 14;
    
    hierEncAttr.high_complexity_w240 = 3;
    hierEncAttr.high_complexity_w360 = 2;
    hierEncAttr.high_complexity_w480 = 2;
    hierEncAttr.high_complexity_w720 = 1;
    hierEncAttr.high_bitrate_w240 = 200;
    hierEncAttr.high_bitrate_w360 = 400;
    hierEncAttr.high_bitrate_w480 = -1;
    hierEncAttr.high_bitrate_w720 = -1;
    hierEncAttr.high_framerate_w240 = 14;
    hierEncAttr.high_framerate_w360 = 15;
    hierEncAttr.high_framerate_w480 = 15;
    hierEncAttr.high_framerate_w720 = 14;
    
    [[UCSFuncEngine getInstance] setHierEncAttr:hierEncAttr];
}

- (void)headPhoneChangeNotification:(NSNotification *)notification{
    NSNumber * i = notification.object;
    if (i.intValue) {   //有耳机,关闭免提
        [[UCSFuncEngine getInstance] setSpeakerphone:NO];
    }else{  //无耳机,开启免提
        [[UCSFuncEngine getInstance] setSpeakerphone:YES];
    }
}

-(void)KickOffNotification:(NSNotification *)notification{
    [self hangupCall];
}

//接听呼叫
- (void)answerCall{
    [[UCSFuncEngine getInstance] answer:self.catEyeModel.account];
}

//挂断通话
- (void)hangupCall{
    [[UCSFuncEngine getInstance] hangUp:self.catEyeModel.account];
}

//免提事件
- (void)handfreeWithIsOpen:(BOOL)isOpen{
    //免提关：NO 免提开：YES
    BOOL curOpenValue = [[UCSFuncEngine getInstance] isSpeakerphoneOn];
    if ([self hasHeadset]) {
        //处于耳机模式,不允许设置免提,直接关闭免提
        [[UCSFuncEngine getInstance] setSpeakerphone:NO];
    }else{
        if (curOpenValue == isOpen){
        }else{
            [[UCSFuncEngine getInstance] setSpeakerphone:isOpen];
        }
    }
}

//静音事件
- (void)muteWithIsOpen:(BOOL)isOpen{
    BOOL curOpenValue = [[UCSFuncEngine getInstance] isMicMute];
    if (curOpenValue == isOpen) {
    }else{
        [[UCSFuncEngine getInstance] setMicMute:isOpen];
    }
}

/**
 *  判断是否有耳机
 *
 *  @return 判断是否有耳机
 */
- (BOOL)hasHeadset {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    AVAudioSessionRouteDescription *currentRoute = [audioSession currentRoute];
    for (AVAudioSessionPortDescription *output in currentRoute.outputs) {
        if ([[output portType] isEqualToString:AVAudioSessionPortHeadphones]) {
            return YES;
        }
    }
    return NO;
}

-(void)responseVoipManagerStatus:(UCSCallStatus)event callID:(NSString*)callid data:(UCSReason *)data withVideoflag:(int)videoflag{
    
    switch (event)
    {
        case UCSCallStatus_Alerting://对方振铃
        {
            //设置视频分级编码，需在通话接通前调用
            [self setHierEncArrt];
        }
            break;
        case UCSCallStatus_Answered://对方应答
        {
            [MBManager hideAlert];
            [MBManager showBriefAlert:@"视频同振通话中"];
            //自定义视频编码和解码参数
            [self setVideoEnc];
            //设置免提
            [self handfreeWithIsOpen:YES];
            //闭麦
            [self muteWithIsOpen:YES];
            
            _curVideoStaus = CatEyeDeviceStatus_ONLINE;
            [self  setVideoStatusType:2];
        }
            break;
        case UCSCallStatus_Released://通话释放
        {
            [MBManager hideAlert];
            [MBManager showBriefAlert:@"通话已结束"];
            _curVideoStaus = CatEyeDeviceStatus_SLEEP;
            [self  setVideoStatusType:1];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self->_hangupCallType == 1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else if(self->_hangupCallType == 2){
                    TCCTCatEyeSetVC *catEyeSetVC = [TCCTCatEyeSetVC new];
                    catEyeSetVC.catEyeModel = self.catEyeModel;
                    [self.navigationController pushViewController:catEyeSetVC animated:YES];
                }
            });
        }
            break;
        case UCSCallStatus_Failed://呼叫失败
        case UCSCallStatus_Transfered://呼叫已转移
        case UCSCallStatus_Pasused://呼叫保持
        default:
        {
            [MBManager hideAlert];
            [MBManager showBriefAlert:@"呼叫超时,请重试"];
            _curVideoStaus = CatEyeDeviceStatus_SLEEP;
            [self  setVideoStatusType:1];
        }
            
            break;
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//开启主动外呼对讲
- (void)openExternalCallIntercom{
    NSString *callNumber = self.catEyeModel.account;
    if ([[UCSTcpClient sharedTcpClientManager] login_isConnected]) {
        //主动呼叫
        [[UCSVOIPViewEngine getInstance] makingCatEyeCallViewCallNumber:callNumber callType:UCSCallType_VideoPhone callName:callNumber];
    }else{
        TCHousesInfoModel *houesModel = [[TCPersonalInfoModel shareInstance] getHousesInfoModel];
        [[UCSTcpClient sharedTcpClientManager] login_connect:houesModel.intercomToken  success:^(NSString *userId) {
            [SVProgressHUD dismiss];
            //主动呼叫
            [[UCSVOIPViewEngine getInstance] makingCatEyeCallViewCallNumber:callNumber callType:UCSCallType_VideoPhone callName:callNumber];
        } failure:^(UCSError *error) {
            [MBManager showBriefAlert:@"呼叫失败,请稍后再试"];
        }];
    }
}

//透传数据给猫眼
- (void)unvarnishedTransmissionDataToCatEyeWithContentDict:(NSDictionary *)contentDict andTitleName:(NSString *)titleName{
    NSString *UMessage = [self convertToJsonData:contentDict];
    
    UCSTCPTransParentRequest *request = [UCSTCPTransParentRequest initWithCmdString:UMessage receiveId:self.catEyeModel.account];
    
    [[UCSTcpClient sharedTcpClientManager] sendTransParentData:request success:^(UCSTCPTransParentRequest *request) {
        if ([titleName isEqualToString:@"mute"]) {
            self.afterMuteBtn.selected = !self.afterMuteBtn.selected;
            if (self.afterMuteBtn.selected) {
                [self.afterMuteBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_mute"] forState:UIControlStateNormal];
                [self.afterMuteBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_mutePre"] forState:UIControlStateHighlighted];
            }else{
                [self.afterMuteBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_vol"] forState:UIControlStateNormal];
                [self.afterMuteBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_volPre"] forState:UIControlStateHighlighted];
            }
        }
        
        if ([titleName isEqualToString:@"video"]) {
            [self isStartVideoPlay:YES];
            self.afterVideoBtn.userInteractionEnabled = NO;
        }
        
        if (![titleName isEqualToString:@"sleep"]) {
            [MBManager showBriefAlert:@"指令发送成功"];
        }
    } failure:^(UCSTCPTransParentRequest *request, UCSError *error) {
        NSLog(@"发送失败：%@ackData-->%@",error.errorDescription,request.ackData);
        [MBManager showBriefAlert:@"指令发送失败"];
    }];
}

-(NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    NSLog(@"mutStr====> %@",mutStr);
    return mutStr;
}

@end
