//
//  JCDoorVideoCallController.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2020/7/9.
//

#import "JCDoorVideoCallController.h"
#import "TYLVerticalButton.h"
#import "Header.h"

@interface JCDoorVideoCallController ()
{
    JCMediaDeviceVideoCanvas* _localCanvas;
    JCMediaDeviceVideoCanvas* _remoteCanvas;
    NSTimer* _timer;
}

@property (strong,nonatomic) UIImageView *backgroundView; //背景视图

@property (strong,nonatomic) UIButton *JChangupButton; //挂断按钮
@property (strong,nonatomic) UILabel  *JCcallNumberLabel; //对方号码标题
@property (strong,nonatomic) UIButton *JCcallTimeLabel; //通话时间标题
@property (strong,nonatomic) UIButton *JCnetWorkStatusLabel; //当前网络状态显示
@property (strong,nonatomic) UIButton *JChandFreeButton; //免提按钮
@property (strong,nonatomic) UIButton *JCanswerButton; //接听按钮(被叫使用)
@property (strong,nonatomic) UIButton *JCopenDoorButton; // 开锁按钮

@property (strong,nonatomic) UIView *videoRemoteView; // WLS，2015-12-14，远程视频视图

@property (assign,nonatomic) BOOL incomingCall; //(处于被叫界面)

@property (nonatomic,retain) NSString *callID;
@property (nonatomic,retain) NSString *callerName;
@end

@implementation JCDoorVideoCallController

- (JCDoorVideoCallController *)initWithCallerItem:(JCCallItem *)item{
    if (self = [super init])
    {
        self.callerName = item.displayName;
        self.incomingCall = item.direction == JCCallDirectionIn;
        return self;
    }
    
    return nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVideoUI:) name:kCallNotification object:nil];
    
    [self setUpCallViewUI];
    // 设置通话过程中自动感应，黑屏，避免耳朵按到其他按键
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    // 设置不自动进入锁屏待机状态
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    // 需要在通话中成为firstResponder，否则切换回前台后，听不到声音
    [self becomeFirstResponder];
    
    
}

- (void)updateVideoUI:(NSNotification *)noti
{
    if (JCManager.shared.call.callItems.count == 1) {
        // 单路
        JCCallItem *activeCall = JCManager.shared.call.callItems.firstObject;
        NSInteger callNum = JCManager.shared.call.callItems.count;
        if (callNum == 0 && _timer != nil) {
            [self stopCallInfoTimer];
            
        } else if (callNum > 0 && _timer == nil) {
            [self startCallInfoTimer];
        }
        
        if (activeCall.state == JCCallStatePending) {
            if (activeCall.video) {
//                if (_localCanvas == nil && activeCall.uploadVideoStreamSelf) {
//                    _localCanvas = [JCManager.shared.mediaDevice startCameraVideo:JCMediaDeviceRenderFullContent];
//                    _localCanvas.videoView.frame = CGRectMake(0, 0, 0, 1);
//                    [self.view insertSubview:_localCanvas.videoView aboveSubview:self.backgroundView];
//                } else if (_localCanvas != nil && !activeCall.uploadVideoStreamSelf) {
//                    [JCManager.shared.mediaDevice stopVideo:_localCanvas];
//                    [_localCanvas.videoView removeFromSuperview];
//                    _localCanvas = nil;
//                }
            }
            
        } else if (activeCall.state == JCCallStateTalking) {
            if (activeCall.video) {
                if (_remoteCanvas == nil && activeCall.uploadVideoStreamOther) {
                    _remoteCanvas = [JCManager.shared.mediaDevice startVideo:activeCall.renderId renderType:JCMediaDeviceRenderFullContent];
                    _remoteCanvas.videoView.frame = self.view.frame;
                    [self.view insertSubview:_remoteCanvas.videoView aboveSubview:self.backgroundView];
                } else if (_remoteCanvas != nil && !activeCall.uploadVideoStreamOther) {
                    [JCManager.shared.mediaDevice stopVideo:_remoteCanvas];
                    [_remoteCanvas.videoView removeFromSuperview];
                    _remoteCanvas = nil;
                }
            }
        } else {
            
        }
        
        
        if (!activeCall.video) {
            [self removeCanvas];
        }
    }  else {
        [self removeCanvas];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setUpCallViewUI
{
    //背景视图
    UIImageView *imageView = [[UIImageView alloc] init];
    self.backgroundView = imageView;
    self.backgroundView.image = [TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_对讲bg"];
    self.backgroundView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    
    
    //来电号码或者被叫号码
    UILabel *JCcallNumberLabel =[[UILabel alloc] init];
    self.JCcallNumberLabel = JCcallNumberLabel;
    [self.view addSubview:JCcallNumberLabel];
    self.JCcallNumberLabel.font = [UIFont systemFontOfSize:GetTextFont(21)];
    self.JCcallNumberLabel.textColor = [UIColor whiteColor];
    self.JCcallNumberLabel.text = self.callerName ? self.callerName :self.callID;
    [JCcallNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(TCNaviH-20);
        make.centerX.equalTo(self.view);
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
            self.JChangupButton = btn;
        }else if (i == 1){
            self.JCopenDoorButton = btn;
        }else{
            self.JCanswerButton = btn;
            
        }
    }
    
    
    //水平方向控件间隔固定等间隔
    [tolAry mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:49 leadSpacing:40 tailSpacing:40];
    [tolAry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-10);
        make.height.equalTo(@110);
    }];
    
    
    
    //显示呼叫状态、通话状态、显示通话时间的按钮
    UIButton *JCcallTimeLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.JCcallTimeLabel = JCcallTimeLabel;
    [self.view addSubview:JCcallTimeLabel];
    self.JCcallTimeLabel.enabled = NO;
    self.JCcallTimeLabel.titleLabel.font = [UIFont systemFontOfSize:GetTextFont(13)];
    self.JCcallTimeLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.JCcallTimeLabel setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.JCcallTimeLabel setTitle:@"呼叫请求中" forState:UIControlStateDisabled];
    [JCcallTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(JCcallNumberLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    if (self.incomingCall) {
        //如果处于来电状态 则通话状态的标题暂时先隐藏 ，等到通话建立起来，在显示
        self.JCcallTimeLabel.hidden = YES;
        
    }
    
    //显示通话中网络状态
    UIButton *JCnetWorkStatusLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.JCnetWorkStatusLabel = JCnetWorkStatusLabel;
    self.JCnetWorkStatusLabel.enabled = NO;
    self.JCnetWorkStatusLabel.titleLabel.font = [UIFont systemFontOfSize:GetTextFont(13)];
    self.JCnetWorkStatusLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.JCnetWorkStatusLabel setTitle:@"" forState:UIControlStateDisabled];
    [self.view addSubview:JCnetWorkStatusLabel];
    [JCnetWorkStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.JCopenDoorButton.mas_top).offset(-20);
        make.centerX.equalTo(self.view);
    }];
    if (self.incomingCall) {
        //如果处于来电状态 则通话中网络状态暂时先隐藏 ，等到通话建立起来，在显示
        self.JCnetWorkStatusLabel.hidden = YES;
        
    }
}


#pragma mark - 按钮点击事件
- (void)funtionButtonClick:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"挂断"]) {
        
        [JCManager.shared.call term:[self getActiveCall] reason:JCCallReasonNone description:@"test"];
        
    }else if([button.titleLabel.text isEqualToString:@"开锁"])
    {
        
        
    }else if([button.titleLabel.text isEqualToString:@"免提"])
    {
        
    }else
    {
        [self answerCall];
        
    }
    
    
    
}


- (void)answerCall
{
    [JCManager.shared.call answer:[self getActiveCall] video:true];
}

-(void)removeCanvas
{
    if (_localCanvas) {
        [JCManager.shared.mediaDevice stopVideo:_localCanvas];
        [_localCanvas.videoView removeFromSuperview];
        _localCanvas = nil;
    }
    if (_remoteCanvas) {
        [JCManager.shared.mediaDevice stopVideo:_remoteCanvas];
        [_remoteCanvas.videoView removeFromSuperview];
        _remoteCanvas = nil;
    }
}

#pragma mark - 工具函数

-(JCCallItem*)getActiveCall
{
    for (JCCallItem* item in JCManager.shared.call.callItems) {
        if (item.active) {
            return item;
        }
    }
    return nil;
}

#pragma mark - Timer

-(void)startCallInfoTimer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerProc) userInfo:nil repeats:YES];
    }
}

-(void)stopCallInfoTimer
{
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

-(void)timerProc
{
    NSInteger callNum = JCManager.shared.call.callItems.count;
    JCCallItem* item = [JCManager.shared.call getActiveCallItem];
    if (item != nil) {
        if (callNum == 1) {
            //更新网络状态
            [self genNetStatus:item];
            debugLog(@"----%@",[self genCallInfo:item]);
            self.JCcallTimeLabel.hidden = NO;
            [_JCcallTimeLabel setTitle:[self genCallInfo:item] forState:UIControlStateDisabled];
        }
        
    }
}

- (void )genNetStatus:(JCCallItem *)item {
    NSString * networkStatusTips = nil;
    if (item.videoNetReceiveStatus != JCCallStateTalking) {
        
    }
    switch (item.videoNetReceiveStatus) {
        case JCCallNetWorkDisconnected:
            {
                //差
                networkStatusTips = @"当前通话网络状况不佳";
                [self.JCnetWorkStatusLabel setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
            }
                break;
        case JCCallNetWorkVeryBad:
            {
                //差
                networkStatusTips = @"当前通话网络状况不佳";
                [self.JCnetWorkStatusLabel setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
            }
                break;
        case JCCallNetWorkBad:
            {
                //差
                networkStatusTips = @"当前通话网络状况不佳";
                [self.JCnetWorkStatusLabel setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
            }
                break;
        case JCCallNetWorkNormal:
            {
                //一般
                networkStatusTips = @"当前通话网络状况一般";
                [self.JCnetWorkStatusLabel setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
                
            }
                break;
        case JCCallNetWorkGood:
            {
                //良好
                networkStatusTips = @"当前通话网络状况良好";
                [self.JCnetWorkStatusLabel setTitleColor:[UIColor greenColor] forState:UIControlStateDisabled];
            }
                break;
        case JCCallNetWorkVeryGood:
            {
                //优秀
                networkStatusTips = @"当前通话网络状况优秀";
                [self.JCnetWorkStatusLabel setTitleColor:[UIColor greenColor] forState:UIControlStateDisabled];
            }
                break;
        default:
        break;
    }
    self.JCnetWorkStatusLabel.hidden = NO;
    [self.JCnetWorkStatusLabel setTitle:networkStatusTips forState:UIControlStateDisabled];
}

- (NSString *)genCallInfo:(JCCallItem*)item {
    switch (item.state) {
        case JCCallStateInit:
            return @"呼叫中";
        case JCCallStatePending:
            return @"振铃中";
        case JCCallStateConnecting:
            return @"连接中";
        case JCCallStateTalking:
            if (item.hold) {
                return @"挂起";
            } else if (item.held) {
                return @"被挂起";
            } else if (item.otherAudioInterrupt) {
                return @"对方声音中断";
            } else {
                return [self formatTalkingTime:((long)[[NSDate date] timeIntervalSince1970] - item.talkingBeginTime)];
            }
        case JCCallStateOk:
            return @"通话结束";
        case JCCallStateCancel:
            return @"通话结束";
        case JCCallStateCanceled:
            return @"挂断";
        case JCCallStateMissed:
            return @"未接";
        default:
            return @"异常";
    }
}

- (NSString *)formatTalkingTime:(long)time
{
    return [NSString stringWithFormat:@"%02ld:%02ld", time/60, time%60];
}

#define AUDIO_RECORD_DIR @"audio_record"
#define SNAPSHOT_DIR @"snapshot"
#define VIDEO_RECORD_DIR @"video_record"

- (NSString *)generateAudioFilePath:(JCCallItem *) item
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *recordDir = [documentsPath stringByAppendingPathComponent:AUDIO_RECORD_DIR];
    if (![fileManager fileExistsAtPath:recordDir]) {
        [fileManager createDirectoryAtPath:recordDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
    return [recordDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wmv", convertedDateString]];
}

-(NSString *)generateSnapshotFilePath:(JCCallItem *)item
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *recordDir = [documentsPath stringByAppendingPathComponent:SNAPSHOT_DIR];
    if (![fileManager fileExistsAtPath:recordDir]) {
        [fileManager createDirectoryAtPath:recordDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
    return [recordDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", convertedDateString]];
}

-(NSString *)generateVideoRecordFile:(JCCallItem *)item
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *recordDir = [documentsPath stringByAppendingPathComponent:VIDEO_RECORD_DIR];
    if (![fileManager fileExistsAtPath:recordDir]) {
        [fileManager createDirectoryAtPath:recordDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
    return [recordDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", convertedDateString]];
}
@end
