////
////  UCSVideoCallController.m
////  UCSVoipDemo
////
////  Created by tongkucky on 14-5-22.
////  Copyright (c) 2014年 UCS. All rights reserved.
////
//
//
//
//
#import <AVFoundation/AVFoundation.h>
#import "TCVideoCallController.h"

#import <mach/mach.h>

@class UCSVideoAttr;
@class Resolutions;
@class VideoView;
@class UCSHieEncAttr;
@class UCSVideoRecordAttr;

@interface TCVideoCallController ()


@property (strong,nonatomic) UIImageView * backgroundView; // WLS，2015-12-14，背景视图


@property (strong,nonatomic) UIView *callBackView; // WLS，2015-12-14，通话中所有按钮的背景视图
@property (strong,nonatomic) UIButton *hangupButton; // WLS，2015-12-14，挂断按钮
@property (strong,nonatomic) UILabel *voipNumberLabel; // WLS，2015-12-14，对方号码标题
@property (strong,nonatomic) UIButton *callTimeLabel; // WLS，2015-12-14，通话时间标题
@property (strong,nonatomic) UIButton *netWorkStatusLabel; // kucky，2017-09-22，通话时间标题
@property (strong,nonatomic) UIView *callFunctionView; // WLS，2015-12-14，通话中功能按钮视图
@property (strong,nonatomic) UIButton *handFreeButton; // WLS，2015-12-14，免提按钮
@property (strong,nonatomic) UIButton *closeCameraButton; // WLS，2015-12-14，关闭摄像头按钮
@property (strong,nonatomic) UIButton *muteButton; // WLS，2015-12-14，静音按钮
@property (strong,nonatomic) UIButton *switchCameraButton; // WLS，2015-12-14，切换摄像头按钮
@property (strong,nonatomic) UIButton *answerButton; // WLS，2015-12-14，接听按钮(被叫使用)


@property (strong, nonatomic) UIView * localContainerView; 
@property (strong,nonatomic) UIView *videoLocationView; // WLS，2015-12-14，本地视频视图
@property (strong,nonatomic) UIView *videoRemoteView; // WLS，2015-12-14，远程视频视图


@property (assign,nonatomic) BOOL isReleaseCall; // WLS，2015-12-19，是否已经移除过界面


@property (strong,nonatomic) UIView * incomingView; // WLS，2015-12-19，来电时候的界面
@property (strong,nonatomic) UILabel * informationLabel; // 展示信息的label
@property (assign,nonatomic) int landscape; // 应用是否处于横屏状态
@property (strong,nonatomic) UIImageView * previewImageView;//被叫情况下，接通前预览主叫图像
@end

@implementation TCVideoCallController



#pragma mark - 界面规划
/**
 @author WLS, 15-12-14 14:12:23
 
 视频通话界面
 */
- (void)makeVideoCallView{
    
    //背景视图
    self.backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundView.backgroundColor = RGBACOLOR(22, 32, 39, 1);
    self.backgroundView.userInteractionEnabled = YES;
    [self.view addSubview:self.backgroundView];
    
    
    //远程窗口
    self.videoRemoteView = [[UCSFuncEngine getInstance] allocCameraViewWithFrame:self.backgroundView.bounds];
    self.videoRemoteView.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:self.videoRemoteView];

    
    //本地窗口容器
    self.localContainerView = [[UCSFuncEngine getInstance] allocCameraViewWithFrame:CGRectMake(0,0,0, 1)];
    self.localContainerView.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:self.localContainerView];
//    if (CurrentHeight !=480) {
//        CGRect frame = self.localContainerView.frame;
//        frame.origin.y = Adaptation(230);
//        self.localContainerView.frame = frame;
//    }
    
    //本地窗口
    self.videoLocationView = [[UCSFuncEngine getInstance] allocCameraViewWithFrame:self.localContainerView.bounds];
    self.videoLocationView.backgroundColor = [UIColor clearColor];
    [self.localContainerView addSubview:self.videoLocationView];

    
    
    //通话过程中所有按钮的背景视图,透明
    self.callBackView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.callBackView.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:self.callBackView];
    
    // 将本地视图调到 通话过程中的按钮背景视图之上。因为本地视频视图需要触发点击事件，否则点击到callbackview
    [self.backgroundView insertSubview:self.localContainerView aboveSubview:self.callBackView];
    
    
    
    //来电号码或者被叫号码
    self.voipNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adaptation(10), Adaptation(35), Adaptation(200), Adaptation(20))];
    self.voipNumberLabel.font = [UIFont systemFontOfSize:GetTextFont(21)];
    self.voipNumberLabel.textColor = [UIColor whiteColor];
    self.voipNumberLabel.text = self.isGroupDail? @"视频同振中": self.callerName;
    [self.backgroundView addSubview:self.voipNumberLabel];
    
    
    
    
    //显示呼叫状态、通话状态、显示通话时间的按钮
    self.callTimeLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.callTimeLabel.enabled = NO;
    self.callTimeLabel.frame = CGRectMake(Adaptation(10), GetViewHeight(self.voipNumberLabel)+GetViewY(self.voipNumberLabel)+ Adaptation(5), Adaptation(200),GetViewHeight(self.voipNumberLabel));
    self.callTimeLabel.titleLabel.font = [UIFont systemFontOfSize:GetTextFont(13)];
    self.callTimeLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.callTimeLabel setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.callTimeLabel setTitle:@"呼叫请求中" forState:UIControlStateDisabled];
    [self.backgroundView addSubview:self.callTimeLabel];
    if (self.incomingCall) {
        //如果处于来电状态 则通话状态的标题暂时先隐藏 ，等到通话建立起来，在显示
        self.callTimeLabel.hidden = YES;
        
    }
    
    //显示通话中网络状态
    self.netWorkStatusLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.netWorkStatusLabel.enabled = NO;
    self.netWorkStatusLabel.frame = CGRectMake(Adaptation(10), GetViewHeight(self.voipNumberLabel)+GetViewY(self.voipNumberLabel)+ Adaptation(5)+GetViewHeight(self.voipNumberLabel), Adaptation(200),GetViewHeight(self.voipNumberLabel));
    self.netWorkStatusLabel.titleLabel.font = [UIFont systemFontOfSize:GetTextFont(13)];
    self.netWorkStatusLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.netWorkStatusLabel setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [self.netWorkStatusLabel setTitle:@"" forState:UIControlStateDisabled];
    [self.backgroundView addSubview:self.netWorkStatusLabel];
    if (self.incomingCall) {
        //如果处于来电状态 则通话中网络状态暂时先隐藏 ，等到通话建立起来，在显示
        self.netWorkStatusLabel.hidden = YES;
        
    }
    
    
    

    //静音 扬声器 键盘按钮
    [self makeCallFuntionButton];
    
    
    
    

    //挂断按钮,
    self.hangupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hangupButton setImage:[UIImage imageNamed:@"挂断"] forState:UIControlStateNormal];
    [self.hangupButton setImage:[UIImage imageNamed:@"挂断-down"] forState:UIControlStateDisabled];
    [self.hangupButton addTarget:self action:@selector(hangupCall) forControlEvents:UIControlEventTouchUpInside];
    self.hangupButton.frame = CGRectMake(CenterPoint(GetViewWidth(self.callBackView), Adaptation(60)), Adaptation(470), Adaptation(60), Adaptation(60));
    if (CurrentHeight == 480) {
        CGRect frame = self.hangupButton.frame;
        frame.origin.y = Adaptation(410);
        self.hangupButton.frame = frame;
    }
    [self.callBackView addSubview:self.hangupButton];
    
    
    
    
    //如果是来电，则还有接听按钮
    if (self.incomingCall) {
        self.answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.answerButton.backgroundColor = [UIColor whiteColor];
        [self.answerButton addTarget:self action:@selector(answerCall) forControlEvents:UIControlEventTouchUpInside];
        [self.callBackView addSubview:self.answerButton];
        
        self.hangupButton.frame = CGRectMake((GetViewWidth(self.callBackView)-Adaptation(60)*2)/3, Adaptation(470), Adaptation(60), Adaptation(60));
        self.answerButton.frame = CGRectMake(GetViewWidth(self.hangupButton)+GetViewX(self.hangupButton)*2, Adaptation(470), GetViewWidth(self.hangupButton), GetViewHeight(self.hangupButton));
        
        if (CurrentHeight == 480) {
            CGRect frame = self.hangupButton.frame;
            frame.origin.y = Adaptation(410);
            self.hangupButton.frame = frame;
            
            
            frame = self.answerButton.frame;
            frame.origin.y = Adaptation(410);
            self.answerButton.frame = frame;
        }

    }
    
    
    
    
    //切换摄像头按钮
    self.switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchCameraButton.frame = CGRectMake(GetViewWidth(self.callBackView)- Adaptation(50), GetViewY(self.voipNumberLabel)-Adaptation(10), Adaptation(50) , Adaptation(45));
    [self.switchCameraButton setImage:[UIImage imageNamed:@"前置摄影头切换"] forState:UIControlStateNormal];
    self.switchCameraButton.tag = 0;
    [self.switchCameraButton addTarget:self action:@selector(switchCameraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.callBackView addSubview:self.switchCameraButton];
    //通话未接通前，暂时隐藏按钮
    self.switchCameraButton.hidden = YES;
    

    
}


/**
 @author WLS, 15-12-14 14:14:47
 
 静音 扬声器 键盘按钮
 */
- (void)makeCallFuntionButton{

    
    
    self.callFunctionView = [[UIView alloc] initWithFrame:CGRectMake(Adaptation(30), Adaptation(395), GetViewWidth(self.callBackView) - Adaptation(60) , Adaptation(60))];
    if (CurrentHeight == 480) {
        CGRect frame = self.callFunctionView.frame;
        frame.origin.y = Adaptation(330);
        self.callFunctionView.frame = frame;
        
    }
    self.callFunctionView.backgroundColor = [UIColor clearColor];
    [self.callBackView addSubview:self.callFunctionView];
    
    
    CGFloat spaceWidth = (GetViewWidth(self.callFunctionView)  - GetViewHeight(self.callFunctionView)*3)/2.0;
    NSArray * imageArray = @[@"静音",@"摄像头",@"扬声器"];
    NSArray * selectImageArray = @[@"静音-down",@"摄像头-down",@"扬声器-down"];
    NSArray * titleArray = @[@"静音",@"摄像头",@"扬声器"];
    for (int i = 0; i<3; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * (GetViewHeight(self.callFunctionView)+spaceWidth), 0, GetViewHeight(self.callFunctionView), GetViewHeight(self.callFunctionView));
        button.tag = i;
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectImageArray[i]] forState:UIControlStateSelected];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:RGBACOLOR(255, 255, 255, 0.5) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:GetTextFont(11)];
        button.imageEdgeInsets = UIEdgeInsetsMake(5,10,21,button.titleLabel.bounds.size.width);
        button.titleEdgeInsets = UIEdgeInsetsMake(40, -button.titleLabel.bounds.size.width-40, 0, 0);
        [button addTarget:self action:@selector(funtionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.callFunctionView addSubview:button];
        
        
        if (i == 0) {
            self.muteButton = button;
        }else if (i == 1){
            self.closeCameraButton = button;
        }else{
            self.handFreeButton = button;
        }
        
    }
    
    
    //刚开始需要隐藏功能按钮，只有建立通话了才会显示
    self.callFunctionView.hidden = YES;

}

/**
 @author WLS, 15-12-14 14:14:47
 
 修改挂断按钮的frame
 */
- (void)changeHangupButtonFrame{
    
    self.hangupButton.frame = CGRectMake(CenterPoint(GetViewWidth(self.callBackView), Adaptation(60)), Adaptation(470), Adaptation(60), Adaptation(60));
    
    if (CurrentHeight == 480) {
        CGRect frame = self.hangupButton.frame;
        frame.origin.y = Adaptation(410);
        self.hangupButton.frame = frame;
    }
    /**
     @author WLS, 15-12-14 13:12:36
     
     如果接听按钮存在  则移除接听按钮
     */
    if (self.answerButton) {
        [self.incomingView removeFromSuperview];
        self.incomingView = nil;
        
        [self.answerButton removeFromSuperview];
        self.answerButton = nil;
    }
    
}


/**
 @author WLS, 15-12-19 15:12:13
 
 被叫的初始界面
 */
- (void)makeIncomingView{
    
    self.incomingView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.incomingView.backgroundColor = self.backgroundView.backgroundColor;
    [self.backgroundView addSubview:self.incomingView];
    
    
    /**
     @author WLS, 15-12-11 11:21:59
     
     头像
     */
    UIImageView * iconView = [[UIImageView alloc] initWithFrame:CGRectMake(CenterPoint(GetViewWidth(self.incomingView), Adaptation(110)), Adaptation(90), Adaptation(110), Adaptation(110))];
    iconView.layer.cornerRadius = GetViewHeight(iconView)/2.0;
    iconView.layer.masksToBounds = YES;
    iconView.image = [UIImage imageNamed:@"默认头像"];
    [self.incomingView addSubview:iconView];
    
    if (CurrentHeight == 480) {
        CGRect frame = iconView.frame;
        frame.origin.y = Adaptation(60);
        iconView.frame = frame;
    }
    
    
    /**
     @author WLS, 15-12-11 11:21:59
     
     来电号码或者被叫号码
     */
    UILabel * voipNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Adaptation(215),GetViewWidth(self.incomingView), Adaptation(20))];
    voipNumberLabel.font = [UIFont systemFontOfSize:GetTextFont(21)];
    voipNumberLabel.textAlignment = NSTextAlignmentCenter;
    voipNumberLabel.textColor = [UIColor whiteColor];
    voipNumberLabel.text = self.callerName;
    [self.incomingView addSubview:voipNumberLabel];
    if (CurrentHeight == 480) {
        CGRect frame = voipNumberLabel.frame;
        frame.origin.y = Adaptation(180);
        voipNumberLabel.frame = frame;
    }
    
    
    
    /**
     @author WLS, 15-12-11 11:21:59
     
     对方通话状态或者时间
     */
    UIButton * callTimeLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    callTimeLabel.enabled = NO;
    callTimeLabel.frame = CGRectMake(GetViewX(voipNumberLabel), GetViewHeight(voipNumberLabel)+GetViewY(voipNumberLabel)+ Adaptation(5), GetViewWidth(voipNumberLabel), Adaptation(20));
    callTimeLabel.titleLabel.font = [UIFont systemFontOfSize:GetTextFont(13)];
    [callTimeLabel setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [callTimeLabel setTitle:@"视频聊天" forState:UIControlStateDisabled];
    if ([[UCSTcpClient sharedTcpClientManager] getCurrentNetWorkStatus]==UCSReachableVia2G) {
        [callTimeLabel setTitle:@"视频聊天(当前网络状态差)" forState:UIControlStateDisabled];
        
    }
    self.callTimeLabel= callTimeLabel;
    [self.incomingView addSubview:callTimeLabel];
    
    
    
    /**
     @author WLS, 15-12-11 11:21:59
     
     挂断按钮如果是来电，则还有接听按钮
     */
    UIButton *hangupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hangupButton addTarget:self action:@selector(hangupCall) forControlEvents:UIControlEventTouchUpInside];
    [hangupButton setImage:[UIImage imageNamed:@"挂断"] forState:UIControlStateNormal];
    [hangupButton setImage:[UIImage imageNamed:@"挂断-down"] forState:UIControlStateDisabled];
    [self.incomingView addSubview:hangupButton];
    if (self.incomingCall) {
        UIButton *answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [answerButton setImage:[UIImage imageNamed:@"接听"] forState:UIControlStateNormal];
        [answerButton setImage:[UIImage imageNamed:@"接听-down"] forState:UIControlStateDisabled];
        [answerButton addTarget:self action:@selector(answerCall) forControlEvents:UIControlEventTouchUpInside];
        [self.incomingView addSubview:answerButton];
        
        hangupButton.frame = CGRectMake((GetViewWidth(self.incomingView)-Adaptation(60)*2)/3, Adaptation(470), Adaptation(60), Adaptation(60));
        answerButton.frame = CGRectMake(GetViewWidth(hangupButton)+GetViewX(hangupButton)*2, Adaptation(470), GetViewWidth(hangupButton), GetViewHeight(hangupButton));
        if (CurrentHeight == 480) {
            CGRect frame = hangupButton.frame;
            frame.origin.y = Adaptation(410);
            hangupButton.frame = frame;
            
            
            frame = answerButton.frame;
            frame.origin.y = Adaptation(410);
            answerButton.frame = frame;
            
        }
    }
    
    
   
    
}

- (UILabel *)informationLabel{
    if (_informationLabel == nil) {
        _informationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GetViewHeight(self.netWorkStatusLabel)+GetViewY(self.netWorkStatusLabel)+Adaptation(5), CurrentWidth, Adaptation(300))];
        _informationLabel.numberOfLines = 0;
        _informationLabel.hidden = YES;
        _informationLabel.font = [UIFont systemFontOfSize:GetTextFont(12)];
        _informationLabel.textColor = [UIColor redColor];
        _informationLabel.backgroundColor = [UIColor clearColor];
    }
    return _informationLabel;
}

- (void)disableAllButton{
    
    
    self.switchCameraButton.enabled = NO;
    
    self.muteButton.enabled = NO;
    
    self.closeCameraButton.enabled = NO;

    self.handFreeButton.enabled = NO;
    
    self.hangupButton.enabled = NO;
    
    self.answerButton.enabled = NO;
}


#pragma mark - 生命周期
- (void)dealloc
{
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self removeRotation];
    
    [self.hangupButton removeFromSuperview];
    self.hangupButton = nil;
    
    [self.voipNumberLabel removeFromSuperview];
    self.voipNumberLabel = nil;
    
    [self.callTimeLabel removeFromSuperview];
    self.callTimeLabel = nil;
    
    [self.handFreeButton removeFromSuperview];
    self.handFreeButton = nil;
    
    [self.closeCameraButton removeFromSuperview];
    self.closeCameraButton = nil;
    
    [self.muteButton removeFromSuperview];
    self.muteButton = nil;
    
    [self.switchCameraButton removeFromSuperview];
    self.switchCameraButton = nil;
    
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
    

    self.callID = nil;
    self.callerName = nil;
    self.voipNo = nil;
    

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

- (void)VideoStart
{
//    UCSVideoRecordAttr * ucsVideoRecordAttr = [[UCSVideoRecordAttr alloc]init];
//
//
//    ucsVideoRecordAttr.uWidth = 480; //录制视频分辨率 eg:480
//    ucsVideoRecordAttr.uHeight = 640; //录制视频分辨率 高 eg:640
//    ucsVideoRecordAttr.uBitrate = 500; //录制视频码率 eg:500
//    ucsVideoRecordAttr.uFramerate = 12; //录制视频帧率 eg: 12
//    ucsVideoRecordAttr.uiDirect = 0; //录制视频方向:录制远端视频:0 录制本地端视频:1
//
//    ucsVideoRecordAttr.ufileName = [self getRecordFileWithNickName:@"远端视频"];//录制视频存放的路径,视频后缀名仅支持.mp4(此路径包含文件名,eg: /Documents/远端视频录
//
//
//     [[UCSFuncEngine getInstance] videoRecordStart:ucsVideoRecordAttr];
    
    
     //以下为截图功能调测
//    NSString *ufileName = [self getRecordFileWithPath:@"远端截图"];
//
//    [[UCSFuncEngine getInstance]  cameraCapture:0 withFileName:@"ydjt" withSavePath:ufileName];

}

- (void)VideoStop
{
//     [[UCSFuncEngine getInstance] videoRecordStop];
}

- (NSString *)getRecordFileWithNickName:(NSString *)nickName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"recordFile"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    if ([fileManager fileExistsAtPath:documentsDirectory]) {
        [fileManager removeItemAtPath:documentsDirectory error:nil];
    }
    
    NSError *err = nil;
    [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&err];
    
    NSString *filePathMe = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.mp4",nickName,[self getNowTime]]];
    
    [fileManager createFileAtPath:filePathMe contents:nil attributes:nil];
    
    
    if (err) {
        return nil;
    }
    
    
    return filePathMe;
}


- (NSString *)getRecordFileWithPath:(NSString *)nickName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"recordImageFile"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    if ([fileManager fileExistsAtPath:documentsDirectory]) {
        [fileManager removeItemAtPath:documentsDirectory error:nil];
    }
    
    NSError *err = nil;
    [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&err];
    
 
    
    
    
    if (err) {
        return nil;
    }
    
    
    return documentsDirectory;
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


- (TCVideoCallController *)initWithCallerName:(NSString *)name  andVoipNo:(NSString *)voipNo{
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    self.currentTime = [NSString stringWithFormat:@"%ld",time(NULL)];
    self.hangupMySelf = NO;
    

    
    
    [self makeVideoCallView];
    
    if (self.incomingCall) {
        [self makeIncomingView];
    }
    
    
    /**
     @author WLS, 15-12-14 12:12:42
     
     注册旋转通知
    */
    [self registerRotation:@selector(getRotationAngle)];
    
    
    // 设置不自动进入锁屏待机状态
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    // 需要在通话中成为firstResponder，否则切换回前台后，听不到声音
    [self becomeFirstResponder];
    
    
    [[UCSFuncEngine getInstance] initCameraConfig:self.videoLocationView withRemoteVideoView:self.videoRemoteView withRender:RENDER_HALFFULLSCREEN];

    
    [self addNotification];
    // 添加1个手指5次点击事件
    UITapGestureRecognizer * thirdTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdTap:)];
    thirdTap.numberOfTapsRequired = 5;
    thirdTap.numberOfTouchesRequired = 1;
    [self.videoLocationView addGestureRecognizer:thirdTap];
    // 添加信息label
    [self.view addSubview:self.informationLabel];
}




// 需要在通话中成为firstResponder，否则切换回前台后，听不到声音
- (BOOL)canBecomeFirstResponder {
    return YES;
}




- (void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [super viewWillAppear:animated];
    
        _landscape = [self getAppRotation];//获取应用横竖屏状态
    
    if (self.isActivity) {

        //从后台进入前台 强制设置为前置摄像头 (WLS)
        [[UCSFuncEngine getInstance] switchCameraDevice:CAMERA_FRONT];

    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    //     [self.ucsFuncEngine setCameraTorchMode:NO];//设置闪光为关闭状态
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //globalisVoipView = NO;
    [super viewDidDisappear:animated];
    
    // 设置不自动进入锁屏待机状态
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    // 需要在通话中成为firstResponder，否则切换回前台后，听不到声音
    [self resignFirstResponder];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.ƒ
}



#pragma mark - 按钮点击事件
- (void)funtionButtonClick:(UIButton *)button{
    switch (button.tag) {
        case 0:{
            [self muteButtonClicked];
            
        }
            break;
        case 1:{
            [self cameraButtonClicked];
        }
            break;
        case 2:{
            [self handfreeButtonClicked];
        }
            break;
        default:
            break;
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
//    [self.callTimeLabel setTitle:@"正在挂机" forState:UIControlStateDisabled];
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


/**
 @author WLS, 15-12-14 15:12:51
 
 切换摄像头
 */
- (void)switchCameraButtonClick:(UIButton *)button{
    if (button.tag == 1) {
        /**
         @author WLS, 15-12-14 15:12:42
         
         后置摄像头
         */
        [[UCSFuncEngine getInstance] switchCameraDevice:CAMERA_REAR];
        button.tag = 0;
    }else if (button.tag == 0){
        /**
         @author WLS, 15-12-14 15:12:49
         
         前置摄像头
         */
        [[UCSFuncEngine getInstance] switchCameraDevice:CAMERA_FRONT];
        button.tag = 1;
        
    }
    
    
}

#pragma mark - 功能
// 1个手指 5击事件
- (void)thirdTap:(UITapGestureRecognizer *)thirdTap{
    NSLog(@"1个触摸点 5次点击事件触发");
    if(self.informationLabel.hidden == YES){//当音视频质量参数处于隐藏状态时显示，处于显示时隐藏
        
        self.informationLabel.hidden = NO;
    }else{
        self.informationLabel.hidden = YES;
    }
    
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    UITouch * touch = [touches anyObject];
    if (touch.view == self.videoLocationView && self.informationLabel.hidden == NO) {
        
        self.informationLabel.hidden = YES;
        return;
    }
    
    if (self.callFunctionView.hidden) {
        /**
         @author WLS, 15-12-14 17:12:16
         
         不处于通话中，未接听
         */
        
    }else{
        /**
         @author WLS, 15-12-14 17:12:16
         
         通话中，已接听
         */
        self.callBackView.hidden = !self.callBackView.hidden;
        
    }
    
}
//免提事件
- (void)handfreeButtonClicked
{
    //耳机插入的情况下，免提开关失效
    if (self.isCallNow ==NO) {
        return;
    }
    self.handFreeButton.selected = !self.handFreeButton.selected;
    [[UCSFuncEngine getInstance] setSpeakerphone:self.handFreeButton.selected];

}
//静音事件
- (void)muteButtonClicked
{
    if (self.isCallNow ==NO) {
        return;
    }
    
    BOOL muteFlag = [[UCSFuncEngine getInstance] isMicMute];
    if (muteFlag == NO) {
        self.muteButton.selected = YES;;
        [[UCSFuncEngine getInstance] setMicMute:YES];//设置为静音
    }
    else
    {
        self.muteButton.selected = NO;;
        [[UCSFuncEngine getInstance] setMicMute:NO];//设置为非静音
    }
    
}


//关闭摄像头
- (void)cameraButtonClicked{
    
    if (self.isCallNow == NO) {
        return;
    }
    
    self.closeCameraButton.selected = !self.closeCameraButton.selected;
    if (self.closeCameraButton.selected) {
        //关闭
        [[UCSFuncEngine getInstance] switchVideoMode:CAMERA_RECEIVE];

    }else{
        //打开
        [[UCSFuncEngine getInstance] switchVideoMode:CAMERA_NORMAL];

    }
    
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
 @author WLS, 15-12-14 15:12:34
 
 旋转屏幕角度
 
 @param rotationAngle 角度
 */
- (void)rotationCameraAngle:(unsigned int) landscape  andlocalRotationAngle:(unsigned int)rotationAngle{
    
    [[UCSFuncEngine getInstance] setRotationVideo:landscape andRecivied:rotationAngle];
    
}





#pragma mark - ModelEngineUIDelegate

//收到视频来电预览图片时回调
- (void)onReceivedPreviewImg:(UIImage *)image  callid:(NSString *)callid error:(NSError *)error{
    
    //预览图
    if(!error){
        _previewImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _previewImageView.contentMode =UIViewContentModeScaleToFill;
        _previewImageView.image = image;
        [self.incomingView insertSubview:_previewImageView atIndex:0];
    }
}


/**
 @author WLS, 15-12-19 15:12:49
 
 网络状态回调
 
 @param currentNetwork 当前的网络状态
 */
- (void)networkStatusChange:(NSInteger)currentNetwork{
    NSString * imageStr = nil;
    BOOL isHiddenNetworkStatus = YES;
    NSString * networkStatusTips = nil;
    
    switch (currentNetwork) {
        case UCSNetwork_Bad:
        {
            //差
            imageStr = @"视频信号-无";
            
            isHiddenNetworkStatus = NO; //是否显示网络状态提示语
            networkStatusTips = @"当前通话网络状况不佳";
        }
            break;
        case UCSNetwork_General:
        {
            //一般
            imageStr = @"视频信号1";

            
        }
            break;
        case UCSNetwork_Nice:
        {
            //良好
            imageStr = @"视频信号2";
            
        }
            break;
        case UCSNetwork_Well:
        {
            //优秀
            imageStr = @"视频信号3";

        }
            break;
        default:
            break;
    }
    [self.callTimeLabel setImage:[UIImage imageNamed:imageStr] forState:UIControlStateDisabled];
    
    self.netWorkStatusLabel.hidden = isHiddenNetworkStatus;
    [self.netWorkStatusLabel setTitle:networkStatusTips forState:UIControlStateDisabled];
    
}

- (void)networkDetailChange:(NSString *)currentNetworkDetail{
    
    self.informationLabel.text = [NSString stringWithFormat:@"%@\nCPU : %0.2f",currentNetworkDetail,[self getCurrentCPU]*100];
    
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
           [self VideoStart];//开始视频录制
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
            
            
            /**
             @author WLS, 15-12-11 17:12:12
             
             当通话接通后，显示功能按钮，并调整挂断按钮的位置
             */
            self.callFunctionView.hidden = NO;
            self.switchCameraButton.hidden = NO;
            
            
            
            
            
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
            
            [self changeHangupButtonFrame];
            
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
            [self VideoStop];//结束视频录制
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//注册旋转通知 add by WLS
-(void)registerRotation:(SEL)method
{
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:method
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
}
//删除旋转通知 add by WLS
-(void)removeRotation
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}


//获取屏幕旋转 add by WLS
- (void)getRotationAngle{
    //获得设备方向
//    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
//    
//    if (deviceOrientation == UIDeviceOrientationPortrait) {
//        //竖屏  home键在底部
//        [self rotationCameraAngle:0 andlocalRotationAngle:0];
//        
//    }
//    else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown) {
//        //竖屏  home键在顶部
//        [self rotationCameraAngle:0 andlocalRotationAngle:180];
//        
//    }
//    else if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
//        //横屏 home键再左边
//        [self rotationCameraAngle:1 andlocalRotationAngle:90];
//    }
//    else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
//        [self rotationCameraAngle:1 andlocalRotationAngle:270];
//    }else{
//        
//        [self rotationCameraAngle:0 andlocalRotationAngle:0];
//        
//    }
    
    
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    
    switch (orient)
    {//竖屏  home键在底部
        case UIDeviceOrientationPortrait:
            [self rotationCameraAngle:_landscape andlocalRotationAngle:0];
            break;
            //横屏 home键再左边
        case UIDeviceOrientationLandscapeLeft:
            [self rotationCameraAngle:_landscape andlocalRotationAngle:90];
            break;
            //竖屏  home键在顶部
        case UIDeviceOrientationPortraitUpsideDown:
            [self rotationCameraAngle:_landscape andlocalRotationAngle:180];
            break;
            //横屏 home键再右边
        case UIDeviceOrientationLandscapeRight:
            [self rotationCameraAngle:_landscape andlocalRotationAngle:270];
            break;
            
        default:
            break;
    }
    
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


- (float)getCurrentCPU{
    kern_return_t			kr = { 0 };
    task_info_data_t		tinfo = { 0 };
    mach_msg_type_number_t	task_info_count = TASK_INFO_MAX;
    
    kr = task_info( mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    task_basic_info_t		basic_info = { 0 };
    thread_array_t			thread_list = { 0 };
    mach_msg_type_number_t	thread_count = { 0 };
    
    thread_info_data_t		thinfo = { 0 };
    thread_basic_info_t		basic_info_th = { 0 };
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads( mach_task_self(), &thread_list, &thread_count );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    long	tot_sec = 0;
    long	tot_usec = 0;
    float	tot_cpu = 0;
    
    for ( int i = 0; i < thread_count; i++ )
    {
        mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
        
        kr = thread_info( thread_list[i], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count );
        if ( KERN_SUCCESS != kr )
            return 0.0f;
        
        basic_info_th = (thread_basic_info_t)thinfo;
        if ( 0 == (basic_info_th->flags & TH_FLAGS_IDLE) )
        {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
    }
    
    kr = vm_deallocate( mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t) );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    return tot_cpu;
}


//获取应用横竖屏方向
- (int)getAppRotation
{
    //AVCaptureVideoOrientation appRotation;
    int appRotation;
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortrait:
#if defined(__IPHONE_8_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
        case UIInterfaceOrientationUnknown:
#endif
            appRotation = 0;//AVCaptureVideoOrientationPortrait;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            appRotation = 2;//AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            appRotation = 3;//AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIInterfaceOrientationLandscapeRight:
            appRotation = 1;//AVCaptureVideoOrientationLandscapeRight;
            break;
    }
    return (int)appRotation;
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
