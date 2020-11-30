//
//  TCQRCodeUnlockViewController.m
//  TCCloudTalking-TCCloudTalking
//
//  Created by Huang ZhiBin on 2019/11/12.
//

#import "TCQRCodeUnlockViewController.h"
#import "Header.h"
#import "AES128Util.h"
#define TipViewShow @"TipViewShow"
@interface TCQRCodeUnlockViewController ()
{
    double currentLight;
}
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) UIImageView *QRcodeImageView;
@property (nonatomic,strong) UILabel *WarmLabel;
@property (nonatomic,strong) UIView *bgView;
@end

@implementation TCQRCodeUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码开锁";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    
    //生成二维码
    [self generateCode];
    // 判断是否已显示过
    if (![[NSUserDefaults standardUserDefaults] boolForKey:TipViewShow]) {
        // 显示
        [self showToolTipView];
    };
    
    currentLight = [[UIScreen mainScreen] brightness];
    if(currentLight > 0.4)
    {
        [[UIScreen mainScreen] setBrightness: 0.3];
    }
}

//调整整个手机界面的亮度的  并不仅仅是某个app的亮度 ，要做退出页面的时候将亮度设为原来的值
- (void)viewWillDisappear:(BOOL)animated {
    [[UIScreen mainScreen] setBrightness: currentLight];
}

- (void)showToolTipView
{
    // 遮盖视图
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    self.bgView = bgView;
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    UIButton *canceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:canceButton];
    [canceButton addTarget:self action:@selector(canceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [canceButton setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_quxiao"] forState:UIControlStateNormal];
    [canceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(30);
        make.right.equalTo(bgView).offset(-30);
        make.width.height.equalTo(@40);
        
    }];
    
    UILabel *Detiallabel = [[UILabel alloc] init];
    Detiallabel.textAlignment = NSTextAlignmentCenter;
    Detiallabel.numberOfLines = 0;
    Detiallabel.text = @"请用手机二维码对准门口机\n摄像头扫码开锁";
    Detiallabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    Detiallabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [bgView addSubview:Detiallabel];
    [Detiallabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.centerY.equalTo(bgView).offset(-70);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"扫码开锁";
    label.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:20];
    label.textColor = [UIColor whiteColor];
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(Detiallabel.mas_top).offset(-10);
        make.centerX.equalTo(bgView);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_二维码开锁"];
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Detiallabel.mas_bottom).offset(40);
        make.centerX.equalTo(bgView);
    }];
    
}

- (void)canceBtnClick
{
    
    [self.bgView removeFromSuperview];
    [[self.bgView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.bgView = nil;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TipViewShow];
}

- (void)tap:(UITapGestureRecognizer *)recognizer
{
    UIView *bgView = recognizer.view;
    [bgView removeFromSuperview];
    [bgView removeGestureRecognizer:recognizer];
    [[bgView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    bgView = nil;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TipViewShow];
    
    
}


- (void)initUI
{
    UIView *View = [[UIView alloc] init];
    View.backgroundColor = [UIColor clearColor];
    [self.view addSubview:View];
    [View mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.leading.trailing.top.bottom.equalTo(self.view);
        }
    }];
    
    //    UIView *TipView = [[UIView alloc] init];
    //    TipView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7/1.0];
    //    [View addSubview:TipView];
    //    [TipView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(View);
    //        make.right.left.equalTo(View);
    //        make.height.equalTo(View).multipliedBy(0.52);
    //    }];
    //
    //    UILabel *label = [[UILabel alloc] init];
    //    label.text = @"扫码开锁";
    //    label.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:20];
    //    label.textColor = [UIColor whiteColor];
    //    [TipView addSubview:label];
    //    [label mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(TipView).offset(40);
    //        make.centerX.equalTo(TipView);
    //    }];
    //
    //    UILabel *Detiallabel = [[UILabel alloc] init];
    //    Detiallabel.textAlignment = NSTextAlignmentCenter;
    //    Detiallabel.numberOfLines = 0;
    //    Detiallabel.text = @"请用手机二维码对准门口机摄像头扫码开锁";
    //    Detiallabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    //    Detiallabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    //    [TipView addSubview:Detiallabel];
    //    [Detiallabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(label.mas_bottom).offset(5);
    //        make.centerX.equalTo(TipView);
    //    }];
    //
    //    UIImageView *imageView = [[UIImageView alloc] init];
    //    imageView.image = [TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_二维码开锁"];
    //    [TipView addSubview:imageView];
    //    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(Detiallabel.mas_bottom).offset(40);
    //        make.centerX.equalTo(TipView);
    //    }];
    //
    //    UIImageView *downImage = [[UIImageView alloc] init];
    //    downImage.image = [TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_指引箭头"];
    //    [TipView addSubview:downImage];
    //    [downImage mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(imageView.mas_bottom).offset(20);
    //        make.width.mas_equalTo(24);
    //        make.height.mas_equalTo(24);
    //        make.centerX.equalTo(TipView);
    //        make.bottom.equalTo(TipView).offset(-38);
    //    }];
    
    UIView *QRCodeView = [[UIView alloc] init];
    QRCodeView.backgroundColor = [UIColor whiteColor];
    [View addSubview:QRCodeView];
    [QRCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View);
        make.right.left.equalTo(View);
        make.bottom.equalTo(View);
    }];
    
    UIImageView *QRcodeImageView = [[UIImageView alloc] init];
    self.QRcodeImageView = QRcodeImageView;
    self.QRcodeImageView.userInteractionEnabled = YES;//打开用户交互
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(QRCodeRefresh)];
    [self.QRcodeImageView addGestureRecognizer:tapGestureRecognizer];
    [QRCodeView addSubview:QRcodeImageView];
    [QRcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(QRCodeView.mas_top).offset(40);
        make.centerX.equalTo(View);
        make.width.height.mas_equalTo(300);
        
    }];
    
    UILabel *Warmlabel = [[UILabel alloc] init];
    self.WarmLabel = Warmlabel;
    Warmlabel.textAlignment = NSTextAlignmentCenter;
    Warmlabel.numberOfLines = 0;
    Warmlabel.text = [NSString stringWithFormat:@"点击二维码可刷新\n该二维码将于%@后失效",[self fiveMinutesTimeStr]];
    Warmlabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    Warmlabel.textColor = [UIColor colorWithRed:144/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    [QRCodeView addSubview:Warmlabel];
    [Warmlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(QRcodeImageView.mas_bottom).offset(20);
        make.centerX.equalTo(QRcodeImageView);
        
    }];
    
}


- (void)generateCode
{
    TCHousesInfoModel *houesModel = [[TCPersonalInfoModel shareInstance] getHousesInfoModel];
    NSString *plainText = [NSString stringWithFormat:@"%@D%@",houesModel.housesInfoId,[self currentTimeStr]];
    
    self.key = @"Tc-AESKey4QrCode";
    //加密
    NSString *encryStr = [AES128Util AES128Encrypt:plainText key:self.key];
    debugLog(@"明文==%@-----密匙==%@-----加密结果==%@",plainText,self.key,encryStr);
    if (encryStr) {
        // 2、将CIImage转换成UIImage，并放大显示
        self.QRcodeImageView.image = [self generateWithDefaultQRCodeData:encryStr imageViewWidth:200];
        self.WarmLabel.text = [NSString stringWithFormat:@"点击二维码可刷新\n该二维码将于%@后失效",[self fiveMinutesTimeStr]];
    }else
    {
        
    }
    
}

- (void)getQRCodePwds
{
    [MBManager showLoading];
    [TCCloudTalkRequestTool GetDoorOpenQRCodesSuccess:^(id  _Nonnull result) {
        NSLog(@"%@-----二维码开锁",result);
        if ([result[@"code"] intValue] == 0) {
            
        }else
        {
            if (result[@"message"]) {
                [MBManager showBriefAlert:result[@"message"]];

            }
            
        }
    } faile:^(NSError * _Nonnull error) {
        [MBManager showBriefAlert:@"请求失败"];
    }];
}

//点击刷新二维码
- (void)QRCodeRefresh
{
    //生成二维码
    [self generateCode];
}

/**
 *  生成一张普通的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param imageViewWidth    图片的宽度
 */
- (UIImage *)generateWithDefaultQRCodeData:(NSString *)data imageViewWidth:(CGFloat)imageViewWidth {
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *info = data;
    // 将字符串转换成
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    
    // 通过KVC设置滤镜inputMessage数据
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:imageViewWidth];
}

/** 根据CIImage生成指定大小的UIImage */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

//获取5分钟后的时间
- (NSString *)fiveMinutesTimeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate dateWithTimeIntervalSinceNow:300];
    
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

- (NSString *)jsonStringWithDict:(NSDictionary *)dict
{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:(NSJSONWritingPrettyPrinted) error:&error];
    if (error) {
        NSLog(@"%s -> JSONSerialization Error: %@", __FUNCTION__, error);
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//获取当前时间戳
- (NSString *)getTimestampWithTimeIntervalSinceNow:(NSInteger)second
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:second];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

@end
