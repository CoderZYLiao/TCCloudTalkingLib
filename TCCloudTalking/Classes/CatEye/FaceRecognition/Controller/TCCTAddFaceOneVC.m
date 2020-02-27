//
//  TCCTAddFaceOneVC.m
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/18.
//

#import "TCCTAddFaceOneVC.h"
#import "TCCTCatEyeModel.h"
#import "TCCTAddFaceTwoVC.h"

@interface TCCTAddFaceOneVC ()

@property (nonatomic, strong) UIView *faceView;
@property (nonatomic, strong) UIImageView *faceBackImageView;

@property (nonatomic, strong) UIView *showView;
@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, strong) UIImageView *itemOneImageView;
@property (nonatomic, strong) UIImageView *itemTwoImageView;
@property (nonatomic, strong) UIImageView *itemThreeImageView;
@property (nonatomic, strong) UIImageView *itemFourImageView;
@property (nonatomic, strong) UILabel *itemOneLabel;
@property (nonatomic, strong) UILabel *itemTwoLabel;
@property (nonatomic, strong) UILabel *itemThreeLabel;
@property (nonatomic, strong) UILabel *itemFourLabel;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *photographBtn;
@property (nonatomic, strong) UIButton *resetPhotographBtn;
@property (nonatomic, strong) UIButton *nextStepBtn;

@property (nonatomic, strong) AVCaptureDevice *device;      //硬件设备
@property (nonatomic, strong) AVCaptureDeviceInput *input;  //输入流
@property (nonatomic, strong) AVCaptureSession *session;    //协调输入输出流的数据
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;     //预览层
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;  //用于捕捉静态图片
@property (nonatomic, strong) NSData *curFaceImageData;    //当前拍摄的人脸识别图像

@end

@implementation TCCTAddFaceOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
    self.view.backgroundColor = [UIColor colorWithHexString:Color_bgColor];
    if (_pushType == AddFacePushType_Add) {
        self.navigationItem.title = @"添加家庭成员照片";
    }else{
        self.navigationItem.title = @"编辑家庭成员照片";
    }
    
    [self initThePageLayout];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self.faceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(TccHeight(50));
        make.left.mas_equalTo(self.view).offset(TccWidth(50));
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(self.faceView.mas_width).multipliedBy(1);
        
        make.width.height.mas_equalTo(self.view).priorityLow();
        make.width.height.lessThanOrEqualTo(self.view);
    }];
    [self.faceBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.faceView);
    }];
    
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.faceView.mas_bottom).offset(TccHeight(30));
        make.left.mas_equalTo(self.view).offset(TccWidth(20));
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(TccHeight(150));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(TccHeight(100));
    }];
    [self.photographBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(TccWidth(20));
        make.centerX.mas_equalTo(self.bottomView);
        make.centerY.mas_equalTo(self.bottomView);
        make.height.mas_equalTo(TccHeight(40));
    }];
    
    NSArray *buttonArr = @[self.resetPhotographBtn,self.nextStepBtn];
    [buttonArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:20 tailSpacing:20];
    [buttonArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView);
        make.height.mas_equalTo(TccHeight(40));
    }];
    
    NSArray *imageArr = @[self.itemOneImageView,self.itemTwoImageView,self.itemThreeImageView,self.itemFourImageView];
    [imageArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:0 tailSpacing:0];
    [imageArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.showView);
        make.height.mas_equalTo(self.itemOneImageView.mas_width).multipliedBy(1);
        
        make.width.height.mas_equalTo(self.showView).priorityLow();
        make.width.height.lessThanOrEqualTo(self.showView);
    }];
    
    NSArray *labelArr = @[self.itemOneLabel,self.itemTwoLabel,self.itemThreeLabel,self.itemFourLabel];
    [labelArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:0 tailSpacing:0];
    [labelArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.itemOneImageView.mas_bottom).offset(TccHeight(10));
        make.height.mas_equalTo(TccHeight(20));
    }];
    
    [self.showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.itemOneImageView.mas_top).offset(-TccHeight(10));
        make.left.mas_equalTo(self.showView);
        make.height.mas_equalTo(TccHeight(20));
    }];
}

#pragma mark - Init Page Layout
- (void)initThePageLayout{
    [self.view addSubview:self.faceView];
    [self.faceView addSubview:self.faceBackImageView];
    
    [self.view addSubview:self.showView];
    [self.showView addSubview:self.showLabel];
    [self.showView addSubview:self.itemOneImageView];
    [self.showView addSubview:self.itemTwoImageView];
    [self.showView addSubview:self.itemThreeImageView];
    [self.showView addSubview:self.itemFourImageView];
    [self.showView addSubview:self.itemOneLabel];
    [self.showView addSubview:self.itemTwoLabel];
    [self.showView addSubview:self.itemThreeLabel];
    [self.showView addSubview:self.itemFourLabel];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.photographBtn];
    [self.bottomView addSubview:self.resetPhotographBtn];
    [self.bottomView addSubview:self.nextStepBtn];
    
    [self isHiddenPhotographBtn:NO];
    
    [self.faceView.layer addSublayer:self.previewLayer];
    [self.session startRunning];
    [self.faceView bringSubviewToFront:self.faceBackImageView];
}

#pragma mark - Event Response
//是否隐藏拍摄按钮，其余按钮反之
- (void)isHiddenPhotographBtn:(BOOL)isHidden{
    self.photographBtn.hidden = isHidden;
    self.resetPhotographBtn.hidden = !isHidden;
    self.nextStepBtn.hidden = !isHidden;
}

//拍照
- (void)photographBtnClick:(id)sender{
    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *oldImage = [UIImage imageWithData:imageData];
            UIImage *newImage = [oldImage imageWithImage:oldImage scaledToSize:CGSizeMake(480, 640)];
            self.curFaceImageData = UIImageJPEGRepresentation(newImage,0.25);
        }
    }];
    
    [self.session stopRunning];
    [self isHiddenPhotographBtn:YES];
}

//重照
- (void)resetPhotographBtnClick:(id)sender{
    [self.session startRunning];
    [self isHiddenPhotographBtn:NO];
}

//下一步
- (void)nextStepBtnClick:(id)sender{
    if (_pushType == AddFacePushType_Add) {
        if (self.curFaceImageData) {
            TCCTAddFaceTwoVC *addFaceTwoVC = [[TCCTAddFaceTwoVC alloc] init];
            addFaceTwoVC.faceImageData = self.curFaceImageData;
            addFaceTwoVC.curCatEyeModel = self.catEyeModel;
            addFaceTwoVC.pushType = AddFacePushType_Add;
            [self.navigationController pushViewController:addFaceTwoVC animated:YES];
        }else{
            [MBManager showBriefAlert:@"图片数据异常,请重新拍摄"];
        }
    }else{
        if (self.curFaceImageData) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(addFaceDelegateWithShootImage:)]) {
                [self.delegate addFaceDelegateWithShootImage:self.curFaceImageData];
            }
            [self clickLeftBarButtonItem];
        }else{
            [MBManager showBriefAlert:@"图片数据异常,请重新拍摄"];
        }
    }
}

#pragma mark - Get And Set
- (UIView *)faceView{
    if (!_faceView) {
        _faceView = [UIView new];
    }
    return _faceView;
}

- (UIImageView *)faceBackImageView{
    if (!_faceBackImageView) {
        _faceBackImageView = [UIImageView new];
        [_faceBackImageView setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_photo"]];
    }
    return _faceBackImageView;
}

- (UIView *)showView{
    if (!_showView) {
        _showView = [UIView new];
    }
    return _showView;
}

- (UILabel *)showLabel{
    if (!_showLabel) {
        _showLabel = [UILabel new];
        [_showLabel setText:@"拍摄须知"];
        [_showLabel setFont:Font_Title_System18];
        [_showLabel setTextColor:[UIColor blackColor]];
    }
    return _showLabel;
}

- (UILabel *)itemOneLabel{
    if (!_itemOneLabel) {
        _itemOneLabel = [UILabel new];
        [_itemOneLabel setText:@"不佩戴眼镜"];
        [_itemOneLabel setFont:Font_Text_System14];
        [_itemOneLabel setTextAlignment:NSTextAlignmentCenter];
        [_itemOneLabel setTextColor:[UIColor grayColor]];
    }
    return _itemOneLabel;
}

- (UILabel *)itemTwoLabel{
    if (!_itemTwoLabel) {
        _itemTwoLabel = [UILabel new];
        [_itemTwoLabel setText:@"不遮挡面部"];
        [_itemTwoLabel setFont:Font_Text_System14];
        [_itemTwoLabel setTextAlignment:NSTextAlignmentCenter];
        [_itemTwoLabel setTextColor:[UIColor grayColor]];
    }
    return _itemTwoLabel;
}

- (UILabel *)itemThreeLabel{
    if (!_itemThreeLabel) {
        _itemThreeLabel = [UILabel new];
        [_itemThreeLabel setText:@"不仰头拍摄"];
        [_itemThreeLabel setFont:Font_Text_System14];
        [_itemThreeLabel setTextAlignment:NSTextAlignmentCenter];
        [_itemThreeLabel setTextColor:[UIColor grayColor]];
    }
    return _itemThreeLabel;
}

- (UILabel *)itemFourLabel{
    if (!_itemFourLabel) {
        _itemFourLabel = [UILabel new];
        [_itemFourLabel setText:@"光线充足"];
        [_itemFourLabel setFont:Font_Text_System14];
        [_itemFourLabel setTextAlignment:NSTextAlignmentCenter];
        [_itemFourLabel setTextColor:[UIColor grayColor]];
    }
    return _itemFourLabel;
}

- (UIImageView *)itemOneImageView{
    if (!_itemOneImageView) {
        _itemOneImageView = [UIImageView new];
        [_itemOneImageView setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_showOne"]];
    }
    return _itemOneImageView;
}

- (UIImageView *)itemTwoImageView{
    if (!_itemTwoImageView) {
        _itemTwoImageView = [UIImageView new];
        [_itemTwoImageView setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_showTwo"]];
    }
    return _itemTwoImageView;
}

- (UIImageView *)itemThreeImageView{
    if (!_itemThreeImageView) {
        _itemThreeImageView = [UIImageView new];
        [_itemThreeImageView setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_showThree"]];
    }
    return _itemThreeImageView;
}

- (UIImageView *)itemFourImageView{
    if (!_itemFourImageView) {
        _itemFourImageView = [UIImageView new];
        [_itemFourImageView setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_showFour"]];
    }
    return _itemFourImageView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
    }
    return _bottomView;
}

- (UIButton *)photographBtn{
    if (!_photographBtn) {
        _photographBtn = [UIButton new];
        [_photographBtn setBackgroundColor:[UIColor colorWithHexString:Color_globalColor]];
        [_photographBtn setTitle:@"拍摄" forState:UIControlStateNormal];
        [_photographBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_photographBtn.layer setCornerRadius:Fillet_CornerRadius];
        [_photographBtn addTarget:self action:@selector(photographBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photographBtn;
}

- (UIButton *)resetPhotographBtn{
    if (!_resetPhotographBtn) {
        _resetPhotographBtn = [UIButton new];
        [_resetPhotographBtn setBackgroundColor:[UIColor whiteColor]];
        [_resetPhotographBtn setTitle:@"重拍" forState:UIControlStateNormal];
        [_resetPhotographBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_resetPhotographBtn.layer setCornerRadius:Fillet_CornerRadius];
        [_resetPhotographBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [_resetPhotographBtn.layer setBorderWidth:SplitLine_Height];
        [_resetPhotographBtn addTarget:self action:@selector(resetPhotographBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetPhotographBtn;
}

- (UIButton *)nextStepBtn{
    if (!_nextStepBtn) {
        _nextStepBtn = [UIButton new];
        [_nextStepBtn setBackgroundColor:[UIColor colorWithHexString:Color_globalColor]];
        [_nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextStepBtn.layer setCornerRadius:Fillet_CornerRadius];
        [_nextStepBtn addTarget:self action:@selector(nextStepBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStepBtn;
}

#pragma mark - 摄像头
- (AVCaptureDevice *)device{
    if (_device == nil) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([_device lockForConfiguration:nil]) {
            //自动闪光灯
            if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
                [_device setFlashMode:AVCaptureFlashModeAuto];
            }
            //自动白平衡
            if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
                [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
            }
            //自动对焦
            if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                [_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            }
            //自动曝光
            if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                [_device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            [_device unlockForConfiguration];
        }
    }
    return _device;
}

-(AVCaptureDeviceInput *)input{
    if (_input == nil) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:[self cameraWithPosition:AVCaptureDevicePositionFront] error:nil];
    }
    return _input;
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}

-(AVCaptureStillImageOutput *)stillImageOutput{
    if (_stillImageOutput == nil) {
        NSDictionary *outputSettings = @{(id)kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8PlanarFullRange],
                                         AVVideoCodecKey : AVVideoCodecJPEG};
        
        [_stillImageOutput setOutputSettings:outputSettings];
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    }
    return _stillImageOutput;
}

-(AVCaptureSession *)session{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        if ([_session canAddOutput:self.stillImageOutput]) {
            [_session addOutput:self.stillImageOutput];
        }
    }
    return _session;
}

-(AVCaptureVideoPreviewLayer *)previewLayer{
    if (_previewLayer == nil) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewLayer.frame = CGRectMake(0, 0, kScreenWidth - TccWidth(100) - 1, kScreenWidth - TccWidth(100) - 1);
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewLayer;
}


@end
