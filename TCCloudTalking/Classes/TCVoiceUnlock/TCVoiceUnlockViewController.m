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
#import "UIImage+GIF.h"

@interface TCVoiceUnlockViewController ()<IFlySpeechRecognizerDelegate>
//科大讯飞识别
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (nonatomic, strong) BTCoverVerticalTransition *aniamtion;
@property (nonatomic, strong) NSFileHandle *fileHandler;
@property (nonatomic, strong) NSString * result;
@property (nonatomic, strong) NSArray *doorArray;
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
    self.textView.text = @"请说,我在聆听...";
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
    //背景颜色
    self.view.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:1];
    //设置弹出屏幕的大小
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 300);
    //获取门口机数组
    self.doorArray  = [TCCloudTalkingTool getMachineDataArray];
    //设置圆角
    [self makeRoundedCorner:20.0f];
    //UI初始化
    [self initUI];
    //提示label
    [self showTiplabel];
    
}

- (void)showTiplabel
{
    NSString *str = nil;
    if (self.doorArray.count <=1) {
        str = [NSString stringWithFormat:@"你可以试试这样说:开锁"];
    }else if(self.doorArray.count == 2){
        NSDictionary *dict = self.doorArray.firstObject;
        NSDictionary *dict1 = self.doorArray.lastObject;
        str = [NSString stringWithFormat:@"你可以试试这样说:%@开锁   %@开锁",[dict xyValueForKey:@"name"],[dict1 xyValueForKey:@"name"]];
    }else
    {
        NSDictionary *dict = self.doorArray[0];
        NSDictionary *dict1 = self.doorArray[1];
        NSDictionary *dict2 = self.doorArray[2];
        str = [NSString stringWithFormat:@"你可以试试这样说:%@开锁   %@开锁   %@开锁 ...",[dict xyValueForKey:@"name"],[dict1 xyValueForKey:@"name"],[dict2 xyValueForKey:@"name"]];
    }

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                          initWithString:str];
    [attrStr addAttribute:NSFontAttributeName value:
     [UIFont boldSystemFontOfSize:11.0f] range:NSMakeRange(0, 9)];  //字体大小为12.0f
    [attrStr addAttribute:NSForegroundColorAttributeName value:
     [UIColor colorWithHexString:@"#303133"] range:NSMakeRange(0, 9)];//添加文字颜色
    self.Tiplabel.attributedText = attrStr;
}

- (void)delayMethod
{
    
    [self.textView setText:@""];
    
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
            make.leading.trailing.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }
    }];
    
    UIButton *canceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:canceButton];
    [canceButton addTarget:self action:@selector(canceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [canceButton setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_quxiao"] forState:UIControlStateNormal];
    [canceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(13);
        make.right.equalTo(view).offset(-13);
        make.width.height.equalTo(@32);
        
    }];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.userInteractionEnabled = NO;
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
        make.top.equalTo(textView.mas_bottom).offset(-15);
        make.left.equalTo(view).offset(30);
        make.right.equalTo(view).offset(-30);
        make.height.mas_equalTo(40);
    }];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"你可以试试这样说:开锁";
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.numberOfLines = 2;
    label.textAlignment =  NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"PingFang TC" size:11];
    label.textColor = [UIColor grayColor];
    
    UIButton *SpeakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.SpeakBtn = SpeakBtn;
    SpeakBtn.backgroundColor = [UIColor whiteColor];
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"TCCloudTalking" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    NSString *imagePath = [bundle pathForResource:@"TCCT_Voice" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    UIImage *image = [UIImage sd_imageWithGIFData:imageData];
    [SpeakBtn setImage:image forState:UIControlStateNormal];
    [SpeakBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_talkback"] forState:UIControlStateSelected];
    SpeakBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:SpeakBtn];
    [SpeakBtn addTarget:self action:@selector(SpeakBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [SpeakBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.height.mas_equalTo(80);
//        make.bottom.equalTo(view).offset(TCBottomTabH+20);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
        } else {
            make.bottom.equalTo(view).offset(-50);
        }
    }];
    
    UIView *buttonvView = [[UIView alloc] init];
    [view addSubview:buttonvView];
    buttonvView.backgroundColor = [UIColor whiteColor];
    [buttonvView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SpeakBtn.mas_bottom);
        make.right.left.bottom.equalTo(view);
    }];
}

- (void)SpeakBtnClick
{
    self.SpeakBtn.selected = !self.SpeakBtn.selected;
    if (!self.SpeakBtn.selected) {
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0];
        self.Tiplabel.hidden = NO;
        self.textView.text = @"请说,我在聆听...";
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
    
    //隐藏提示框
    self.Tiplabel.hidden = YES;
    
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
    
    UIBezierPath *maskPath= [UIBezierPath bezierPathWithRoundedRect:self.view.bounds
                              
                                                    byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                              
                                                          cornerRadii:CGSizeMake(20,20)];
    
    CAShapeLayer*maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
    

}


- (void)dealWithResult:(NSString *)Result
{
    if ([Result containsString:@"开锁"]||([Result containsString:@"门"]&&[Result containsString:@"开"])||([Result containsString:@"开"]&&[Result containsString:@"锁"])) {
        NSLog(@"开锁");
        if (self.doorArray.count == 0) {
            
            [self.textView setText:@"抱歉,您还未绑定门口机!"];
            
        }else
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [self openDoor];
            }];
        }
        
    }else
    {
        [self.textView setText:@"未能识别,请点击麦克风重试"];
        self.Tiplabel.hidden = NO;
    }
}

- (void)openDoor
{
    if(self.doorArray.count == 1){
        
        NSDictionary *dict = self.doorArray.firstObject;
        [TCOpenDoorTool openTheDoorWithID:[dict xyValueForKey:@"id"] DoorName:[dict xyValueForKey:@"name"] TalkID:[dict xyValueForKey:@"intercomUserId"]];
    }else
    {
        NSString *reult = self.textView.text;
        NSDictionary * dict = [TCCloudTalkingTool getMatchMachineDataArrayWithResult:reult];
        debugLog(@"%@----计算后的字典",dict);
        [TCOpenDoorTool openTheDoorWithID:[dict xyValueForKey:@"id"] DoorName:[dict xyValueForKey:@"name"] TalkID:[dict xyValueForKey:@"intercomUserId"]];
        
    }
}




@end
