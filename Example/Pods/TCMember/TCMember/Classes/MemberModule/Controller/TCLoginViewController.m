//
//  TCLoginViewController.m
//  UHomeMember
//
//  Created by Huang ZhiBing on 2019/10/10.
//  Copyright © 2019 TC. All rights reserved.
//

#import "TCLoginViewController.h"
#import "TCPublicKit.h"
#import "Masonry.h"
#import "TCFindPwdViewController.h"
#import "TCRegisterViewController.h"
#import "TCHttpTool.h"
#import "MemberBaseHeader.h"

@interface TCLoginViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *imgViewBg;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *imgAccountIcon;
@property (nonatomic, strong) UITextField *textFieldAccount;
@property (nonatomic, strong) UIImageView *imgPwdIcon;
@property (nonatomic, strong) UITextField *textFieldPwd;
@property (nonatomic, strong) UIButton *btnRegist;
@property (nonatomic, strong) UIButton *btnForgetPwd;
@property (nonatomic, strong) UIButton *btnLogin;
@property (nonatomic, strong) UIButton *btnSwitchLoginRole;
@property (nonatomic, strong) UIView *viewLine1;
@property (nonatomic, strong) UIView *viewLine2;
@property (nonatomic, strong) UIButton *btnSwitchStatus;
@end

@implementation TCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置弹框样式
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMaximumDismissTimeInterval:3.6];
    [SVProgressHUD setMinimumDismissTimeInterval:1.2];
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imgViewBg];
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.imgAccountIcon];
    [self.view addSubview:self.textFieldAccount];
    [self.view addSubview:self.imgPwdIcon];
    [self.view addSubview:self.textFieldPwd];
    [self.view addSubview:self.btnRegist];
    [self.view addSubview:self.btnForgetPwd];
    [self.view addSubview:self.btnLogin];
    [self.view addSubview:self.viewLine1];
    [self.view addSubview:self.viewLine2];
}

#pragma mark - Private

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
    [self.imgAccountIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36);
        make.top.mas_equalTo(self.imgView.mas_bottom).offset(5);
        make.width.height.mas_equalTo(22);
    }];
    [self.textFieldAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.imgAccountIcon.mas_centerY);
        make.left.mas_equalTo(self.imgAccountIcon.mas_right).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(35);
    }];
    [self.viewLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textFieldAccount.mas_bottom).offset(10);
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
        make.top.mas_equalTo(self.textFieldPwd.mas_bottom).offset(10);
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
    if (![NSString valiMobile:self.textFieldAccount.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
        return;
    } else if (self.textFieldPwd.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return;
    }
    [self LoginRequest];
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
    [[NSUserDefaults standardUserDefaults] setObject:self.textFieldAccount.text forKey:TCPassword];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setTimeoutInterval:10];
    [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
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
         [SVProgressHUD showInfoWithStatus:@"用户名或者密码错误"];
    }];
}

// 登录接口
- (void)GetUserInfoRequest
{
    [[TCHttpTool sharedHttpTool] getWithURL:UserInfoURL params:nil success:^(id  _Nonnull json) {
        NSInteger code = [[json objectForKey:@"code"] integerValue];
        if (code == 0) {
            NSDictionary *dict = [json objectForKey:@"data"];
            NSData *dataData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *dataJsonString = [[NSString alloc] initWithData:dataData encoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults] setObject:dataJsonString forKey:TCMemberInfoKey]; // 保存用户信息
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (self.loginSucceedAction) {
                self.loginSucceedAction(0);
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[json objectForKey:@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"用户名或者密码错误"];
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

#pragma mark - Get

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

- (UITextField *)textFieldAccount
{
    if (_textFieldAccount == nil) {
        _textFieldAccount = [[UITextField alloc] init];
        _textFieldAccount.placeholder = @"请输入您的账号";
        [_textFieldAccount setFont:[UIFont systemFontOfSize:15]];
        _textFieldAccount.tintColor = [UIColor colorWithHexString:MainColor];
        [_textFieldAccount addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        _textFieldAccount.tag = 0;
        _textFieldAccount.keyboardType = UIKeyboardTypePhonePad;
        _textFieldAccount.clearButtonMode = UITextFieldViewModeWhileEditing;
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

@end
