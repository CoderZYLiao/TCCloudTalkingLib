//
//  TCVoiceUnlockViewController.m
//  TCCloudTalking_Example
//
//  Created by Huang ZhiBin on 2019/12/2.
//  Copyright © 2019年 TYL. All rights reserved.
//

#import "TCVoiceUnlockViewController.h"
#import "BTCoverVerticalTransition.h"
#import "IFlyMSC/IFlyMSC.h"
#import "ISRDataHelper.h"
#import "Header.h"
#import "TCOpenDoorTool.h"

@interface TCVoiceUnlockViewController ()<IFlySpeechRecognizerDelegate>
//科大讯飞识别
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (nonatomic, strong) BTCoverVerticalTransition *aniamtion;
@property (nonatomic, strong) NSFileHandle *fileHandler;
@property (nonatomic, strong) NSString * result;
//动画
@property (nonatomic , strong) CAReplicatorLayer *musicLayer;
//识别内容
@property (weak, nonatomic) UITextView *textView;
//提示文字
@property (nonatomic , strong)UILabel *Tiplabel;
@property (nonatomic , strong)UIButton *SpeakBtn;
@end

@implementation TCVoiceUnlockViewController

- (instancetype)init{
    
    if (self) {
        _aniamtion = [[BTCoverVerticalTransition alloc]initPresentViewController:self withRragDismissEnabal:YES];
        self.transitioningDelegate = _aniamtion;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s",__func__);
    
    [super viewWillAppear:animated];
    

    //科大讯飞初始护
    [self initRecognizer];
    
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0];
    self.textView.text = @"请说,我在听";
    //一起入启动
    BOOL ret = [_iFlySpeechRecognizer startListening];
    
    if (ret) {
        
    }else{
        self.textView.text = @"启动识别服务失败，请稍后重试!";
        NSLog(@"启动识别服务失败，请稍后重试!");
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%s",__func__);

    [_iFlySpeechRecognizer cancel];
    [_iFlySpeechRecognizer setDelegate:nil];
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:1];
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 330);
    
    [self makeRoundedCorner:20.0f];

    [self initUI];
    
}

- (void)delayMethod
{
    
    [self.textView setText:@""];
    self.Tiplabel.hidden = YES;
}

- (void)initUI
{
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.leading.trailing.top.bottom.equalTo(self.view);
        }
    }];
    
    UIButton *canceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:canceButton];
    [canceButton addTarget:self action:@selector(canceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [canceButton setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_quxiao"] forState:UIControlStateNormal];
    [canceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(30);
        make.right.equalTo(view).offset(-30);
        make.width.height.equalTo(@32);
        
    }];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.textAlignment =  NSTextAlignmentCenter;
    textView.font = [UIFont fontWithName:@"PingFang TC" size:20];
    textView.textColor = [UIColor colorWithRed:64/255.0 green:115/255.0 blue:242/255.0 alpha:1/1.0];
    
    self.textView = textView;
    [view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(canceButton.mas_bottom).offset(20);
        make.left.equalTo(view).offset(30);
        make.right.equalTo(view).offset(-30);
        make.height.mas_equalTo(60);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    self.Tiplabel = label;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(20);
        make.left.equalTo(view).offset(30);
        make.right.equalTo(view).offset(-30);
        make.height.mas_equalTo(40);
    }];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"你可以试试这样说:开锁";
    label.textAlignment =  NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"PingFang TC" size:13];
    label.textColor = [UIColor colorWithRed:64/255.0 green:115/255.0 blue:242/255.0 alpha:1/1.0];
    label.textColor = [UIColor blackColor];
    
    UIButton *SpeakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.SpeakBtn = SpeakBtn;
    SpeakBtn.backgroundColor = [UIColor colorWithRed:64/255.0 green:115/255.0 blue:242/255.0 alpha:1/1.0];
    [SpeakBtn setTitle:@"Speaking" forState:UIControlStateNormal];
    [SpeakBtn setTitle:@"Start" forState:UIControlStateSelected];
    [view addSubview:SpeakBtn];
    [SpeakBtn addTarget:self action:@selector(SpeakBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [SpeakBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(60);
        make.right.equalTo(view).offset(-60);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(view).offset(TCBottomTabH+20);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(view).offset(20);
        }
    }];
    
}

- (void)SpeakBtnClick
{
    self.SpeakBtn.selected = !self.SpeakBtn.selected;
    if (!self.SpeakBtn.selected) {
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0];
        self.Tiplabel.hidden = NO;
        self.textView.text = @"请说,我在听";
        //一起入启动
        BOOL ret = [_iFlySpeechRecognizer startListening];
        
        if (ret) {
            
            
        }else{
            self.textView.text = @"启动识别服务失败，请稍后重试!";
            NSLog(@"启动识别服务失败，请稍后重试!");
        }
    }else
    {
        
    }
}


#pragma mark - Initialization

/**
 initialize recognition conctol and set recognition params
 **/
-(void)initRecognizer
{
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
    }
    
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    //set recognition domain
    [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    
    _iFlySpeechRecognizer.delegate = self;
    
    if (_iFlySpeechRecognizer != nil) {
        
        //set network timeout
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        
    }
}

//IFlySpeechRecognizerDelegate协议实现
//识别结果返回代理
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    _result =[NSString stringWithFormat:@"%@%@", self.textView.text,resultString];
    
    NSString * resultFromJson = [ISRDataHelper stringFromJson:resultString];
    self.textView.text = [NSString stringWithFormat:@"%@%@", self.textView.text,resultFromJson];
    
    if (isLast){
        NSLog(@"ISR Results(json)：%@",  self.result);
        self.SpeakBtn.selected = YES;
        [self dealWithResult:self.textView.text];
        
    }
    NSLog(@"_result=%@",_result);
    NSLog(@"resultFromJson=%@",resultFromJson);
    NSLog(@"isLast=%d,_textView.text=%@",isLast,self.textView.text);
}
//识别会话结束返回代理
- (void)onCompleted: (IFlySpeechError *) error{
    
    NSString *text ;
    if (error.errorCode == 0 ) {
        if (_result.length == 0) {
            text = @"无识别结果";
        }else {
            text = @"识别成功";
            //empty results
            _result = nil;
        }
    }else {
        text = [NSString stringWithFormat:@"Error：%d %@", error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
    }
}
//停止录音回调
- (void) onEndOfSpeech{
    NSLog(@"onEndOfSpeech");
}
//开始录音回调
- (void) onBeginOfSpeech{
    NSLog(@"onBeginOfSpeech");
}
//音量回调函数
- (void) onVolumeChanged: (int)volume{
    
}
//会话取消回调
- (void) onCancel{
    NSLog(@"Recognition is cancelled");
}

#pragma mark --点击取消按钮
- (void)canceBtnClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)makeRoundedCorner:(CGFloat)cornerRadius {
    
    CALayer *roundedlayer = [self.view layer];
    [roundedlayer setMasksToBounds:YES];
    [roundedlayer setCornerRadius:cornerRadius];
}


- (void)dealWithResult:(NSString *)Result
{
    if ([Result containsString:@"开锁"]||([Result containsString:@"门"]&&[Result containsString:@"开"])) {
        NSLog(@"开锁");
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else
    {
        [self.textView setText:@"抱歉,未找到相关指令!"];
        self.Tiplabel.hidden = NO;
    }
}

- (void)openDoor
{
    NSArray *doorArray = [TCCloudTalkingTool getMachineDataArray];
    if (doorArray.count == 0) {
        
        [self.textView setText:@"抱歉,您还未绑定门口机!"];
        
    }else{
        
        NSDictionary *dict = doorArray.firstObject;
        [TCOpenDoorTool openTheDoorWithID:[dict objectForKey:@"num"]];
    }
}


- (void)musicReplicatorLayer
{
    _musicLayer = [CAReplicatorLayer layer];
    _musicLayer.frame = CGRectMake(0, 0, 200, 50);
    _musicLayer.position = self.view.center;
    //设置复制层里面包含的子层个数
    _musicLayer.instanceCount = 20;
    //设置下个子层相对于前一个的偏移量
    _musicLayer.instanceTransform = CATransform3DMakeTranslation(10, 0, 0);     //每个layer的间距。
    //设置下一个层相对于前一个的延迟时间
    _musicLayer.instanceDelay = 0.2;
    _musicLayer.backgroundColor = [UIColor redColor].CGColor;
    _musicLayer.masksToBounds = YES;
    [self.view.layer addSublayer:_musicLayer];
    
    CALayer *tLayer = [CALayer layer];
    tLayer.frame = CGRectMake(10, 20, 5, 40);
    tLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [_musicLayer addSublayer:tLayer];
    
    CABasicAnimation *musicAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    musicAnimation.duration = 0.35;
    musicAnimation.fromValue = @(tLayer.frame.size.height);
    //    musicAnimation.toValue = @(tLayer.frame.size.height - 10);
    musicAnimation.byValue = @(20);
    musicAnimation.autoreverses = YES;
    musicAnimation.repeatCount = MAXFLOAT;
    musicAnimation.beginTime = -2;
    musicAnimation.removedOnCompletion = NO;
    [tLayer addAnimation:musicAnimation forKey:@"musicAnimation"];
}

@end
