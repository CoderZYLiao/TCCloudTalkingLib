//
//  TCVoiceView.m
//  TCCloudTalking_Example
//
//  Created by Huang ZhiBin on 2019/11/26.
//  Copyright © 2019年 TYL. All rights reserved.
//

#import "TCVoiceView.h"
#import "Header.h"
#import "POP.h"

#import "IFlyMSC/IFlyMSC.h"
#import "ISRDataHelper.h"
static CGFloat const TCAnimationDelay = 0.1;
static CGFloat const TCSpringFactor = 10;



@interface TCVoiceView()<IFlySpeechRecognizerDelegate>
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;


@property (strong, nonatomic) UIButton *voiceRecogButton;
@property (nonatomic, strong) NSFileHandle *fileHandler;

@property (weak, nonatomic) UITextView *textView;
@property (nonatomic, strong) NSString * result;
@property (nonatomic, weak)  UIView *speechView;
//动画
@property (nonatomic , strong) CAReplicatorLayer *musicLayer;
@end
@implementation TCVoiceView


static UIWindow *window_;

+ (void)show
{
    // 创建窗口
    window_ = [[UIWindow alloc] init];
    window_.frame = [UIScreen mainScreen].bounds;
    window_.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:1];
    window_.hidden = NO;


    // 添加发布界面
    TCVoiceView *publishView = [[TCVoiceView alloc] init];
    publishView.frame = window_.bounds;
    [window_ addSubview:publishView];
    [publishView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(window_.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(window_.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(window_.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(window_.mas_safeAreaLayoutGuideBottom);
        } else {
            make.leading.trailing.top.bottom.equalTo(window_);
        }
    }];

    UIButton *canceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [publishView addSubview:canceButton];
    [canceButton addTarget:publishView action:@selector(canceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [canceButton setImage:[UIImage imageNamed:@"quxiao-2"] forState:UIControlStateNormal];
    [canceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(publishView).offset(30);
        make.right.equalTo(publishView).offset(-30);
        make.width.height.equalTo(@32);

    }];

    UIView *SpeechView = [[UIView alloc] init];
    publishView.speechView = SpeechView;
    [publishView addSubview:SpeechView];
    [SpeechView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(publishView).offset(TCBottomTabH);
        make.left.equalTo(publishView);
        make.right.equalTo(publishView);
        make.height.mas_equalTo(@300);
    }];
    UIImageView *backImage = [[UIImageView alloc] init];
    [SpeechView addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(SpeechView);
        make.right.left.equalTo(SpeechView);
    }];
    
    UITextView *textView = [[UITextView alloc] init];
    publishView.textView = textView;
    [SpeechView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(SpeechView).offset(-30);
        make.left.equalTo(SpeechView);
        make.right.equalTo(SpeechView);
        make.height.mas_equalTo(@200);
    }];
    
    
    
    
    UIButton *voiceRecogButton = [UIButton buttonWithType:UIButtonTypeCustom];
    publishView.voiceRecogButton = voiceRecogButton;
    [voiceRecogButton addTarget:publishView action:@selector(voiceRecogBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [voiceRecogButton setTitle:@"开始" forState:UIControlStateNormal];
    [voiceRecogButton setTitle:@"停止" forState:UIControlStateSelected];
    [SpeechView addSubview:voiceRecogButton];
    [voiceRecogButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(publishView);
        make.bottom.equalTo(publishView).offset(-10);

    }];




}


- (void)voiceRecogBtnClick
{
    [self musicReplicatorLayer];
    [_textView setText:@""];
    [_textView resignFirstResponder];
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    
    [_iFlySpeechRecognizer cancel];
    
    //Set microphone as audio source
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //Set result type
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //Set the audio name of saved recording file while is generated in the local storage path of SDK,by default in library/cache.
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iFlySpeechRecognizer setDelegate:self];
    
    BOOL ret = [_iFlySpeechRecognizer startListening];
    
    if (ret) {
        
        
    }else{
        
        NSLog(@"启动识别服务失败，请稍后重试!");
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"initWithFrame");
        [self initRecognizer];

        
    }
    return self;
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
    
    _result =[NSString stringWithFormat:@"%@%@", _textView.text,resultString];
    
    NSString * resultFromJson = [ISRDataHelper stringFromJson:resultString];
    _textView.text = [NSString stringWithFormat:@"%@%@", _textView.text,resultFromJson];
    
    if (isLast){
        NSLog(@"ISR Results(json)：%@",  self.result);
    }
    NSLog(@"_result=%@",_result);
    NSLog(@"resultFromJson=%@",resultFromJson);
    NSLog(@"isLast=%d,_textView.text=%@",isLast,_textView.text);
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
    [self cancelWithCompletionBlock:nil];
}

/**
 * 先执行退出动画, 动画完毕后执行completionBlock
 */
- (void)cancelWithCompletionBlock:(void (^)(void))completionBlock
{

    // 不能被点击
    self.userInteractionEnabled = NO;

    int beginIndex = 0;
    NSUInteger count = self.subviews.count;
    for (int i = beginIndex; i<self.subviews.count; i++) {
        UIView *subview = self.subviews[i];

        // 基本动画
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = subview.centerY + kMainScreenHeight;
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * TCAnimationDelay;
        [subview pop_addAnimation:anim forKey:nil];

        // 监听最后一个动画  add tyl 2017.4.20
        if (beginIndex == (count - 1 + beginIndex - i)) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                //                JYJKeyWindow.rootViewController.view.userInteractionEnabled = YES;
                // iOS9中一定要hidden
                window_.hidden = YES;
                // 销毁窗口
                window_ = nil;

                // 执行传进来的completionBlock参数
                !completionBlock ? : completionBlock();
            }];
        }

    }

}



- (NSDictionary *)parseLogToDic:(NSString *)logString
{
    NSArray *tmp = NULL;
    NSMutableDictionary *logDic = [[NSMutableDictionary alloc] initWithCapacity:3];
    NSArray *items = [logString componentsSeparatedByString:@"&"];
    for (NSString *item in items) {
        tmp = [item componentsSeparatedByString:@"="];
        if (tmp.count == 2) {
            [logDic setObject:tmp.lastObject forKey:tmp.firstObject];
        }
    }
    return logDic;
}

- (NSString *)getDescriptionForDic:(NSDictionary *)dic {
    if (dic) {
        return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic
                                                                              options:NSJSONWritingPrettyPrinted
                                                                                error:nil] encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (void)musicReplicatorLayer
{
    _musicLayer = [CAReplicatorLayer layer];
    _musicLayer.frame = CGRectMake(0, 0, 200, 50);
    _musicLayer.position = self.center;
    //设置复制层里面包含的子层个数
    _musicLayer.instanceCount = 20;
    //设置下个子层相对于前一个的偏移量
    _musicLayer.instanceTransform = CATransform3DMakeTranslation(10, 0, 0);     //每个layer的间距。
    //设置下一个层相对于前一个的延迟时间
    _musicLayer.instanceDelay = 0.2;
    _musicLayer.backgroundColor = [UIColor redColor].CGColor;
    _musicLayer.masksToBounds = YES;
    [self.speechView.layer addSublayer:_musicLayer];
    
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
