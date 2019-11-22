//
//  TCDoorVideoCallController.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/19.
//

#import "TCDoorVideoCallController.h"
#import <AVFoundation/AVFoundation.h>
#import "TYLVerticalButton.h"
#import "Header.h"
#import <mach/mach.h>
@class UCSVideoAttr;
@class Resolutions;
@class VideoView;
@class UCSHieEncAttr;
@class UCSVideoRecordAttr;
@interface TCDoorVideoCallController ()

@property (strong,nonatomic) UIImageView * backgroundView; // WLS，2015-12-14，背景视图


@property (strong,nonatomic) UIView *callBackView; // WLS，2015-12-14，通话中所有按钮的背景视图
@property (strong,nonatomic) UIButton *hangupButton; // WLS，2015-12-14，挂断按钮
@property (strong,nonatomic) UILabel *voipNumberLabel; // WLS，2015-12-14，对方号码标题
@property (strong,nonatomic) UIButton *callTimeLabel; // WLS，2015-12-14，通话时间标题
@property (strong,nonatomic) UIButton *netWorkStatusLabel; // kucky，2017-09-22，通话时间标题
@property (strong,nonatomic) UIView *callFunctionView; // WLS，2015-12-14，通话中功能按钮视图
@property (strong,nonatomic) UIButton *handFreeButton; // WLS，2015-12-14，免提按钮
@property (strong,nonatomic) UIButton *answerButton; // WLS，2015-12-14，接听按钮(被叫使用)


@property (strong, nonatomic) UIView * localContainerView;
@property (strong,nonatomic) UIView *videoLocationView; // WLS，2015-12-14，本地视频视图
@property (strong,nonatomic) UIView *videoRemoteView; // WLS，2015-12-14，远程视频视图


@property (assign,nonatomic) BOOL isReleaseCall; // WLS，2015-12-19，是否已经移除过界面


@property (strong,nonatomic) UIView * incomingView; // WLS，2015-12-19，来电时候的界面
@property (strong,nonatomic) UILabel * informationLabel; // 展示信息的label
@property (assign,nonatomic) int landscape; // 应用是否处于横屏状态
@property (strong,nonatomic) UIImageView * previewImageView;//被叫情况下，接通前预览主叫图像

@property (strong,nonatomic) UIButton *openDoorButton; // 开锁按钮
@end

@implementation TCDoorVideoCallController

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [super viewWillDisappear:animated];
}

- (TCDoorVideoCallController *)initWithCallerName:(NSString *)name  andVoipNo:(NSString *)voipNo{
    if (self = [super init])
    {
        self.callerName = name;
        self.voipNo = voipNo;
        self.isCallNow = NO;
        self.callDuration = @"";
        hhInt = 0;
        mmInt = 0;
        ssInt = 0;
        self.isReleaseCall = NO;
        self.beReject = NO;
        return self;
    }
    
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeVideoCallView];
    
    self.hangupMySelf = NO;
    // 设置不自动进入锁屏待机状态
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    // 需要在通话中成为firstResponder，否则切换回前台后，听不到声音
    [self becomeFirstResponder];
    
    
    [[UCSFuncEngine getInstance] initCameraConfig:self.videoLocationView withRemoteVideoView:self.videoRemoteView withRender:RENDER_HALFFULLSCREEN];
}

// 需要在通话中成为firstResponder，否则切换回前台后，听不到声音
- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - 界面规划
/**
 @author WLS, 15-12-14 14:12:23
 
 视频通话界面
 */
- (void)makeVideoCallView{
    
    //背景视图
    UIImageView *imageView = [[UIImageView alloc] init];
    self.backgroundView = imageView;
    self.backgroundView.image = [TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_对讲bg"];
    self.backgroundView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    //远程窗口
    self.videoRemoteView = [[UCSFuncEngine getInstance] allocCameraViewWithFrame:self.view.bounds];
    self.videoRemoteView.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:self.videoRemoteView];
    
    
    //本地窗口容器
    self.localContainerView = [[UCSFuncEngine getInstance] allocCameraViewWithFrame:CGRectMake(0,0,0, 1)];
    self.localContainerView.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:self.localContainerView];
    
    
    //本地窗口
    self.videoLocationView = [[UCSFuncEngine getInstance] allocCameraViewWithFrame:self.localContainerView.bounds];
    self.videoLocationView.backgroundColor = [UIColor clearColor];
    [self.localContainerView addSubview:self.videoLocationView];
    
    
    
    //通话过程中所有按钮的背景视图,透明
//    self.callBackView = [[UIView alloc] initWithFrame:self.view.bounds];
//    self.callBackView.backgroundColor = [UIColor clearColor];
//    [self.backgroundView addSubview:self.callBackView];
    
    // 将本地视图调到 通话过程中的按钮背景视图之上。因为本地视频视图需要触发点击事件，否则点击到callbackview
//    [self.backgroundView insertSubview:self.localContainerView aboveSubview:self.callBackView];
    
    
    
    //来电号码或者被叫号码
    UILabel *voipNumberLabel =[[UILabel alloc] init];
    self.voipNumberLabel = voipNumberLabel;
    [self.backgroundView addSubview:voipNumberLabel];
    self.voipNumberLabel.font = [UIFont systemFontOfSize:GetTextFont(21)];
    self.voipNumberLabel.textColor = [UIColor whiteColor];
    self.voipNumberLabel.text = self.isGroupDail? @"视频同振中": self.callerName;
    [voipNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView).offset(TCNaviH-20);
        make.centerX.equalTo(self.backgroundView);
    }];
    
    //图片组数
    NSArray *imgAry = [NSArray array];
    NSArray *seleImgAry = [NSArray array];
    NSArray *titleAry = [NSArray array];
    if (self.incomingCall) {
        imgAry = @[@"TCCT_挂断_nor",@"TCCT_开锁_nor",@"TCCT_接听_nor"];
        seleImgAry = @[@"TCCT_挂断_nor",@"TCCT_开锁_nor",@"TCCT_接听_nor"];
        titleAry = @[@"挂断",@"开锁",@"接听"];
    }else
    {
        imgAry = @[@"TCCT_挂断_nor",@"TCCT_开锁_nor",@"TCCT_免提_关闭"];
        seleImgAry = @[@"TCCT_挂断_nor",@"TCCT_开锁_nor",@"TCCT_免提_开启_nor"];
        titleAry = @[@"挂断",@"开锁",@"免提"];
    }
    
    NSMutableArray *tolAry = [NSMutableArray new];
    for (int i = 0; i < 3; i ++) {
        TYLVerticalButton *btn = [TYLVerticalButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[TCCloudTalkingImageTool getToolsBundleImage:imgAry[i]] forState:UIControlStateNormal];
        [btn setImage:[TCCloudTalkingImageTool getToolsBundleImage:seleImgAry[i]] forState:UIControlStateSelected];
        [btn setTitle:titleAry[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(funtionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        //        btn.imageEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 30);
        [self.view addSubview:btn];
        [tolAry addObject:btn];
        
        if (i == 0) {
            self.hangupButton = btn;
        }else if (i == 1){
            self.openDoorButton = btn;
        }else{
            self.answerButton = btn;
            
        }
    }
    
    
    //水平方向控件间隔固定等间隔
    [tolAry mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:49 leadSpacing:40 tailSpacing:40];
    [tolAry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-10);
        make.height.equalTo(@110);
    }];
    
    
    
    //显示呼叫状态、通话状态、显示通话时间的按钮
    UIButton *callTimeLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.callTimeLabel = callTimeLabel;
    [self.backgroundView addSubview:callTimeLabel];
    self.callTimeLabel.enabled = NO;
    self.callTimeLabel.titleLabel.font = [UIFont systemFontOfSize:GetTextFont(13)];
    self.callTimeLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.callTimeLabel setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.callTimeLabel setTitle:@"呼叫请求中" forState:UIControlStateDisabled];
    [callTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(voipNumberLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.backgroundView);
    }];
    if (self.incomingCall) {
        //如果处于来电状态 则通话状态的标题暂时先隐藏 ，等到通话建立起来，在显示
        self.callTimeLabel.hidden = YES;
        
    }
    
    //显示通话中网络状态
    UIButton *netWorkStatusLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.netWorkStatusLabel = netWorkStatusLabel;
    self.netWorkStatusLabel.enabled = NO;
    self.netWorkStatusLabel.titleLabel.font = [UIFont systemFontOfSize:GetTextFont(13)];
    self.netWorkStatusLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.netWorkStatusLabel setTitle:@"" forState:UIControlStateDisabled];
    [self.backgroundView addSubview:netWorkStatusLabel];
    [netWorkStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.openDoorButton.mas_top).offset(-20);
        make.centerX.equalTo(self.backgroundView);
    }];
    if (self.incomingCall) {
        //如果处于来电状态 则通话中网络状态暂时先隐藏 ，等到通话建立起来，在显示
        self.netWorkStatusLabel.hidden = YES;
        
    }
    

}

#pragma mark - 生命周期
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.hangupButton removeFromSuperview];
    self.hangupButton = nil;
    
    [self.voipNumberLabel removeFromSuperview];
    self.voipNumberLabel = nil;
    
    [self.callTimeLabel removeFromSuperview];
    self.callTimeLabel = nil;
    
    [self.handFreeButton removeFromSuperview];
    self.handFreeButton = nil;
    
    
    [self.answerButton removeFromSuperview];
    self.answerButton = nil;
    
    [self.localContainerView removeFromSuperview];
    self.localContainerView = nil;
    
    [self.videoRemoteView removeFromSuperview];
    self.videoRemoteView = nil;
    
    [self.callFunctionView removeFromSuperview];
    self.callFunctionView = nil;
    
    [self.callBackView removeFromSuperview];
    self.callBackView = nil;
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    
    
    [self.incomingView removeFromSuperview];
    self.incomingView =nil;
    

    
    
}

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
    [[UCSFuncEngine getInstance] setVideoAttr:vEncAttr ];

    
    //设置视频来电时是否支持预览。
    [[UCSFuncEngine getInstance] setCameraPreViewStatu:YES];
}



- (NSString *)getNowTime
{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

//视频分级编码参数
- (void)setHierEncArrt{
    
    //------------------------视频分级编码参数-----------------------------//
    UCSHierEncAttr * hierEncAttr = [[UCSHierEncAttr alloc]init];
    
    //    hierEncAttr.low_complexity_w240 = 2;
    //    hierEncAttr.low_complexity_w360 = 1;
    //    hierEncAttr.low_complexity_w480 = 1;
    //    hierEncAttr.low_complexity_w720 = 0;
    //    hierEncAttr.low_bitrate_w240 =  200;
    //    hierEncAttr.low_bitrate_w360 =  -1;
    //    hierEncAttr.low_bitrate_w480 =  -1;
    //    hierEncAttr.low_bitrate_w720 =  -1;
    //    hierEncAttr.low_framerate_w240 = 8;
    //    hierEncAttr.low_framerate_w360 = 8;
    //    hierEncAttr.low_framerate_w480 = -1;
    //    hierEncAttr.low_framerate_w720 = 8;
    //
    //    hierEncAttr.medium_complexity_w240 = 3;
    //    hierEncAttr.medium_complexity_w360 = 2;
    //    hierEncAttr.medium_complexity_w480 = 1;
    //    hierEncAttr.medium_complexity_w720 = 0;
    //    hierEncAttr.medium_bitrate_w240 = 200;
    //    hierEncAttr.medium_bitrate_w360 = 400;
    //    hierEncAttr.medium_bitrate_w480 = -1;
    //    hierEncAttr.medium_bitrate_w720  = -1;
    //    hierEncAttr.medium_framerate_w240 = 8;
    //    hierEncAttr.medium_framerate_w360 = 8;
    //    hierEncAttr.medium_framerate_w480 = 8;
    //    hierEncAttr.medium_framerate_w720 = 8;
    //
    //    hierEncAttr.high_complexity_w240 = 3;
    //    hierEncAttr.high_complexity_w360 = 2;
    //    hierEncAttr.high_complexity_w480 = 2;
    //    hierEncAttr.high_complexity_w720 = 1;
    //    hierEncAttr.high_bitrate_w240 = 200;
    //    hierEncAttr.high_bitrate_w360 = 400;
    //    hierEncAttr.high_bitrate_w480 = -1;
    //    hierEncAttr.high_bitrate_w720 = -1;
    //    hierEncAttr.high_framerate_w240 = 8;
    //    hierEncAttr.high_framerate_w360 = 8;
    //    hierEncAttr.high_framerate_w480 = 8;
    //    hierEncAttr.high_framerate_w720 = 8;
    
    
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
    //------------------------视频分级编码参数-----------------------------//
    
}

- (void)disableAllButton{
    
    self.handFreeButton.enabled = NO;
    
    self.hangupButton.enabled = NO;
    
    self.answerButton.enabled = NO;
    
    self.openDoorButton.enabled = NO;
}
#pragma mark - 按钮点击事件
- (void)funtionButtonClick:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"挂断"]) {
        
        [self hangupCall];
    }else if([button.titleLabel.text isEqualToString:@"开锁"])
    {
        
    }else if([button.titleLabel.text isEqualToString:@"免提"])
    {
        [self handfreeButtonClicked];
    }else
    {
        [self answerCall];
        [self.answerButton setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_免提_关闭"] forState:UIControlStateNormal];
        [self.answerButton setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_免提_开启_nor"] forState:UIControlStateSelected];
        [self.answerButton setTitle:@"免提" forState:UIControlStateNormal];

    }
    
    
    
}

/**
 @author WLS, 15-12-14 16:12:46
 
 挂断电话
 */
- (void)hangupCall
{
    
    
    [self setCallDuration];
    
    [self disableAllButton];
    
    self.hangupMySelf = YES;
    [[UCSFuncEngine getInstance] hangUp:self.callID];
    
    [[UCSVOIPViewEngine getInstance] WriteToSandBox:[NSString stringWithFormat:@"挂断通话：%@",[UCSFuncEngine getInstance]]];
    
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(backFront) userInfo:nil repeats:NO];
    
}

/**
 @author WLS, 15-12-14 16:12:43
 
 接听电话
 */
- (void)answerCall{
    
    [[UCSFuncEngine getInstance] answer:self.callID];
}

//免提事件
- (void)handfreeButtonClicked
{
    //耳机插入的情况下，免提开关失效
    if (self.isCallNow ==NO) {
        return;
    }
    self.answerButton.selected = !self.answerButton.selected;
    [[UCSFuncEngine getInstance] setSpeakerphone:self.answerButton.selected];
    
}

/**
 @author WLS, 15-12-14 17:12:10
 
 释放界面
 */
- (void)backFront
{
    if (self.isReleaseCall) {
        return;
    }
    self.isReleaseCall = YES;
    
    
    [[UCSVOIPViewEngine getInstance]releaseViewControler:self];
    
    
}

/**
 @author WLS, 15-12-19 15:12:49
 
 网络状态回调
 
 @param currentNetwork 当前的网络状态
 */
- (void)networkStatusChange:(NSInteger)currentNetwork{
    NSString * networkStatusTips = nil;
    switch (currentNetwork) {
        case UCSNetwork_Bad:
        {
            //差
            networkStatusTips = @"当前通话网络状况不佳";
            [self.netWorkStatusLabel setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        }
            break;
        case UCSNetwork_General:
        {
            //一般
            networkStatusTips = @"当前通话网络状况一般";
            [self.netWorkStatusLabel setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
            
        }
            break;
        case UCSNetwork_Nice:
        {
            //良好
            networkStatusTips = @"当前通话网络状况良好";
            [self.netWorkStatusLabel setTitleColor:[UIColor greenColor] forState:UIControlStateDisabled];
        }
            break;
        case UCSNetwork_Well:
        {
            //优秀
            networkStatusTips = @"当前通话网络状况优秀";
            [self.netWorkStatusLabel setTitleColor:[UIColor greenColor] forState:UIControlStateDisabled];
        }
            break;
        default:
            break;
    }

    self.netWorkStatusLabel.hidden = NO;
    [self.netWorkStatusLabel setTitle:networkStatusTips forState:UIControlStateDisabled];
    
}

-(void)responseVoipManagerStatus:(UCSCallStatus)event callID:(NSString*)callid data:(UCSReason *)data withVideoflag:(int)videoflag
{
    
    [_previewImageView removeFromSuperview];
    _previewImageView = nil;
    
    
    
    self.callTimeLabel.hidden = NO;
    switch (event)
    {
        case UCSCallStatus_Alerting:{
            [self.callTimeLabel setTitle:@"对方正在响铃" forState:UIControlStateDisabled];
            //设置视频分级编码，需在通话接通前调用
            [self setHierEncArrt];
            
        }
            break;
        case UCSCallStatus_Answered:
        {
            
            [self setVideoEnc];
            UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
            
            switch (orient)
            {
                case UIDeviceOrientationPortrait:
                    
                    [self rotationCameraAngle:self.landscape andlocalRotationAngle:0];
                    break;
                    
                case UIDeviceOrientationLandscapeLeft:
                    
                    [self rotationCameraAngle:self.landscape andlocalRotationAngle:90];
                    break;
                    
                case UIDeviceOrientationPortraitUpsideDown:
                    
                    [self rotationCameraAngle:self.landscape andlocalRotationAngle:180];
                    break;
                    
                case UIDeviceOrientationLandscapeRight:
                    
                    [self rotationCameraAngle:self.landscape andlocalRotationAngle:270];
                    break;
                    
                default:
                    break;
            }
            
            
            self.isCallNow = YES;
            
            [self.callTimeLabel setTitle:@"00:00" forState:UIControlStateDisabled];
            
            if (![timer isValid])
            {
                timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateRealtimeLabel) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
                [timer fire];
            }
            
            
            if (self.isGroupDail) {
                self.voipNumberLabel.text = @"视频同振通话中";
            }
            
        
            
            
            
            
            
            if ([self isHeadphone]) {
                //有耳机
                [[UCSFuncEngine getInstance] setSpeakerphone:NO];
                self.handFreeButton.selected = NO;
                self.handFreeButton.enabled = NO;
            }else{
                //无耳机
                [[UCSFuncEngine getInstance] setSpeakerphone:YES];
                self.handFreeButton.selected = YES;
            }
            
            
        }
            break;
            
        case UCSCallStatus_Released:
        {
            
            
            
            [self setCallDuration];
            
            
            [self disableAllButton];
            
            [self.callTimeLabel setImage:nil forState:UIControlStateDisabled];
            
            
            if (!_isCallNow && !self.hangupMySelf && !self.incomingCall) {
                
                [self.callTimeLabel setTitle:@"对方无应答" forState:UIControlStateDisabled];
                
            }else if (data.reason == 402015){
                
            }else{
                
                [self.callTimeLabel setTitle:data.msg forState:UIControlStateDisabled];
                
            }
            
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(backFront) userInfo:nil repeats:NO];

        }
            break;
        case UCSCallStatus_Failed:
        {
            [self disableAllButton];
            
            [self.callTimeLabel setImage:nil forState:UIControlStateDisabled];
            [self.callTimeLabel setTitle:data.msg forState:UIControlStateDisabled];
            
            if (data.reason == 402016) {
                
                [self.callTimeLabel setTitle:@"对方已挂机" forState:UIControlStateDisabled];
                
            }else if (data.reason == 402012) {
                
                /**
                 @author WLS, 15-12-21 11:12:04
                 
                 被叫拒绝接听
                 */
                self.beReject = YES;
                [self.callTimeLabel setTitle:@"对方拒绝接听" forState:UIControlStateDisabled];
                
            }else if (data.reason == 402013){
                
                [self.callTimeLabel setTitle:data.msg forState:UIControlStateDisabled];
                
            }else if (data.reason==402050) {
                
                [self.callTimeLabel setTitle:@"对方无应答" forState:UIControlStateDisabled];
                
            }
            
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(backFront) userInfo:nil repeats:NO];
            
        }
            break;
        case UCSCallStatus_Transfered:
        {
            [self disableAllButton];
            
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(backFront) userInfo:nil repeats:NO];
        }
            break;
        case UCSCallStatus_Pasused:
        {
            [self.callTimeLabel setImage:nil forState:UIControlStateDisabled];
            [self.callTimeLabel setTitle:@"呼叫保持" forState:UIControlStateDisabled];
        }
            break;
        default:
            break;
    }
    
    
    
}


/**
 @author WLS, 15-12-14 15:12:34
 
 旋转屏幕角度
 
 @param rotationAngle 角度
 */
- (void)rotationCameraAngle:(unsigned int) landscape  andlocalRotationAngle:(unsigned int)rotationAngle{
    
    [[UCSFuncEngine getInstance] setRotationVideo:landscape andRecivied:rotationAngle];
    
}

- (void)updateRealtimeLabel
{
    ssInt +=1;
    if (ssInt >= 60) {
        mmInt += 1;
        ssInt -= 60;
        if (mmInt >=  60) {
            hhInt += 1;
            mmInt -= 60;
            if (hhInt >= 24) {
                hhInt = 0;
            }
        }
    }
    
    if(ssInt > 0 && ssInt % 4 == 0 )
    {
        
    }
    if (hhInt > 0) {
        [self.callTimeLabel setTitle:[NSString stringWithFormat:@"%02d:%02d:%02d",hhInt,mmInt,ssInt] forState:UIControlStateDisabled];
        self.callDuration = self.callTimeLabel.titleLabel.text;
    }
    else
    {
        [self.callTimeLabel setTitle:[NSString stringWithFormat:@"%02d:%02d",mmInt,ssInt] forState:UIControlStateDisabled];
        self.callDuration = self.callTimeLabel.titleLabel.text;
        
    }
}


/**
 @author WLS, 15-12-18 16:12:11
 
 设置通话时间
 */
- (void)setCallDuration{
    
    if ([timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
    
    if (self.isCallNow) {
        /**
         @author WLS, 15-12-18 16:12:39
         
         如果处于通话状态，挂断或者是异常挂断，保存通话时间
         */
        if ([self.callTimeLabel.titleLabel.text isEqualToString:@"正在挂机"]||
            [self.callTimeLabel.titleLabel.text componentsSeparatedByString:@":"].count <=1) {
        }else{
            self.callDuration = self.callTimeLabel.titleLabel.text;
            
        }
    }
}

#pragma mark - 通知

//添加通知
-(void)addNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headPhoneChange:) name:UCSNotiHeadPhone object:nil];
    /**
     @author WLS, 15-12-15 09:12:20
     
     踢线通知
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KickOffNoti) name:TCPKickOffNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(answerCall) name:NOTIFICATION_ANSWERCALL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hangupCall) name:NOTIFICATION_ENDCALL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHangupButtonFrame) name:NOTIFICATION_ANSWERCALL_UI object:nil];
    
}

- (void)headPhoneChange:(NSNotification *)note{
    
    NSNumber * i = note.object;
    if (i.intValue) {
        NSLog(@"有耳机");
        //有耳机
        self.handFreeButton.selected = NO;
        self.handFreeButton.enabled = NO;
        [[UCSFuncEngine getInstance] setSpeakerphone:NO];
        
    }else{
        NSLog(@"没耳机");
        self.handFreeButton.enabled = YES;
    }
    
    
}

/**
 @author WLS, 15-12-11 17:12:23
 
 被踢线
 */
-(void)KickOffNoti
{
    
    [self hangupCall];
    
    
}


-(BOOL)isHeadphone
{
    UInt32 propertySize = sizeof(CFStringRef);
    CFStringRef state = nil;
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute
                            ,&propertySize,&state);
    //return @"Headphone" or @"Speaker" and so on.
    //根据状态判断是否为耳机状态
    if ([(__bridge NSString *)state isEqualToString:@"Headphone"] ||[(__bridge NSString *)state isEqualToString:@"HeadsetInOut"])
    {
        return YES;
    }else {
        return NO;
    }
}

@end
