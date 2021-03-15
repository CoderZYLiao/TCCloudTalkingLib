//
//  TCCTCatEyeOperateVC.m
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/17.
//

#import "TCCTCatEyeOperateVC.h"
#import "TCCTCatEyeModel.h"
#import "TCCTScanVC.h"
#import "TCCTApiManager.h"
#import <YYModel.h>

@interface TCCTCatEyeOperateVC ()<TCCTScanVCDelegate>

@property (nonatomic, strong) UIView *deviceNameView;
@property (nonatomic, strong) UILabel *deviceNameLabel;
@property (nonatomic, strong) UITextField *deviceNameTF;
@property (nonatomic, strong) UIView *deviceNumView;
@property (nonatomic, strong) UILabel *deviceNumLabel;
@property (nonatomic, strong) UITextField *deviceNumTF;
@property (nonatomic, strong) UIButton *scanCodeBtn;
@property (nonatomic, strong) UIView *devicePwdView;
@property (nonatomic, strong) UILabel *devicePwdLabel;
@property (nonatomic, strong) UITextField *devicePwdTF;
@property (nonatomic, strong) UIButton *showPwdBtn;
@property (nonatomic, strong) UIButton *commitBtn;

@property (nonatomic, copy) NSString *deviceHardCode;       //硬件码

@end

@implementation TCCTCatEyeOperateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
    self.view.backgroundColor = [UIColor colorWithHexString:Color_bgColor];
    [self initThePageLayout];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self.deviceNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(TccHeight(10));
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(TccHeight(50));
    }];
    [self.deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deviceNameView).offset(TccWidth(20));
        make.centerY.mas_equalTo(self.deviceNameView);
    }];
    [self.deviceNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deviceNameView).offset(TccWidth(115));
        make.centerY.mas_equalTo(self.deviceNameView);
        make.right.mas_equalTo(self.deviceNameView).offset(-TccWidth(20));
        make.height.mas_equalTo(TccHeight(35));
    }];
    
    [self.deviceNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.deviceNameView.mas_bottom).offset(TccHeight(5));
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(TccHeight(50));
    }];
    [self.deviceNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deviceNumView).offset(TccWidth(20));
        make.centerY.mas_equalTo(self.deviceNumView);
    }];
    [self.deviceNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deviceNumView).offset(TccWidth(115));
        make.centerY.mas_equalTo(self.deviceNumView);
        make.right.mas_equalTo(self.deviceNumView).offset(-TccWidth(20));
        make.height.mas_equalTo(TccHeight(35));
    }];
    [self.scanCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.deviceNumView);
        make.right.mas_equalTo(self.deviceNumTF.mas_right);
        make.height.width.mas_equalTo(TccWidth(35));
    }];
    
    [self.devicePwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.deviceNumView.mas_bottom).offset(TccHeight(5));
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(TccHeight(50));
    }];
    [self.devicePwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.devicePwdView).offset(TccWidth(20));
        make.centerY.mas_equalTo(self.devicePwdView);
    }];
    [self.devicePwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.devicePwdView).offset(TccWidth(115));
        make.centerY.mas_equalTo(self.devicePwdView);
        make.right.mas_equalTo(self.devicePwdView).offset(-TccWidth(20));
        make.height.mas_equalTo(TccHeight(35));
    }];
    [self.showPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.devicePwdView);
        make.right.mas_equalTo(self.devicePwdTF.mas_right);
        make.height.width.mas_equalTo(TccWidth(35));
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.devicePwdView.mas_bottom).offset(TccHeight(30));
        make.left.mas_equalTo(TccWidth(20));
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(TccHeight(40));
    }];
    
}

#pragma mark - Init Page Layout
- (void)initThePageLayout{
    [self.view addSubview:self.deviceNameView];
    [self.deviceNameView addSubview:self.deviceNameLabel];
    [self.deviceNameView addSubview:self.deviceNameTF];
    [self.view addSubview:self.deviceNumView];
    [self.deviceNumView addSubview:self.deviceNumLabel];
    [self.deviceNumView addSubview:self.deviceNumTF];
    [self.deviceNumView addSubview:self.scanCodeBtn];
    [self.view addSubview:self.devicePwdView];
    [self.devicePwdView addSubview:self.devicePwdLabel];
    [self.devicePwdView addSubview:self.devicePwdTF];
    [self.devicePwdView addSubview:self.showPwdBtn];
    [self.view addSubview:self.commitBtn];
    
    if (self.deviceOperate == CatEyeDeviceOperate_Add) {
        self.navigationItem.title = @"添加设备";
        [self.commitBtn setTitle:@"添加" forState:UIControlStateNormal];
    }else{
        self.navigationItem.title = @"编辑设备";
        [self.commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [self.deviceNameTF setText:self.catEyeModel.deviceName];
        [self.deviceNumTF setText:self.catEyeModel.deviceNum];
        [self.deviceNumTF setUserInteractionEnabled:NO];
        self.scanCodeBtn.hidden = YES;
        
        [self.devicePwdTF setText:self.catEyeModel.devicePwd];
        if (self.catEyeModel.ownFlag.integerValue != 1) {
            [self.devicePwdTF setUserInteractionEnabled:NO];
            self.showPwdBtn.hidden = YES;
        }
        
        [self setRightBarButtonWithImageName:@"sm_navDel"];
    }
}

#pragma mark - Event Response
///设备机身号扫码
- (void)scanCodeBtnClick:(id)sender{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized || status == AVAuthorizationStatusNotDetermined) {
        TCCTScanVC *scanQRCodeVC = [[TCCTScanVC alloc]init];
        scanQRCodeVC.delegate = self;
        UINavigationController *naviC = [[UINavigationController alloc]initWithRootViewController:scanQRCodeVC];
        [self.navigationController presentViewController:naviC animated:YES completion:nil];
    } else {
        [MBManager showBriefAlert:@"请先打开相机权限"];
    }
}

///设备密码明密文i切换
- (void)showPwdBtnClick:(id)sender{
    if (self.devicePwdTF.secureTextEntry) {
        [self.devicePwdTF setSecureTextEntry:NO];
        self.showPwdBtn.selected = YES;
    }else{
        [self.devicePwdTF setSecureTextEntry:YES];
        self.showPwdBtn.selected = NO;
    }
}

///提交
- (void)commitBtnClick:(id)sender{
    if (_deviceOperate == CatEyeDeviceOperate_Add) {
        if (!self.deviceNameTF.text || [self.deviceNameTF.text isEqualToString:@""]) {
            [MBManager showBriefAlert:@"请输入设备名称"];
            return;
        }
        if (!self.deviceNumTF.text || [self.deviceNumTF.text isEqualToString:@""]) {
            [MBManager showBriefAlert:@"请扫码设备机身号"];
            return;
        }
        if (!self.devicePwdTF.text || [self.devicePwdTF.text isEqualToString:@""]) {
            [MBManager showBriefAlert:@"请输入设备密码"];
            return;
        }
        
        [self reloadAddCatEyeRequest];
    }else{
        if (!self.deviceNameTF.text || [self.deviceNameTF.text isEqualToString:@""]) {
            [MBManager showBriefAlert:@"请输入设备名称"];
            return;
        }
        if (!self.devicePwdTF.text || [self.devicePwdTF.text isEqualToString:@""]) {
            [MBManager showBriefAlert:@"请输入设备密码"];
            return;
        }
        
        [self reloadUpdCatEyeRequest];
    }
}

//删除
- (void)clickRightBarButtonItem:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确认删除该猫眼设备？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reloadDelCatEyeRequest];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - HTTPS请求 添加猫眼、编辑猫眼、删除猫眼
//添加猫眼
- (void)reloadAddCatEyeRequest{
    [MBManager showLoading];
    [TCCTApiManager addCatEyeWithDeviceName:self.deviceNameTF.text andDeviceNum:self.deviceNumTF.text andDeviceCode:self.deviceHardCode andDevicePwd:self.devicePwdTF.text success:^(id  _Nonnull responseObject) {
        [MBManager hideAlert];
        if (responseObject && ([[responseObject objectForKey:jsonResult_Code] integerValue] == 0)) {
            BOOL requestBool = [[responseObject objectForKey:jsonResult_Data] boolValue];
            if (requestBool) {
                [MBManager showBriefAlert:@"新增猫眼设备成功"];
                TCCTCatEyeModel *catEyeModel = [TCCTCatEyeModel yy_modelWithJSON:[responseObject objectForKey:jsonResult_Data]];
                catEyeModel.devType = 3000;
                self.catEyeModel = catEyeModel;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backViewController];
                });
            }else{
                [MBManager showBriefAlert:@"新增猫眼设备失败"];
            }
        }else{
            [MBManager showBriefAlert:[responseObject objectForKey:jsonResult_Msg]];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:https_requestTimeout];
    }];
}
//编辑猫眼
- (void)reloadUpdCatEyeRequest{
    [MBManager showLoading];
    [TCCTApiManager editCatEyeWithCatEyeID:self.catEyeModel.id andDeviceName:self.deviceNameTF.text andDevicePwd:self.devicePwdTF.text success:^(id  _Nonnull responseObject) {
        [MBManager hideAlert];
        if (responseObject && ([[responseObject objectForKey:jsonResult_Code] integerValue] == 0)) {
            BOOL requestBool = [[responseObject objectForKey:jsonResult_Data] boolValue];
            if (requestBool) {
                [MBManager showBriefAlert:@"编辑猫眼设备成功"];
                TCCTCatEyeModel *catEyeModel = [TCCTCatEyeModel yy_modelWithJSON:[responseObject objectForKey:jsonResult_Data]];
                catEyeModel.devType = 3000;
                self.catEyeModel = catEyeModel;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backViewController];
                });
            }else{
                [MBManager showBriefAlert:@"编辑猫眼设备失败"];
            }
        }else{
            [MBManager showBriefAlert:[responseObject objectForKey:jsonResult_Msg]];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:https_requestTimeout];
    }];
}

//删除猫眼
- (void)reloadDelCatEyeRequest{
    [MBManager showLoading];
    [TCCTApiManager deleteCatEyeWithDeviceID:self.catEyeModel.id success:^(id  _Nonnull responseObject) {
        [MBManager hideAlert];
        if (responseObject && ([[responseObject objectForKey:jsonResult_Code] integerValue] == 0)) {
            BOOL requestBool = [[responseObject objectForKey:jsonResult_Data] boolValue];
            if (requestBool) {
                [MBManager showBriefAlert:@"删除猫眼设备成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backViewController];
                });
            }else{
                [MBManager showBriefAlert:@"删除猫眼设备失败"];
            }
        }else{
            [MBManager showBriefAlert:[responseObject objectForKey:jsonResult_Msg]];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:https_requestTimeout];
    }];
}

- (void)backViewController{
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_RefreshCatEyeList object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TCCTScanVCDelegate
- (void)delegateWithScanCode:(NSString *)scanCode{
    if ([scanCode containsString:@"/"]) {
        NSArray *tempArr = [NSArray array];
        tempArr = [scanCode componentsSeparatedByString:@"/"];
        self.deviceNumTF.text = tempArr[0];
        self.deviceHardCode = tempArr[1];
    }else{
        [MBManager showBriefAlert:@"抱歉,图片暂时无法识别" ];
    }
}

#pragma mark - Get And Set
- (UIView *)deviceNameView{
    if (!_deviceNameView) {
        _deviceNameView = [UIView new];
        [_deviceNameView setBackgroundColor:[UIColor whiteColor]];
    }
    return _deviceNameView;
}

- (UILabel *)deviceNameLabel{
    if (!_deviceNameLabel) {
        _deviceNameLabel = [UILabel new];
        [_deviceNameLabel setFont:Font_Title_System18];
        [_deviceNameLabel setText:@"设备名称"];
    }
    return _deviceNameLabel;
}

- (UITextField *)deviceNameTF{
    if (!_deviceNameTF) {
        _deviceNameTF = [UITextField new];
        [_deviceNameTF setFont:Font_Title_System17];
        [_deviceNameTF setPlaceholder:@"请输入设备名称"];
        [_deviceNameTF setTextColor:[UIColor grayColor]];
        [_deviceNameTF setClearButtonMode:UITextFieldViewModeWhileEditing];
    }
    return _deviceNameTF;
}

- (UIView *)deviceNumView{
    if (!_deviceNumView) {
        _deviceNumView = [UIView new];
        [_deviceNumView setBackgroundColor:[UIColor whiteColor]];
    }
    return _deviceNumView;
}

- (UIView *)deviceNumLabel{
    if (!_deviceNumLabel) {
        _deviceNumLabel = [UILabel new];
        [_deviceNumLabel setFont:Font_Title_System18];
        [_deviceNumLabel setText:@"设备机身码"];
    }
    return _deviceNumLabel;
}

- (UITextField *)deviceNumTF{
    if (!_deviceNumTF) {
        _deviceNumTF = [UITextField new];
        [_deviceNumTF setFont:Font_Title_System17];
        [_deviceNumTF setPlaceholder:@"请输入设备机身码"];
        [_deviceNumTF setTextColor:[UIColor grayColor]];
        [_deviceNumTF setClearButtonMode:UITextFieldViewModeWhileEditing];
    }
    return _deviceNumTF;
}

- (UIButton *)scanCodeBtn{
    if (!_scanCodeBtn) {
        _scanCodeBtn = [UIButton new];
        [_scanCodeBtn setBackgroundImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_scan"] forState:UIControlStateNormal];
        [_scanCodeBtn addTarget:self action:@selector(scanCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanCodeBtn;
}

- (UIView *)devicePwdView{
    if (!_devicePwdView) {
        _devicePwdView = [UIView new];
        [_devicePwdView setBackgroundColor:[UIColor whiteColor]];
    }
    return _devicePwdView;
}

- (UILabel *)devicePwdLabel{
    if (!_devicePwdLabel) {
        _devicePwdLabel = [UILabel new];
        [_devicePwdLabel setFont:Font_Title_System18];
        [_devicePwdLabel setText:@"设备密码"];
    }
    return _devicePwdLabel;
}

- (UITextField *)devicePwdTF{
    if (!_devicePwdTF) {
        _devicePwdTF = [UITextField new];
        [_devicePwdTF setFont:Font_Title_System17];
        [_devicePwdTF setPlaceholder:@"请输入设备密码"];
        [_devicePwdTF setSecureTextEntry:YES];
        [_devicePwdTF setTextColor:[UIColor grayColor]];
        [_devicePwdTF setClearButtonMode:UITextFieldViewModeWhileEditing];
    }
    return _devicePwdTF;
}

- (UIButton *)showPwdBtn{
    if (!_showPwdBtn) {
        _showPwdBtn = [UIButton new];
        [_showPwdBtn setBackgroundImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_closeEye"] forState:UIControlStateNormal];
        [_showPwdBtn setBackgroundImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_openEye"] forState:UIControlStateSelected];
        [_showPwdBtn addTarget:self action:@selector(showPwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPwdBtn;
}

- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [UIButton new];
        [_commitBtn setBackgroundColor:[UIColor colorWithHexString:Color_globalColor]];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_commitBtn.layer setCornerRadius:Fillet_CornerRadius];
        [_commitBtn addTarget:self action:@selector(commitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

@end
