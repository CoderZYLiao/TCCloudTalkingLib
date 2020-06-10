//
//  TCBluetoothUnlockController.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2020/5/12.
//

#import "TCBluetoothUnlockController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "TCWaveButton.h"
#import "Header.h"

#define kPeripheralName         @"Liuting's Device" //外围设备名称，自定义
#define kServiceUUID            @"FFF0" //服务的UUID，自定义
#define kCharacteristicUUID     @"FFF1" //特征的UUID，自定义

UIWindow *_window;
// 窗口的高度
#define XWWindowHeight 44
// 动画的执行时间
#define XWDuration 1
// 窗口的停留时间
#define XWDelay 10
// 字体大小
#define XWFont [UIFont fontWithName:@"STHeitiSC-Light" size:18];

@interface TCBluetoothUnlockController ()<CBPeripheralManagerDelegate>
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;/* 外围设备管理器 */
@property (strong, nonatomic) NSMutableArray *centralM;/* 订阅的中央设备 */
@property (strong, nonatomic) CBMutableCharacteristic *characteristicM;/* 特征 */

@end

@implementation TCBluetoothUnlockController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置顶部导航栏透明，TODO 可移植于基类
    [self setNavigationBarTransparent];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self returnNavigationBarTransparent];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"蓝牙开锁";
    
    [self setUpButtonUI];
    [self initBackImgeUI];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建外围设备管理器
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil];
}

- (void)initBackImgeUI
{
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = NO;
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_bg"]];
    imgView.frame = self.view.bounds;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:imgView atIndex:0];
    
}

- (void)setUpButtonUI
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
    UIImageView *imageVc = [[UIImageView alloc] init];
    imageVc.image = [TCCloudTalkingImageTool getToolsBundleImage:@"TCC_Ble_门口机"];
    
    [View addSubview:imageVc];
    [imageVc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View.mas_top).offset(150);
        make.centerX.equalTo(View);
        make.height.mas_equalTo(166);
        make.width.mas_equalTo(96);
    }];
    
    
    UIButton *BLEbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [BLEbtn setTitle:@"立即开锁" forState:UIControlStateNormal];
    BLEbtn.titleLabel.font = XWFont;
    [BLEbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    BLEbtn.imageView.contentMode= UIViewContentModeCenter;
    [BLEbtn addTarget:self action:@selector(SendOpenDoorMessage:) forControlEvents:UIControlEventTouchUpInside];
    //    BLEbtn.radiusofWaveStart = 40;
    //    BLEbtn.radiusofWaveEnd = 140;
    //    BLEbtn.colorofwave = NavBarColor;
    //    BLEbtn.timeofwave = 1.0;
    //    BLEbtn.onlycenter = YES;
    [BLEbtn setBackgroundImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TCC_Btn"] forState:UIControlStateNormal];
    [View addSubview:BLEbtn];
    [BLEbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageVc.mas_bottom).offset(44);
        make.centerX.equalTo(View);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(130);
    }];
}


- (void)SendOpenDoorMessage:(UIButton *)btn
{
    static NSTimeInterval time = 0.0;
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    //限制用户点击按钮的时间间隔大于3秒钟
    if (currentTime - time < 3) {

        return;
    }
    time = currentTime;
    
    TCHousesInfoModel *houesModel = [[TCPersonalInfoModel shareInstance] getHousesInfoModel];
    if (!houesModel.account) {
        [MBManager showBriefAlert:@"开锁状态不正确!"];
        return;
    }
    NSData *data = [houesModel.account dataUsingEncoding:NSUTF8StringEncoding];
    NSString *degestString = [data base64EncodedStringWithOptions:0];
    //设置设备信息dict，CBAdvertisementDataLocalNameKey是设置设备名
    NSDictionary *dict = @{CBAdvertisementDataLocalNameKey:degestString};
    //开始广播
    [self.peripheralManager startAdvertising:dict];
    
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(StopTimer) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)StopTimer
{
    NSLog(@"---停止广播---");
    //停止广播
    [self.peripheralManager stopAdvertising];
}
#pragma mark - CBCentralManagerDelegate
// 只要中心管理者初始化,就会触发此代理方法
- (void)peripheralManagerDidUpdateState:(nonnull CBPeripheralManager *)peripheral
{
    
    switch (peripheral.state) {
        case CBPeripheralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case CBPeripheralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBPeripheralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            
            [self showMessageInfoWithUnSupported];
            break;
        case CBPeripheralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            
            [self showMessageInfoWithOff];
            break;
        case CBPeripheralManagerStatePoweredOn:
        {
            
            NSLog(@"CBCentralManagerStatePoweredOn");
            
            [self addMyService];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 私有方法
/* 创建特征、服务并添加服务到外围设备 */
- (void)addMyService{
    /*1.创建特征*/
    //创建特征的UUID对象
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:kCharacteristicUUID];
    /* 创建特征
     * 参数
     * uuid:特征标识
     * properties:特征的属性，例如：可通知、可写、可读等
     * value:特征值
     * permissions:特征的权限
     */
    CBMutableCharacteristic *characteristicM =
    [[CBMutableCharacteristic alloc] initWithType:characteristicUUID
                                       properties:CBCharacteristicPropertyNotify
                                            value:nil
                                      permissions:CBAttributePermissionsReadable];
    self.characteristicM = characteristicM;
    //创建服务UUID对象
    CBUUID *serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
    //创建服务
    CBMutableService *serviceM = [[CBMutableService alloc] initWithType:serviceUUID
                                                                primary:YES];
    //设置服务的特征
    [serviceM setCharacteristics:@[characteristicM]];
    //将服务添加到外围设备
    [self.peripheralManager addService:serviceM];
}

/* 外围设备恢复状态时调用 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral
         willRestoreState:(NSDictionary *)dict
{
    NSLog(@"状态恢复");
}
/* 外围设备管理器添加服务后调用 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service
                    error:(NSError *)error
{
    //    NSString *str = @"13006342357";
    //    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    //    NSString *degestString = [data base64EncodedStringWithOptions:0];
    //    //设置设备信息dict，CBAdvertisementDataLocalNameKey是设置设备名
    //    NSDictionary *dict = @{CBAdvertisementDataLocalNameKey:degestString};
    //    //开始广播
    //    [self.peripheralManager startAdvertising:dict];
    NSLog(@"向外围设备添加了服务并开始广播...");
    
}

/* 外围设备管理器启动广播后调用 */
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error
{
    if (error) {
        NSLog(@"启动广播过程中发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    NSLog(@"启动广播...");
    
    [self showMessage:@"已触发蓝牙开门，请查看门禁状态" image:[TCCloudTalkingImageTool getToolsBundleImage:@"TC_打钩ico"]];
}
/* 中央设备订阅特征时调用 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral
                  central:(CBCentral *)central
didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"中心设备：%@ 已订阅特征：%@.",central,characteristic);
    //把订阅的中央设备存储下来
    if (![self.centralM containsObject:central]) {
        [self.centralM addObject:central];
    }
}
/* 中央设备取消订阅特征时调用 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral
                  central:(CBCentral *)central
didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"中心设备：%@ 取消订阅特征：%@",central,characteristic);
}

/* 外围设备管理器收到中央设备写请求时调用 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral
  didReceiveWriteRequests:(CBATTRequest *)request
{
    NSLog(@"收到写请求");
}



- (void)showMessageInfoWithUnSupported
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前设备可能不支持蓝牙!" preferredStyle:(UIAlertControllerStyleAlert)];

    //字体颜色
    alertView.view.tintColor = [UIColor blackColor];

    //style：设置提示弹窗样式
    UIAlertAction *select = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {


    }];
    [alertView addAction:select];
    [self presentViewController:alertView animated:YES completion:nil];

    
}

- (void)showMessageInfoWithOff
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"蓝牙未开启,请在设置中打开蓝牙!" preferredStyle:(UIAlertControllerStyleAlert)];

    //字体颜色
    alertView.view.tintColor = [UIColor blackColor];

    //style：设置提示弹窗样式
    UIAlertAction *select = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {



    }];
    [alertView addAction:select];
    [self presentViewController:alertView animated:YES completion:nil];
   
}


/**
 *  显示信息
 *
 *  @param msg   文字内容
 *  @param image 图片对象
 */
- (void)showMessage:(NSString *)msg image:(UIImage *)image
{
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 设置按钮文字大小
    btn.titleLabel.font = XWFont;
    btn.frame = CGRectMake(0, -XWWindowHeight, [UIScreen mainScreen].bounds.size.width, XWWindowHeight);
    // 切掉文字左边的 10
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [btn setBackgroundImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TC_Ble_BackBtn"] forState:UIControlStateNormal];
    // 设置数据
    [btn setTitle:msg forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    
    // 动画
    [UIView animateWithDuration:XWDuration animations:^{
        CGRect frame = btn.frame;
        frame.origin.y = TCNaviH;
        btn.frame = frame;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:XWDuration delay:XWDelay options:kNilOptions animations:^{
            CGRect frame = btn.frame;
            frame.origin.y = -XWWindowHeight;
            btn.frame = frame;
        } completion:^(BOOL finished) {
            [btn removeFromSuperview];
        }];
    }];
}




@end
