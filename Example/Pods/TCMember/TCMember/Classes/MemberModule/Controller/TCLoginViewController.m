//
//  TCLoginViewController.m
//  UHomeMember
//
//  Created by Huang ZhiBing on 2019/10/10.
//  Copyright © 2019 TC. All rights reserved.
//

#import "TCLoginViewController.h"
#import <TCPublicKit/TCPublicKit.h>
#import <Masonry/Masonry.h>
#import "TCFindPwdViewController.h"
#import "TCRegisterViewController.h"
#import <TCPublicKit/TCHttpTool.h>
#import "MemberBaseHeader.h"
#import <YYKit/YYKit.h>
#import "ZYOptionView.h"
#import "TCCloudServerModel.h"
#import <MJExtension.h>
#import <AFNetworking.h>

@interface TCLoginViewController () <UITextFieldDelegate, ZYOptionViewDelegate>
@property (nonatomic, strong) UIImageView *imgViewBg;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *imgCloudServerIcon;
@property (nonatomic, strong) ZYOptionView *cloudServerOptionView;
@property (nonatomic, strong) UIImageView *imgAccountIcon;
@property (nonatomic, strong) UITextField *textFieldAccount;
@property (nonatomic, strong) UIImageView *imgPwdIcon;
@property (nonatomic, strong) UITextField *textFieldPwd;
@property (nonatomic, strong) UIButton *btnRegist;
@property (nonatomic, strong) UIButton *btnForgetPwd;
@property (nonatomic, strong) UIButton *btnLogin;
@property (nonatomic, strong) UIButton *btnSwitchLoginRole;
@property (nonatomic, strong) UIView *viewLine0;
@property (nonatomic, strong) UIView *viewLine1;
@property (nonatomic, strong) UIView *viewLine2;
@property (nonatomic, strong) UIButton *btnSwitchStatus;
// 同意
@property (nonatomic, strong) YYLabel *agreeLbl;
@property (nonatomic, strong) UIButton *btnCheckBox;
// 底部切换登录方式
@property (nonatomic, strong) UIButton *btnBottomLoginStyle;
@property (nonatomic, strong) UIView *viewBottomLeftLine;
@property (nonatomic, strong) UIView *viewBottomRightLine;
// 云服务商列表
@property (nonatomic, strong) NSMutableArray *cloudServerList;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation TCLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:TCLoginStyleKey]; // 登录方式
    self.btnBottomLoginStyle.selected = flag;
     if (flag) {
        self.textFieldAccount.placeholder = @"请输入您的账号";
        self.textFieldAccount.keyboardType = UIKeyboardTypeDefault;
    } else {
        self.textFieldAccount.placeholder = @"请输入您的手机号";
        self.textFieldAccount.keyboardType = UIKeyboardTypePhonePad;
    }
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
       [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
           if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
               [self getCloudServerRequest];
           }
           NSLog(@"statusstatusstatusstatus:%ld", status);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 如果保存了云服务商信息，直接可以点击登录调用
    NSString *cloudServerHost = [[NSUserDefaults standardUserDefaults] objectForKey:TCCloudServerHostKey];
    if (cloudServerHost.length) {
        _selectedIndex = 0;
    } else {
        _selectedIndex = -1;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imgViewBg];
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.imgCloudServerIcon];
    [self.view addSubview:self.cloudServerOptionView];
    [self.view addSubview:self.imgAccountIcon];
    [self.view addSubview:self.textFieldAccount];
    [self.view addSubview:self.imgPwdIcon];
    [self.view addSubview:self.textFieldPwd];
    [self.view addSubview:self.btnRegist];
    [self.view addSubview:self.btnForgetPwd];
    [self.view addSubview:self.btnLogin];
    [self.view addSubview:self.viewLine0];
    [self.view addSubview:self.viewLine1];
    [self.view addSubview:self.viewLine2];
    [self.view addSubview:self.agreeLbl];
    [self.view addSubview:self.btnCheckBox];
    [self.view addSubview:self.btnBottomLoginStyle];
    [self.view addSubview:self.viewBottomLeftLine];
    [self.view addSubview:self.viewBottomRightLine];
}

#pragma mark - Private

- (void)changeLoginStyle:(UIButton *)btn
{
    if (btn.selected) {
        [MBManager showBriefAlert:@"已更改为输入手机号模式"];
        self.textFieldAccount.placeholder = @"请输入您的手机号";
        self.textFieldAccount.keyboardType = UIKeyboardTypePhonePad;
    } else {
        [MBManager showBriefAlert:@"已更改为输入账号模式"];
        self.textFieldAccount.placeholder = @"请输入您的账号";
        self.textFieldAccount.keyboardType = UIKeyboardTypeDefault;
    }
    btn.selected = !btn.isSelected;
    [[NSUserDefaults standardUserDefaults] setBool:self.btnBottomLoginStyle.selected forKey:TCLoginStyleKey];   // 保存登录方式
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.imgViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12*TCFrameRatioWidth);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(254);
        make.height.mas_equalTo(256);
    }];
    [self.imgCloudServerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36);
        make.top.mas_equalTo(self.imgView.mas_bottom);
        make.width.height.mas_equalTo(22);
    }];
    [self.cloudServerOptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.imgCloudServerIcon.mas_centerY);
        make.left.mas_equalTo(self.imgCloudServerIcon.mas_right).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(35);
    }];
    [self.viewLine0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cloudServerOptionView.mas_bottom).offset(6);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(0.5);
    }];
    [self.imgAccountIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36);
        make.top.mas_equalTo(self.viewLine0.mas_bottom).offset(20);
        make.width.height.mas_equalTo(22);
    }];
    [self.textFieldAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.imgAccountIcon.mas_centerY);
        make.left.mas_equalTo(self.imgAccountIcon.mas_right).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(35);
    }];
    [self.viewLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textFieldAccount.mas_bottom).offset(6);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.imgPwdIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36);
        make.top.mas_equalTo(self.viewLine1.mas_bottom).offset(20);
        make.width.height.mas_equalTo(22);
    }];
    [self.textFieldPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.imgPwdIcon.mas_centerY);
        make.left.mas_equalTo(self.imgPwdIcon.mas_right).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(35);
    }];
    [self.viewLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textFieldPwd.mas_bottom).offset(6);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(0.5);
    }];
    [self.btnRegist mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.viewLine2.mas_bottom).offset(18);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(35);
    }];
    [self.btnForgetPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.viewLine2.mas_bottom).offset(18);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(35);
    }];
    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnForgetPwd.mas_bottom).offset(30);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(50);
    }];
    [self.btnBottomLoginStyle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-25*TCFrameRatioWidth);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    [self.viewBottomLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(35);
        make.right.mas_equalTo(self.btnBottomLoginStyle.mas_left).offset(-15);
        make.centerY.mas_equalTo(self.btnBottomLoginStyle.mas_centerY);
        make.height.mas_equalTo(1);
    }];
    [self.viewBottomRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.btnBottomLoginStyle.mas_right).offset(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.btnBottomLoginStyle.mas_centerY);
        make.height.mas_equalTo(1);
    }];
    [self.agreeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(20);
        make.bottom.mas_equalTo(self.btnBottomLoginStyle.mas_top).offset(-15);
    }];
    [self.btnCheckBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.agreeLbl.mas_left);
        make.centerY.mas_equalTo(self.agreeLbl.mas_centerY);
        make.width.height.mas_equalTo(40);
    }];
}

- (void)findPwdBtnClick:(UIButton *)btn
{
    TCFindPwdViewController *findPwdVc = [[TCFindPwdViewController alloc] init];
    [self.navigationController pushViewController:findPwdVc animated:YES];
}

- (void)btnRegisterClick:(UIButton *)btn
{
    TCRegisterViewController *registerVc = [[TCRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVc animated:YES];
}

- (void)loginBtnClick:(UIButton *)btn
{
    if (self.selectedIndex == -1) {
        [MBManager showBriefAlert:@"请选择您的云服务商"];
        return;
    }
    if (self.btnBottomLoginStyle.selected) {  // 账号
        if (self.textFieldAccount.text.length <= 0) {
            [MBManager showBriefAlert:@"请输入您的账号"];
            return;
        }
    } else {                                // 手机很号
        if (![NSString valiMobile:self.textFieldAccount.text]) {
            [MBManager showBriefAlert:@"请输入正确的手机号码"];
            return;
        }
    }
    if (self.textFieldPwd.text.length <= 0) {
        [MBManager showBriefAlert:@"请输入密码"];
        return;
    }
    if (!self.btnCheckBox.isSelected) {
        [MBManager showBriefAlert:@"同意《用户协议》和《隐私权政策》才能登录"];
        return;
    }
    [self LoginRequest];
}

// 获取云服务商接口
- (void)getCloudServerRequest
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setTimeoutInterval:10];
    [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
     [MBManager showLoading];
    WEAKSELF
    [[TCHttpTool sharedHttpTool] getWithURL:GetCloudServerURL params:nil withManager:mgr success:^(id _Nonnull json) {
        [MBManager hideAlert];
        weakSelf.cloudServerList = [TCCloudServerModel mj_objectArrayWithKeyValuesArray:json];
        [weakSelf.cloudServerOptionView setDataSource:weakSelf.cloudServerList];        
    } failure:^(NSError * _Nonnull error) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:error.localizedDescription];
    }];
}


// 登录接口
- (void)LoginRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"uhome.ios" forKey:@"client_id"];
    [params setObject:@"123456" forKey:@"client_secret"];
    [params setObject:@"password" forKey:@"grant_type"];
    [params setObject:@"openid profile uhome uhome.rke uhome.o2o uhome.park" forKey:@"scope"];
    [params setObject:self.textFieldAccount.text forKey:@"username"];
    [params setObject:self.textFieldPwd.text forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:self.textFieldAccount.text forKey:TCUsername];
    [[NSUserDefaults standardUserDefaults] setObject:self.textFieldPwd.text forKey:TCPassword];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setTimeoutInterval:10];
    [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
     [MBManager showLoading];
    WEAKSELF
    [[TCHttpTool sharedHttpTool] postWithURL:LoginURL params:params withManager:mgr success:^(id _Nonnull json) {
        // 保存token
        NSString *access_token = [json objectForKey:@"access_token"];
        NSLog(@"access_token:%@", access_token);
        [[TCHttpTool sharedHttpTool] updateMgrRequestAccessToken:access_token];
        // 分成三段，取中间段解密,获取subId
        NSArray *valueList = [[json objectForKey:@"access_token"] componentsSeparatedByString:@"."];
        NSString *base64 = nil;
        if (valueList.count == 3) {
            base64 = valueList[1];
            // 获取用户信息
            [weakSelf GetUserInfoRequest];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBManager hideAlert];
        if (error.code == -1011) {  //  服务器那边如果密码错误，直接返回了400错误，只能先这样处理。
            [MBManager showBriefAlert:@"用户名或者密码错误"];
        } else if (error.code == -1009) {
            [MBManager showBriefAlert:@"互联网似乎断开了连接"];
        } else {
            [MBManager showBriefAlert:error.localizedDescription];
        }
    }];
}

// 登录接口
- (void)GetUserInfoRequest
{
    [[TCHttpTool sharedHttpTool] getWithURL:UserInfoURL params:nil success:^(id  _Nonnull json) {
        [MBManager hideAlert];
        NSInteger code = [[json objectForKey:@"code"] integerValue];
        if (code == 0) {
            NSDictionary *dict = [json objectForKey:@"data"];
            NSData *dataData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *dataJsonString = [[NSString alloc] initWithData:dataData encoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults] setObject:dataJsonString forKey:TCMemberInfoKey]; // 保存用户信息
            [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"id"] forKey:TCUserId];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 如果有默认小区，去获取小区信息，根据返回信息可知道是否是5000小区
            NSString *defaultCommunityId = [dict objectForKey:@"defaultCommunityId"];
            if ((defaultCommunityId != nil) && ![defaultCommunityId isEqual:[NSNull null]] && (defaultCommunityId.length > 0)) {
                [self GetCommunitiesWithComId:defaultCommunityId];
            }
            if (self.loginSucceedAction) {
                self.loginSucceedAction(0);
            }
            NSDictionary *userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"id"], @"id", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccessNotification" object:self userInfo:userInfoDict];
        } else {
            [MBManager showBriefAlert:[json objectForKey:@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBManager showBriefAlert:@"用户名或者密码错误"];
    }];
}

// 获取小区信息
- (void)GetCommunitiesWithComId:(NSString *)comId
{
    [[TCHttpTool sharedHttpTool] getWithURL:[NSString stringWithFormat:@"%@/%@", GetCommunitiesInfoURL, comId] params:nil success:^(id  _Nonnull json) {
           [MBManager hideAlert];
           NSInteger code = [[json objectForKey:@"code"] integerValue];
           if (code == 0) {
               NSDictionary *dict = [json xyValueForKey:@"data"];
               if (dict) {
                   BOOL is5000Platform = [[dict objectForKey:@"platform"] boolValue];
                   [[NSUserDefaults standardUserDefaults] setBool:is5000Platform forKey:TCIs5000PlatformKey]; // 保存是否是5000平台的信息
                   BOOL intercomScheme = [[dict objectForKey:@"intercomScheme"] boolValue];
                   [[NSUserDefaults standardUserDefaults] setBool:intercomScheme forKey:TCIntercomSchemeKey]; // 保存通道 0云之讯  1菊风
                   [[NSUserDefaults standardUserDefaults] synchronize];
               }
           } else {
               NSLog(@"%@", [json objectForKey:@"message"]);
           }
       } failure:^(NSError * _Nonnull error) {
           NSLog(@"获取小区信息失败：%@", error.localizedFailureReason);
       }];
}

- (void)textFieldChange:(UITextField *)textField
{
    if (self.textFieldAccount.text.length && self.textFieldPwd.text.length) {
        self.btnLogin.enabled = YES;
        [self.btnLogin setBackgroundColor:[UIColor colorWithHexString:MainColor]];
    } else {
        self.btnLogin.enabled = NO;
        [self.btnLogin setBackgroundColor:[UIColor colorWithHexString:@"#E0E9FF"]];
    }
}

- (void)btnSwitchStatusClick:(UIButton *)btn
{
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {
        self.textFieldPwd.secureTextEntry = NO;
    } else {
        self.textFieldPwd.secureTextEntry = YES;
    }
}

- (void)checkBoxClick:(UIButton *)btn
{
    if (btn.isSelected) {
        [MBManager showBriefAlert:@"同意《用户协议》和《隐私权政策》才能登录"];
    }
    btn.selected = !btn.isSelected;
}

#pragma mark - ZYOptionViewDelegate

- (void)zyOptionView:(ZYOptionView *)optionView selectedIndex:(NSInteger)selectedIndex
{
    NSLog(@"%zd", selectedIndex);
    self.selectedIndex = selectedIndex;
    TCCloudServerModel *serverModel = self.cloudServerList[selectedIndex];
    NSString *serverHost = serverModel.host;
    if ([serverHost hasSuffix:@"/"] && serverModel.host.length > 2) {
        serverHost = [serverHost substringToIndex:serverHost.length - 1];
    }
    NSString *o2oHost = serverModel.o2o.host;
    if ([o2oHost hasSuffix:@"/"] && o2oHost.length > 2) {
        o2oHost = [o2oHost substringToIndex:o2oHost.length - 1];
    }
    [[NSUserDefaults standardUserDefaults] setObject:serverModel.name forKey:TCCloudServerNameKey];
    [[NSUserDefaults standardUserDefaults] setObject:serverHost forKey:TCCloudServerHostKey];
    [[NSUserDefaults standardUserDefaults] setObject:serverModel.icon forKey:TCCloudServerIconKey];
    [[NSUserDefaults standardUserDefaults] setObject:o2oHost forKey:TCCloudServerO2OHostKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Get

- (UIButton *)btnCheckBox
{
    if (_btnCheckBox == nil) {
        _btnCheckBox = [[UIButton alloc] init];
        [_btnCheckBox setImage:[UIImage tc_imgWithName:@"member_check_nor" bundle:TCMemberBundelName targetClass:[self class]] forState:UIControlStateNormal];
        [_btnCheckBox setImage:[UIImage tc_imgWithName:@"member_check_pre" bundle:TCMemberBundelName targetClass:[self class]] forState:UIControlStateSelected];
        [_btnCheckBox addTarget:self action:@selector(checkBoxClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnCheckBox.selected = YES;
    }
    return _btnCheckBox;
}

- (YYLabel *)agreeLbl
{
    if (_agreeLbl == nil) {
        _agreeLbl = [[YYLabel alloc] init];
       NSString *textStr = @"同意《用户协议》和《隐私权政策》";
        NSMutableAttributedString  *attriStr = [[NSMutableAttributedString alloc] initWithString:textStr];
        NSRange range1 =[textStr rangeOfString:@"《用户协议》" options:NSCaseInsensitiveSearch];
        NSRange range2 =[textStr rangeOfString:@"《隐私权政策》" options:NSCaseInsensitiveSearch];
        [attriStr setFont:[UIFont systemFontOfSize:15]];
        [attriStr setTextHighlightRange:range1 color:[UIColor colorWithHexString:MainColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToUserAgreementNotification" object:nil];
        }];
        [attriStr setTextHighlightRange:range2 color:[UIColor colorWithHexString:MainColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToPrivacyPolicyNotification" object:nil];
        }];
        _agreeLbl.attributedText = attriStr;
    }
    return _agreeLbl;
}

- (UIImageView *)imgViewBg
{
    if (_imgViewBg == nil) {
        _imgViewBg = [[UIImageView alloc] init];
        [_imgViewBg setImage:[UIImage tc_imgWithName:@"member_loginBg" bundle:TCMemberBundelName targetClass:[self class]]];
    }
    return _imgViewBg;
}

- (UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        [_imgView setImage:[UIImage tc_imgWithName:@"member_logo" bundle:TCMemberBundelName targetClass:[self class]]];
    }
    return _imgView;
}

- (ZYOptionView *)cloudServerOptionView
{
    if (_cloudServerOptionView == nil) {
        _cloudServerOptionView = [[ZYOptionView alloc] init];
        _cloudServerOptionView.delegate = self;
        _cloudServerOptionView.backgroundColor = [UIColor clearColor];
    }
    return _cloudServerOptionView;
}

- (UITextField *)textFieldAccount
{
    if (_textFieldAccount == nil) {
        _textFieldAccount = [[UITextField alloc] init];
        _textFieldAccount.placeholder = @"请输入您的手机号";
        [_textFieldAccount setFont:[UIFont systemFontOfSize:15]];
        _textFieldAccount.tintColor = [UIColor colorWithHexString:MainColor];
        [_textFieldAccount addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        _textFieldAccount.tag = 0;
        _textFieldAccount.keyboardType = UIKeyboardTypePhonePad;
        _textFieldAccount.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textFieldAccount.backgroundColor = [UIColor clearColor];
    }
    return _textFieldAccount;
}

- (UITextField *)textFieldPwd
{
    if (_textFieldPwd == nil) {
        _textFieldPwd = [[UITextField alloc] init];
        _textFieldPwd.placeholder = @"请输入您的密码";
        [_textFieldPwd setFont:[UIFont systemFontOfSize:15]];
        _textFieldPwd.tintColor = [UIColor colorWithHexString:MainColor];
        [_textFieldPwd addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        _textFieldPwd.tag = 1;
        _textFieldPwd.rightViewMode = UITextFieldViewModeAlways;
        
        self.btnSwitchStatus = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 23)];
        [self.btnSwitchStatus setBackgroundImage:[UIImage tc_imgWithName:@"member_closeEye" bundle:TCMemberBundelName targetClass:[self class]] forState:UIControlStateNormal];
        [self.btnSwitchStatus setBackgroundImage:[UIImage tc_imgWithName:@"member_openEye" bundle:TCMemberBundelName targetClass:[self class]] forState:UIControlStateSelected];
        [self.btnSwitchStatus addTarget:self action:@selector(btnSwitchStatusClick:) forControlEvents:UIControlEventTouchUpInside];
        self.textFieldPwd.secureTextEntry = YES;
        _textFieldPwd.rightView = self.btnSwitchStatus;
        _textFieldPwd.backgroundColor = [UIColor clearColor];
    }
    return _textFieldPwd;
}

- (UIButton *)btnRegist
{
    if (_btnRegist == nil) {
        _btnRegist = [[UIButton alloc] init];
        [_btnRegist setTitle:@"快速注册" forState:UIControlStateNormal];
        [_btnRegist setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnRegist.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_btnRegist addTarget:self action:@selector(btnRegisterClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRegist;
}

- (UIButton *)btnForgetPwd
{
    if (_btnForgetPwd == nil) {
        _btnForgetPwd = [[UIButton alloc] init];
        [_btnForgetPwd setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_btnForgetPwd setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateNormal];
        [_btnForgetPwd.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_btnForgetPwd addTarget:self action:@selector(findPwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnForgetPwd;
}

- (UIButton *)btnLogin
{
    if (_btnLogin == nil) {
        _btnLogin = [[UIButton alloc] init];
        [_btnLogin setTitle:@"登  录" forState:UIControlStateNormal];
        [_btnLogin.titleLabel setFont:[UIFont systemFontOfSize:19]];
        [_btnLogin setBackgroundColor:[UIColor colorWithHexString:@"#E0E9FF"]];
        _btnLogin.enabled = NO;
        [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnLogin.layer.cornerRadius = 5;
        _btnLogin.layer.masksToBounds = YES;
        [_btnLogin addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLogin;
}

- (UIView *)viewLine0
{
    if (_viewLine0 == nil) {
        _viewLine0 = [[UIView alloc] init];
        _viewLine0.backgroundColor = [UIColor colorWithHexString:LineColor];
    }
    return _viewLine0;
}

- (UIView *)viewLine1
{
    if (_viewLine1 == nil) {
        _viewLine1 = [[UIView alloc] init];
        _viewLine1.backgroundColor = [UIColor colorWithHexString:LineColor];
    }
    return _viewLine1;
}

- (UIView *)viewLine2
{
    if (_viewLine2 == nil) {
        _viewLine2 = [[UIView alloc] init];
        _viewLine2.backgroundColor = [UIColor colorWithHexString:LineColor];
    }
    return _viewLine2;
}

- (UIImageView *)imgCloudServerIcon
{
    if (_imgCloudServerIcon == nil) {
        _imgCloudServerIcon = [[UIImageView alloc] init];
        [_imgCloudServerIcon setImage:[UIImage tc_imgWithName:@"member_cloudServer" bundle:TCMemberBundelName targetClass:[self class]]];
    }
    return _imgCloudServerIcon;
}

- (UIImageView *)imgAccountIcon
{
    if (_imgAccountIcon == nil) {
        _imgAccountIcon = [[UIImageView alloc] init];
        [_imgAccountIcon setImage:[UIImage tc_imgWithName:@"member_userName" bundle:TCMemberBundelName targetClass:[self class]]];
    }
    return _imgAccountIcon;
}

- (UIImageView *)imgPwdIcon
{
    if (_imgPwdIcon == nil) {
        _imgPwdIcon = [[UIImageView alloc] init];
        [_imgPwdIcon setImage:[UIImage tc_imgWithName:@"member_userPwd" bundle:TCMemberBundelName targetClass:[self class]]];
    }
    return _imgPwdIcon;
}

- (UIView *)viewBottomLeftLine
{
    if (_viewBottomLeftLine == nil) {
        _viewBottomLeftLine = [[UIView alloc] init];
        _viewBottomLeftLine.backgroundColor = [UIColor colorWithHexString:LineColor];
    }
    return _viewBottomLeftLine;
}

- (UIView *)viewBottomRightLine
{
    if (_viewBottomRightLine == nil) {
        _viewBottomRightLine = [[UIView alloc] init];
        _viewBottomRightLine.backgroundColor = [UIColor colorWithHexString:LineColor];
    }
    return _viewBottomRightLine;
}

- (UIButton *)btnBottomLoginStyle
{
    if (_btnBottomLoginStyle == nil) {
        _btnBottomLoginStyle = [[UIButton alloc] init];
        [_btnBottomLoginStyle setTitle:@"使用其它方式登录" forState:UIControlStateNormal];
        [_btnBottomLoginStyle setTitle:@"使用手机号登录" forState:UIControlStateSelected];
        [_btnBottomLoginStyle setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _btnBottomLoginStyle.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnBottomLoginStyle addTarget:self action:@selector(changeLoginStyle:) forControlEvents:UIControlEventTouchUpInside];
        _btnBottomLoginStyle.selected = NO;
    }
    return _btnBottomLoginStyle;
}

@end
