//
//  TCCTCatEyeCall.m
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/20.
//

#import "TCCTCatEyeCall.h"
#import "TCCTCatEyeHeader.h"
#import "TCCTCatEyeModel.h"
#import "TCCTCatEyeAccountManager.h"
#import "TCCTApiManager.h"

@interface TCCTCatEyeCall ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UILabel *navTitleLabel;
@property (nonatomic, strong) UIButton *navRightBtn;
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

@property (nonatomic, strong) UIView *beforeAnswerView;     //接听前
@property (nonatomic, strong) UIButton *beforePhotoBtn;     //接听前拍照
@property (nonatomic, strong) UIButton *beforeVideoBtn;     //接听后录像

@property (nonatomic, strong) UIView *afterAnswerView;      //接听后
@property (nonatomic, strong) UIButton *afterPhotoBtn;      //接听后拍照
@property (nonatomic, strong) UIButton *afterVideoBtn;      //接听后录像
@property (nonatomic, strong) UIButton *afterMuteBtn;       //接听后禁对方麦

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *countdownLabel;      //倒计时
@property (nonatomic, strong) UIButton *answerBtn;
@property (nonatomic, strong) UIButton *dropCenterBtn;
@property (nonatomic, strong) UIButton *dropRightBtn;

@property (strong,nonatomic) UIView *videoLocationView;     //本地视频视图
@property (strong,nonatomic) UIView *videoRemoteView;       //远程视频视图
@property (nonatomic, assign) BOOL isCallOnline;            //是否有通话
@property (nonatomic, assign) NSInteger cameraTime;         //录像时间

@property (nonatomic, strong) TCCTCatEyeModel *curCatEyeModel;
@property (nonatomic, assign) CatEyeCallStatus callStatus;      //猫眼通话状态

@property (nonatomic, strong) NSTimer *dateTimer;                   //日期定时器
@property (nonatomic, strong) NSTimer *videoPlayBackimer;           //视频播放定时器
@property (nonatomic, strong) NSTimer *videoRecordTimer;            //视频录像定时器
@property (nonatomic, assign) NSInteger videoPlayBackTotal;         //视频播放时间总数
@property (nonatomic, assign) NSInteger videoRecordTotal;           //视频录像时间总数
@property (nonatomic, assign) NSInteger videoTimeType;              //1-视屏播放 2-录像

@property (nonatomic, assign) NSInteger callTimerValue;             //被呼叫倒计时总数
@property (nonatomic, assign) NSInteger onlineTimerValue;           //通话倒计时总数
@property (nonatomic, strong) NSTimer *callTimer;                   //被呼叫定时器
@property (nonatomic, strong) NSTimer *onlineTimer;                 //通话定时器

@end

@implementation TCCTCatEyeCall

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self initThePageLayout];
    [self.topView bringSubviewToFront:self.frontVideoView];
    [self.frontVideoView bringSubviewToFront:self.statusView];
    
    //接听前猫眼功能区显示
    [self setVideoStatusType:1];
    
    _videoTimeType = 1;
    _callTimerValue = 30;
    _onlineTimerValue = 180;
    
    
    //根据对讲账号拿到当前猫眼model
    BOOL isHaveCallID = NO;
    NSDictionary *dict = [TCCTCatEyeAccountManager tcSelectCatEyeModelByCatEyeAccount:self.callID];
    if (dict) {
        TCCTCatEyeModel *model = [TCCTCatEyeModel modelWithJSON:dict];
        if ([model.account isEqualToString:self.callID]) {
            isHaveCallID = YES;
            self.curCatEyeModel = model;
        }
    }
    
    if (!isHaveCallID) {
        self.navTitleLabel.text = @"来自未知设备的呼叫";
        [MBManager showBriefAlert:@"本地缓存数据异常"];
        _callStatus = CatEyeCallStatus_NULL;
        
    }else{
        _callStatus = CatEyeCallStatus_Call;
        self.navTitleLabel.text = [NSString stringWithFormat:@"来自%@的呼叫",self.curCatEyeModel.deviceName];
        
        [self setVideoStatusType:2];
        //初始化云之讯
        [self showVideoCallView];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // 设置通话过程中自动感应，黑屏，避免耳朵按到其他按键
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    // 设置不自动进入锁屏待机状态
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    // 需要在通话中成为firstResponder，否则切换回前台后，听不到声音
    [self resignFirstResponder];
}

- (void)dealloc{
    [self removeNotification];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(TCCNaviH);
    }];
    [self.navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.navView.mas_bottom);
        make.centerX.mas_equalTo(self.navView);
        make.height.mas_equalTo(40);
    }];
    [self.navRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.navView.mas_right).offset(-TccWidth(20));
        make.centerY.mas_equalTo(self.navTitleLabel.mas_centerY);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(TccHeight(220));
    }];
    [self.yzxVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.topView);
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
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    [self.countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomView).offset(TccHeight(50));
        make.centerX.mas_equalTo(self.bottomView);
        make.height.mas_equalTo(TccHeight(40));
    }];
    NSArray *bottomBtnArr = @[self.answerBtn,self.dropCenterBtn,self.dropRightBtn];
    [bottomBtnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:50 tailSpacing:50];
    [bottomBtnArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.countdownLabel.mas_bottom).offset(TccHeight(50));
        make.height.mas_equalTo(self.answerBtn.mas_width).multipliedBy(1);
        
        make.width.height.mas_equalTo(self.bottomView).priorityLow();
        make.width.height.lessThanOrEqualTo(self.bottomView);
    }];
    
    [self.beforeAnswerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.frontVideoView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.topView);
    }];
    NSArray *beforeAnswerArr = @[self.beforePhotoBtn,self.beforeVideoBtn];
    [beforeAnswerArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:50 tailSpacing:50];
    [beforeAnswerArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.beforeAnswerView);
        make.height.mas_equalTo(TccHeight(45));
    }];
    
    [self.afterAnswerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.frontVideoView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.topView);
    }];
    NSArray *afterAnswerArr =@[self.afterPhotoBtn,self.afterMuteBtn,self.afterVideoBtn];
    [afterAnswerArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:50 tailSpacing:50];
    [afterAnswerArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.afterAnswerView);
        make.height.mas_equalTo(TccHeight(45));
    }];
}

#pragma mark - Init Page Layout
- (void)initThePageLayout{
    
    [self.view addSubview:self.navView];
    [self.navView addSubview:self.navTitleLabel];
    [self.navView addSubview:self.navRightBtn];
    
    [self.view addSubview:self.topView];
    
    [self.topView addSubview:self.yzxVideoView];
    
    [self.topView addSubview:self.frontVideoView];
    [self.frontVideoView addSubview:self.redPointView];
    [self.frontVideoView addSubview:self.timingLabel];
    [self.frontVideoView addSubview:self.elecLabel];
    [self.frontVideoView addSubview:self.elecImageView];
    [self.frontVideoView addSubview:self.timeLabel];
    
    [self.frontVideoView addSubview:self.statusView];
    [self.statusView addSubview:self.statusImageView];
    [self.statusView addSubview:self.statusLabel];
    
    [self.topView addSubview:self.beforeAnswerView];
    [self.beforeAnswerView addSubview:self.beforePhotoBtn];
    [self.beforeAnswerView addSubview:self.beforeVideoBtn];
    
    [self.topView addSubview:self.afterAnswerView];
    [self.afterAnswerView addSubview:self.afterPhotoBtn];
    [self.afterAnswerView addSubview:self.afterMuteBtn];
    [self.afterAnswerView addSubview:self.afterVideoBtn];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.countdownLabel];
    [self.bottomView addSubview:self.answerBtn];
    [self.bottomView addSubview:self.dropCenterBtn];
    [self.bottomView addSubview:self.dropRightBtn];
}

#pragma mark - Event Response
//右侧关闭按钮
- (void)navRightBtnClick:(id)sender{
    if (_callStatus == CatEyeCallStatus_NULL) {
        [self dismissAndReleaseCurView];
    }else{
        [self hangupCall];
    }
}

//接听
- (void)answerBtnClick:(id)sender{
    [self answerCall];
}

//挂断
- (void)dropBtnClick:(id)sender{
    [self hangupCall];
}

//抓拍
- (void)photoBtnClick:(id)sender{
    //猫眼抓拍操作
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    [contentDict setObject:@(6) forKey:@"messageType"];
    [contentDict setObject:@(0) forKey:@"deviceType"];
    [contentDict setObject:self.curCatEyeModel.account forKey:@"fromId"];
    [contentDict setObject:@"" forKey:@"messageContent"];
    [contentDict setObject:@"" forKey:@"deviceNumber"];
    [contentDict setObject:@{} forKey:@"data"];
    
    //    [MBManager showBriefAlert:@"抓拍指令发送中"];
    [self unvarnishedTransmissionDataToCatEyeWithContentDict:contentDict andTitleName:@"snap"];
}

//禁麦(对方)
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
    [contentDict setObject:self.curCatEyeModel.account forKey:@"fromId"];
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
    [contentDict setObject:self.curCatEyeModel.account forKey:@"fromId"];
    [contentDict setObject:@"" forKey:@"messageContent"];
    [contentDict setObject:@"" forKey:@"deviceNumber"];
    [contentDict setObject:@{} forKey:@"data"];
    
    //    [MBManager showBriefAlert:@"录像指令发送中"];
    [self unvarnishedTransmissionDataToCatEyeWithContentDict:contentDict andTitleName:@"video"];
}

#pragma mark - Get And Set
- (UIView *)navView{
    if (!_navView) {
        _navView = [UIView new];
    }
    return _navView;
}

- (UILabel *)navTitleLabel{
    if (!_navTitleLabel) {
        _navTitleLabel = [UILabel new];
        [_navRightBtn setTitle:@"猫眼呼叫中" forState:UIControlStateNormal];
        [_navTitleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [_navTitleLabel setTextColor:[UIColor whiteColor]];
        [_navTitleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _navTitleLabel;
}

- (UIButton *)navRightBtn{
    if (!_navRightBtn) {
        _navRightBtn = [UIButton new];
        [_navRightBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_navClose"] forState:UIControlStateNormal];
        [_navRightBtn addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navRightBtn;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
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

- (UIButton *)beforePhotoBtn{
    if (!_beforePhotoBtn) {
        _beforePhotoBtn = [UIButton new];
        [_beforePhotoBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_photoBtn"] forState:UIControlStateNormal];
        [_beforePhotoBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_photoBtnPre"] forState:UIControlStateHighlighted];
        [_beforePhotoBtn setTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beforePhotoBtn;
}

- (UIButton *)beforeVideoBtn{
    if (!_beforeVideoBtn) {
        _beforeVideoBtn = [UIButton new];
        [_beforeVideoBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_video"] forState:UIControlStateNormal];
        [_beforeVideoBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_videoPre"] forState:UIControlStateHighlighted];
        [_beforeVideoBtn setTarget:self action:@selector(videoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beforeVideoBtn;
}

- (UIView *)afterAnswerView{
    if (!_afterAnswerView) {
        _afterAnswerView = [UIView new];
        [_afterAnswerView setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _afterAnswerView;
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

- (UILabel *)countdownLabel{
    if (!_countdownLabel) {
        _countdownLabel = [UILabel new];
        [_countdownLabel setText:@"03:00"];
        [_countdownLabel setTextColor:[UIColor whiteColor]];
        [_countdownLabel setFont:[UIFont boldSystemFontOfSize:40]];
    }
    return _countdownLabel;
}

- (UIButton *)answerBtn{
    if (!_answerBtn) {
        _answerBtn = [UIButton new];
        [_answerBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_answer"] forState:UIControlStateNormal];
        [_answerBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_answerPre"] forState:UIControlStateHighlighted];
        [_answerBtn setTarget:self action:@selector(answerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _answerBtn;
}

- (UIButton *)dropRightBtn{
    if (!_dropRightBtn) {
        _dropRightBtn = [UIButton new];
        [_dropRightBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_drop"] forState:UIControlStateNormal];
        [_dropRightBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_dropPre"] forState:UIControlStateHighlighted];
        [_dropRightBtn setTarget:self action:@selector(dropBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dropRightBtn;
}

- (UIButton *)dropCenterBtn{
    if (!_dropCenterBtn) {
        _dropCenterBtn = [UIButton new];
        [_dropCenterBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_drop"] forState:UIControlStateNormal];
        [_dropCenterBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_dropPre"] forState:UIControlStateHighlighted];
        [_dropCenterBtn setTarget:self action:@selector(dropBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dropCenterBtn;
}

#pragma mark - 视屏上层和底层状态设置
//设置视频监听状态：1-开始启动状态、2-被呼叫中状态、3-通话中状态、4-被挂断的状态
- (void)setVideoStatusType:(NSInteger)type{
    switch (type) {
        case 1:
        case 4:
        {
            [self isHiddenfrontVideoView:YES andElectricValue:0];
            [self isHiddenBeforeAnswerView:YES andIsHiddenAfterAnswerView:YES];
            [self isHiddenBottomView:YES andIsCall:YES];
        }
            break;
        case 2:
        {
            [self isHiddenfrontVideoView:YES andElectricValue:0];
            [self isHiddenBeforeAnswerView:NO andIsHiddenAfterAnswerView:YES];
            [self isHiddenBottomView:NO andIsCall:YES];
        }
            break;
        case 3:
        {
            [self isHiddenfrontVideoView:NO andElectricValue:self.curCatEyeModel.electric];
            [self isHiddenBeforeAnswerView:YES andIsHiddenAfterAnswerView:NO];
            [self isHiddenBottomView:NO andIsCall:NO];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 接通后视频 -上层- 视图数据变化显示、相关定时器设置显示
//是否隐藏视频功能区视图
- (void)isHiddenBeforeAnswerView:(BOOL)isBeforeHidden andIsHiddenAfterAnswerView:(BOOL)isAfterHidden{
    self.beforeAnswerView.hidden = isBeforeHidden;
    self.afterAnswerView.hidden = isAfterHidden;
}

//是否隐藏视频上层数据视图
- (void)isHiddenfrontVideoView:(BOOL)isHidden andElectricValue:(NSInteger)electricValue{
    self.frontVideoView.hidden = isHidden;
    self.statusView.hidden = !isHidden;
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
    [dataFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
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
        self.beforeVideoBtn.userInteractionEnabled = YES;
        [self stopVideoRecordTimer];
        _videoTimeType = 1;
        self.redPointView.hidden = YES;
    }
}

#pragma mark - 接通后视频 -底层- 视图数据变化显示、相关定时器设置显示
//是否隐藏底层接通视图、是否是被呼叫中
- (void)isHiddenBottomView:(BOOL)isHidden andIsCall:(BOOL)isCall{
    self.bottomView.hidden = isHidden;
    if (isHidden) {
        [self stopOnlineTimerTimer];
        [self stopCallTimer];
        
        _callTimerValue = 30;
        _onlineTimerValue = 180;
    }else{
        if (isCall) {
            self.answerBtn.hidden = NO;
            self.dropCenterBtn.hidden = YES;
            self.dropRightBtn.hidden = NO;
            [self stopOnlineTimerTimer];
            [self startCallTimer];
        }else{
            self.answerBtn.hidden = YES;
            self.dropCenterBtn.hidden = NO;
            self.dropRightBtn.hidden = YES;
            [self stopCallTimer];
            [self startOnlineTimer];
        }
    }
}

//被呼叫定时器
- (void)startCallTimer{
    _callTimerValue = 30;
    if (!self.callTimer) {
        self.callTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(callTimerClick) userInfo:nil repeats:YES];
        [self.callTimer fire];
    }
}

- (void)stopCallTimer{
    if (self.callTimer) {
        [self.callTimer invalidate];
        self.callTimer = nil;
    }
}

- (void)callTimerClick{
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(long)(_callTimerValue / 60)];//分
    NSString *str_second = [NSString stringWithFormat:@"%02ld",(long)(_callTimerValue % 60)];//秒
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    self.countdownLabel.text = format_time;
    
    if (_callTimerValue == 0) {
        [self stopCallTimer];
        //呼叫挂断
        [self hangupCall];
    }
    _callTimerValue --;
}

//通话定时器
- (void)startOnlineTimer{
    _onlineTimerValue = 180;
    if (!self.onlineTimer) {
        self.onlineTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onlineTimerClick) userInfo:nil repeats:YES];
        [self.onlineTimer fire];
    }
}

- (void)stopOnlineTimerTimer{
    if (self.onlineTimer) {
        [self.onlineTimer invalidate];
        self.onlineTimer = nil;
    }
}

- (void)onlineTimerClick{
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(long)(_onlineTimerValue / 60)];//分
    NSString *str_second = [NSString stringWithFormat:@"%02ld",(long)(_onlineTimerValue % 60)];//秒
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    self.countdownLabel.text = format_time;
    
    if (_onlineTimerValue == 0) {
        [self stopOnlineTimerTimer];
        //通话挂断
        [self hangupCall];
    }
    _onlineTimerValue --;
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
    [[UCSFuncEngine getInstance] initCameraConfig:self.videoLocationView withRemoteVideoView:self.videoRemoteView withRender:RENDER_HALFFULLSCREEN];
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

- (void)dismissAndReleaseCurView{
    [[UCSVOIPViewEngine getInstance]releaseViewControler:self];
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
    [[UCSFuncEngine getInstance] answer:self.callID];
}

//挂断通话
- (void)hangupCall{
    [[UCSFuncEngine getInstance] hangUp:self.callID];
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
            //开启声音
            [self muteWithIsOpen:NO];
            
            _callStatus = CatEyeCallStatus_Talk;
            [self setVideoStatusType:3];
        }
            break;
            
        case UCSCallStatus_Released://通话释放
        {
            [MBManager hideAlert];
            [MBManager showBriefAlert:@"通话已结束"];
            _callStatus = CatEyeCallStatus_NULL;
            [self setVideoStatusType:4];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissAndReleaseCurView];
            });
        }
            break;
        case UCSCallStatus_Failed:
        case UCSCallStatus_Transfered:
        case UCSCallStatus_Pasused:
        default:
            [MBManager hideAlert];
            [MBManager showBriefAlert:@"呼叫超时,请重试"];
            _callStatus = CatEyeCallStatus_NULL;
            [self  setVideoStatusType:4];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissAndReleaseCurView];
            });
            break;
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//透传数据给猫眼
- (void)unvarnishedTransmissionDataToCatEyeWithContentDict:(NSDictionary *)contentDict andTitleName:(NSString *)titleName{
    NSString *UMessage = [self convertToJsonData:contentDict];
    
    UCSTCPTransParentRequest *request = [UCSTCPTransParentRequest initWithCmdString:UMessage receiveId:self.curCatEyeModel.account];
    
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
            self.beforeVideoBtn.userInteractionEnabled = NO;
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
