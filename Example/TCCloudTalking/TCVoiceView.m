////
////  TCVoiceView.m
////  TCCloudTalking_Example
////
////  Created by Huang ZhiBin on 2019/11/26.
////  Copyright © 2019年 TYL. All rights reserved.
////
//
//#import "TCVoiceView.h"
//#import "Header.h"
//#import "POP.h"
////百度语音SDK
//#import "BDSEventManager.h"
//#import "BDSASRDefines.h"
//#import "BDSASRParameters.h"
//static CGFloat const TCAnimationDelay = 0.1;
//static CGFloat const TCSpringFactor = 10;
//
//
//const NSString* APP_ID = @"17801386";
//const NSString* API_KEY = @"XnuoD3UtO5dEmOWW5HVVG8a4";
//const NSString* SECRET_KEY = @"3Mg2DD6CZR8m2N4zc4WNT2E9lThao1cN";
//@interface TCVoiceView()<BDSClientASRDelegate>
//
//@property (strong, nonatomic) BDSEventManager *asrEventManager;
//@property (strong, nonatomic) BDSEventManager *wakeupEventManager;
//
//@property (strong, nonatomic) UIButton *voiceRecogButton;
//@property (nonatomic, strong) NSFileHandle *fileHandler;
//
//
////是否为长语音
//@property(nonatomic, assign) BOOL longSpeechFlag;
//@end
//@implementation TCVoiceView
//
//
//
//
//
//
//static UIWindow *window_;
//
//+ (void)show
//{
//    // 创建窗口
//    window_ = [[UIWindow alloc] init];
//    window_.frame = [UIScreen mainScreen].bounds;
//    window_.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:1];
//    window_.hidden = NO;
//    
//    
//    // 添加发布界面
//    TCVoiceView *publishView = [[TCVoiceView alloc] init];
//    publishView.frame = window_.bounds;
//    [window_ addSubview:publishView];
//    [publishView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.left.equalTo(window_.mas_safeAreaLayoutGuideLeft);
//            make.right.equalTo(window_.mas_safeAreaLayoutGuideRight);
//            make.top.equalTo(window_.mas_safeAreaLayoutGuideTop);
//            make.bottom.equalTo(window_.mas_safeAreaLayoutGuideBottom);
//        } else {
//            make.leading.trailing.top.bottom.equalTo(window_);
//        }
//    }];
//    
//    UIButton *canceButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [publishView addSubview:canceButton];
//    [canceButton addTarget:publishView action:@selector(canceBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [canceButton setImage:[UIImage imageNamed:@"quxiao-2"] forState:UIControlStateNormal];
//    [canceButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(publishView).offset(30);
//        make.right.equalTo(publishView).offset(-30);
//        make.width.height.equalTo(@32);
//  
//    }];
//    
//    UIButton *voiceRecogButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    publishView.voiceRecogButton = voiceRecogButton;
//    [voiceRecogButton addTarget:publishView action:@selector(voiceRecogBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [voiceRecogButton setTitle:@"开始" forState:UIControlStateNormal];
//    [voiceRecogButton setTitle:@"停止" forState:UIControlStateSelected];
//    [publishView addSubview:voiceRecogButton];
//    [voiceRecogButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(publishView);
//        make.bottom.equalTo(publishView).offset(-50);
//        
//    }];
//    
//    
//    
//    
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        NSLog(@"initWithFrame");
//        self.asrEventManager = [BDSEventManager createEventManagerWithName:BDS_ASR_NAME];
//        self.wakeupEventManager = [BDSEventManager createEventManagerWithName:BDS_WAKEUP_NAME];
//        self.longSpeechFlag = NO;
//        NSLog(@"Current SDK version: %@", [self.asrEventManager libver]);
//        [self configVoiceRecognitionClient];
//        
//    }
//    return self;
//}
//
//#pragma mark - Private: Configuration
//
//- (void)configVoiceRecognitionClient {
//    //设置DEBUG_LOG的级别
//    [self.asrEventManager setParameter:@(EVRDebugLogLevelTrace) forKey:BDS_ASR_DEBUG_LOG_LEVEL];
//    //配置API_KEY 和 SECRET_KEY 和 APP_ID
//    [self.asrEventManager setParameter:@[API_KEY, SECRET_KEY] forKey:BDS_ASR_API_SECRET_KEYS];
//    [self.asrEventManager setParameter:APP_ID forKey:BDS_ASR_OFFLINE_APP_CODE];
//    //配置端点检测（二选一）
//    [self configModelVAD];
//    //    [self configDNNMFE];
//    
//    //    [self.asrEventManager setParameter:@"15361" forKey:BDS_ASR_PRODUCT_ID];
//    // ---- 语义与标点 -----
//    [self enableNLU];
//    //    [self enablePunctuation];
//    // ------------------------
//    
//    //---- 语音自训练平台 ----
//    //    [self configSmartAsr];
//}
//
//- (void) enableNLU {
//    // ---- 开启语义理解 -----
//    [self.asrEventManager setParameter:@(YES) forKey:BDS_ASR_ENABLE_NLU];
//    [self.asrEventManager setParameter:@"15363" forKey:BDS_ASR_PRODUCT_ID];
//}
//
//- (void) enablePunctuation {
//    // ---- 开启标点输出 -----
//    [self.asrEventManager setParameter:@(NO) forKey:BDS_ASR_DISABLE_PUNCTUATION];
//    // 普通话标点
//    //    [self.asrEventManager setParameter:@"1537" forKey:BDS_ASR_PRODUCT_ID];
//    // 英文标点
////    [self.asrEventManager setParameter:@"1737" forKey:BDS_ASR_PRODUCT_ID];
//    
//}
//
//
//- (void)configModelVAD {
//    NSString *modelVAD_filepath = [[NSBundle mainBundle] pathForResource:@"bds_easr_basic_model" ofType:@"dat"];
//    [self.asrEventManager setParameter:modelVAD_filepath forKey:BDS_ASR_MODEL_VAD_DAT_FILE];
//    [self.asrEventManager setParameter:@(YES) forKey:BDS_ASR_ENABLE_MODEL_VAD];
//}
//
//- (void)configDNNMFE {
//    NSString *mfe_dnn_filepath = [[NSBundle mainBundle] pathForResource:@"bds_easr_mfe_dnn" ofType:@"dat"];
//    [self.asrEventManager setParameter:mfe_dnn_filepath forKey:BDS_ASR_MFE_DNN_DAT_FILE];
//    NSString *cmvn_dnn_filepath = [[NSBundle mainBundle] pathForResource:@"bds_easr_mfe_cmvn" ofType:@"dat"];
//    [self.asrEventManager setParameter:cmvn_dnn_filepath forKey:BDS_ASR_MFE_CMVN_DAT_FILE];
//    // 自定义静音时长
//    //    [self.asrEventManager setParameter:@(501) forKey:BDS_ASR_MFE_MAX_SPEECH_PAUSE];
//    //    [self.asrEventManager setParameter:@(500) forKey:BDS_ASR_MFE_MAX_WAIT_DURATION];
//}
//
//
//#pragma mark --点击取消按钮
//- (void)canceBtnClick
//{
//    [self cancelWithCompletionBlock:nil];
//}
//
///**
// * 先执行退出动画, 动画完毕后执行completionBlock
// */
//- (void)cancelWithCompletionBlock:(void (^)(void))completionBlock
//{
//    
//    // 不能被点击
//    self.userInteractionEnabled = NO;
//    
//    int beginIndex = 0;
//    NSUInteger count = self.subviews.count;
//    for (int i = beginIndex; i<self.subviews.count; i++) {
//        UIView *subview = self.subviews[i];
//        
//        // 基本动画
//        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
//        CGFloat centerY = subview.centerY + kMainScreenHeight;
//        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, centerY)];
//        anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * TCAnimationDelay;
//        [subview pop_addAnimation:anim forKey:nil];
//        
//        // 监听最后一个动画  add tyl 2017.4.20
//        if (beginIndex == (count - 1 + beginIndex - i)) {
//            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
//                //                JYJKeyWindow.rootViewController.view.userInteractionEnabled = YES;
//                // iOS9中一定要hidden
//                window_.hidden = YES;
//                // 销毁窗口
//                window_ = nil;
//                
//                // 执行传进来的completionBlock参数
//                !completionBlock ? : completionBlock();
//            }];
//        }
//        
//    }
//    
//}
//
//- (void)VoiceRecognitionClientWorkStatus:(int)workStatus obj:(id)aObj {
//    switch (workStatus) {
//        case EVoiceRecognitionClientWorkStatusNewRecordData: {
//            [self.fileHandler writeData:(NSData *)aObj];
//            break;
//        }
//            
//        case EVoiceRecognitionClientWorkStatusStartWorkIng: {
//            NSDictionary *logDic = [self parseLogToDic:aObj];
//            [self printLogTextView:[NSString stringWithFormat:@"CALLBACK: start vr, log: %@\n", logDic]];
//            [self onStartWorking];
//            break;
//        }
//        case EVoiceRecognitionClientWorkStatusStart: {
//            [self printLogTextView:@"CALLBACK: detect voice start point.\n"];
//            break;
//        }
//        case EVoiceRecognitionClientWorkStatusEnd: {
//            [self printLogTextView:@"CALLBACK: detect voice end point.\n"];
//            break;
//        }
//        case EVoiceRecognitionClientWorkStatusFlushData: {
//            [self printLogTextView:[NSString stringWithFormat:@"CALLBACK: partial result - %@.\n\n", [self getDescriptionForDic:aObj]]];
//            break;
//        }
//        case EVoiceRecognitionClientWorkStatusFinish: {
//            [self printLogTextView:[NSString stringWithFormat:@"CALLBACK: final result - %@.\n\n", [self getDescriptionForDic:aObj]]];
//            if (aObj) {
////                self.resultTextView.text = [self getDescriptionForDic:aObj];
//            }
//            if (!self.longSpeechFlag) {
//                [self onEnd];
//            }
//            break;
//        }
//        case EVoiceRecognitionClientWorkStatusMeterLevel: {
//            break;
//        }
//        case EVoiceRecognitionClientWorkStatusCancel: {
//            [self printLogTextView:@"CALLBACK: user press cancel.\n"];
//            [self onEnd];
//            break;
//        }
//        case EVoiceRecognitionClientWorkStatusError: {
//            [self printLogTextView:[NSString stringWithFormat:@"CALLBACK: encount error - %@.\n", (NSError *)aObj]];
//            [self onEnd];
//            break;
//        }
//        case EVoiceRecognitionClientWorkStatusLoaded: {
//            [self printLogTextView:@"CALLBACK: offline engine loaded.\n"];
//            break;
//        }
//        case EVoiceRecognitionClientWorkStatusUnLoaded: {
//            [self printLogTextView:@"CALLBACK: offline engine unLoaded.\n"];
//            break;
//        }
//        case EVoiceRecognitionClientWorkStatusChunkThirdData: {
//            [self printLogTextView:[NSString stringWithFormat:@"CALLBACK: Chunk 3-party data length: %lu\n", (unsigned long)[(NSData *)aObj length]]];
//            break;
//        }
//        case EVoiceRecognitionClientWorkStatusChunkNlu: {
//            NSString *nlu = [[NSString alloc] initWithData:(NSData *)aObj encoding:NSUTF8StringEncoding];
//            [self printLogTextView:[NSString stringWithFormat:@"CALLBACK: Chunk NLU data: %@\n", nlu]];
//            NSLog(@"%@", nlu);
//            break;
//        }
//        case EVoiceRecognitionClientWorkStatusChunkEnd: {
//            [self printLogTextView:[NSString stringWithFormat:@"CALLBACK: Chunk end, sn: %@.\n", aObj]];
//            if (!self.longSpeechFlag) {
//                [self onEnd];
//            }
//            break;
//        }
//        case EVoiceRecognitionClientWorkStatusFeedback: {
//            NSDictionary *logDic = [self parseLogToDic:aObj];
//            [self printLogTextView:[NSString stringWithFormat:@"CALLBACK Feedback: %@\n", logDic]];
//            break;
//        }
//        case EVoiceRecognitionClientWorkStatusRecorderEnd: {
//            [self printLogTextView:@"CALLBACK: recorder closed.\n"];
//            break;
//        }
//        case EVoiceRecognitionClientWorkStatusLongSpeechEnd: {
//            [self printLogTextView:@"CALLBACK: Long Speech end.\n"];
//            [self onEnd];
//            break;
//        }
//        default:
//            break;
//    }
//}
//
//- (void)voiceRecogBtnClick
//{
//    [self voiceRecogButtonHelper];
//}
//
//- (void)voiceRecogButtonHelper
//{
//    //    [self configFileHandler];
//    [self.asrEventManager setDelegate:self];
//    [self.asrEventManager setParameter:nil forKey:BDS_ASR_AUDIO_FILE_PATH];
//    [self.asrEventManager setParameter:nil forKey:BDS_ASR_AUDIO_INPUT_STREAM];
//    [self.asrEventManager sendCommand:BDS_ASR_CMD_START];
//    [self onInitializing];
//}
//
//- (void)onInitializing
//{
//
//    [self.voiceRecogButton setTitle:@"Initializing..." forState:UIControlStateNormal];
//}
//
//- (void)onStartWorking
//{
//
//
//    [self.voiceRecogButton setTitle:@"Speaking..." forState:UIControlStateNormal];
//}
//
//- (void)onEnd
//{
//
//    [self.voiceRecogButton setTitle:@"语音识别" forState:UIControlStateNormal];
//}
//
//- (void)printLogTextView:(NSString *)logString
//{
////    self.logTextView.text = [logString stringByAppendingString:_logTextView.text];
////    [self.logTextView scrollRangeToVisible:NSMakeRange(0, 0)];
//}
//
//- (NSDictionary *)parseLogToDic:(NSString *)logString
//{
//    NSArray *tmp = NULL;
//    NSMutableDictionary *logDic = [[NSMutableDictionary alloc] initWithCapacity:3];
//    NSArray *items = [logString componentsSeparatedByString:@"&"];
//    for (NSString *item in items) {
//        tmp = [item componentsSeparatedByString:@"="];
//        if (tmp.count == 2) {
//            [logDic setObject:tmp.lastObject forKey:tmp.firstObject];
//        }
//    }
//    return logDic;
//}
//
//- (NSString *)getDescriptionForDic:(NSDictionary *)dic {
//    if (dic) {
//        return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic
//                                                                              options:NSJSONWritingPrettyPrinted
//                                                                                error:nil] encoding:NSUTF8StringEncoding];
//    }
//    return nil;
//}
//@end
