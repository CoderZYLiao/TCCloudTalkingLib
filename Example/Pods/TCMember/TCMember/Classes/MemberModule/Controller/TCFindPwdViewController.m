//
//  TCFindPwdViewController.m
//  UHomeMember
//
//  Created by Huang ZhiBing on 2019/10/15.
//  Copyright © 2019 TC. All rights reserved.
//

#import "TCFindPwdViewController.h"
#import <TCPublicKit/TCPublicKit.h>
#import <Masonry/Masonry.h>
#import <ZXCountDownView/ZXCountDownBtn.h>
#import "MemberBaseHeader.h"
#import "TCPersonalInfoModel.h"

@interface TCFindPwdViewController ()
@property (nonatomic, strong) UIImageView *imgViewPhoneIcon;
@property (nonatomic, strong) UITextField *textFieldPhone;
@property (nonatomic, strong) UIImageView *imgViewVerifyCodeIcon;
@property (nonatomic, strong) UITextField *textFieldVerifyCode;
@property (nonatomic, strong) ZXCountDownBtn *btnGetCode;
@property (nonatomic, strong) UIImageView *imgViewPwdIcon;
@property (nonatomic, strong) UITextField *textFieldPwd;
@property (nonatomic, strong) UIButton *btnSwich;
@property (nonatomic, strong) UIButton *btnConfrm;
@property (nonatomic, strong) UIView *viewLine1;
@property (nonatomic, strong) UIView *viewLine2;
@property (nonatomic, strong) UIView *viewLine3;
@property (nonatomic, strong) NSString *access_token;
@end

@implementation TCFindPwdViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"找回密码" withBottomLineHidden:YES];
    [self.view addSubview:self.imgViewPhoneIcon];
    [self.view addSubview:self.textFieldPhone];
    [self.view addSubview:self.viewLine1];
    [self.view addSubview:self.imgViewVerifyCodeIcon];
    [self.view addSubview:self.textFieldVerifyCode];
    [self.view addSubview:self.btnGetCode];
    [self.view addSubview:self.viewLine2];
    [self.view addSubview:self.imgViewPwdIcon];
    [self.view addSubview:self.textFieldPwd];
    [self.view addSubview:self.btnSwich];
    [self.view addSubview:self.viewLine3];
    [self.view addSubview:self.btnConfrm];
}

#pragma mark - Private

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.imgViewPhoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.width.height.mas_equalTo(22);
        make.top.mas_equalTo(TCNaviH+45);
    }];
    [self.textFieldPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.imgViewPhoneIcon.mas_centerY);
        make.left.mas_equalTo(self.imgViewPhoneIcon.mas_right).offset(20);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
    }];
    [self.viewLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.textFieldPhone.mas_bottom).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(0.5);
    }];
    [self.imgViewVerifyCodeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.viewLine1.mas_bottom).offset(20);
        make.width.height.mas_equalTo(22);
    }];
    [self.textFieldVerifyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.imgViewVerifyCodeIcon.mas_centerY);
        make.left.mas_equalTo(self.imgViewVerifyCodeIcon.mas_right).offset(20);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
    }];
    [self.btnGetCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.textFieldVerifyCode.mas_centerY);
    }];
    [self.viewLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.textFieldVerifyCode.mas_bottom).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(0.5);
    }];
    [self.imgViewPwdIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.viewLine2.mas_bottom).offset(20);
        make.width.height.mas_equalTo(22);
    }];
    [self.textFieldPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.imgViewPwdIcon.mas_centerY);
        make.left.mas_equalTo(self.imgViewPwdIcon.mas_right).offset(20);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
    }];
    [self.btnSwich mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(23);
        make.centerY.mas_equalTo(self.textFieldPwd.mas_centerY);
    }];
    [self.viewLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.textFieldPwd.mas_bottom).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(0.5);
    }];
    [self.btnConfrm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.viewLine3.mas_bottom).offset(30);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(50);
    }];
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

- (void)btnGetCodeClick:(ZXCountDownBtn *)btn
{
    if (![NSString valiMobile:self.textFieldPhone.text]) {
        [MBManager showBriefAlert:@"请填写正确的手机号码"];
        return;
    }
    btn.enabled = NO;
    [btn startCountDown];
    // 获取短信
    [self GetTokenRequest];
}

// 获取token接口
- (void)GetTokenRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"uhome.ios" forKey:@"client_id"];
    [params setObject:@"123456" forKey:@"client_secret"];
    [params setObject:@"client_credentials" forKey:@"grant_type"];
    [params setObject:@"uhome uhome.rke uhome.o2o uhome.park" forKey:@"scope"];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer setTimeoutInterval:10];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html",@"text/plain", nil];
    WEAKSELF
    [[TCHttpTool sharedHttpTool] postWithURL:GetTokenURL params:params withManager:mgr success:^(id  _Nonnull json) {
        NSLog(@"%@", json);
        weakSelf.access_token = [json objectForKey:@"access_token"];
        [weakSelf SendCodeRequestWithToken:weakSelf.access_token];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf addAlertWithTitle:@"提示" text:@"获取token失败" sureStr:@"确定" cancelStr:@""];
    }];
}

// 获取验证码接口
- (void)SendCodeRequestWithToken:(NSString *)token
{
    NSDictionary *params = @{@"provider" : @"Phone", @"value" : self.textFieldPhone.text};
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setTimeoutInterval:10];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
  
    [mgr POST:SendCodeURL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", SendCodeURL);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:@"验证码已发送，请注意查收"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:error.description];
        NSLog(@"%@", error);
    }];
}

// 重置密码接口
- (void)ResetPasswordRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.textFieldPhone.text forKey:@"userName"];
    [params setObject:self.textFieldVerifyCode.text forKey:@"code"];
    [params setObject:self.textFieldPwd.text forKey:@"newPassword"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", self.access_token] forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setTimeoutInterval:10];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    [mgr POST:ResetPasswordURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBManager hideAlert];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 0) {
            [MBManager showBriefAlert:@"重置密码成功"];
            [[TCPersonalInfoModel shareInstance] logout];
        } else {
            NSString *msg = [responseObject objectForKey:@"message"];
            [MBManager showBriefAlert:msg];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:error.description];
        NSLog(@"%@", error);
    }];
}

- (void)textFieldChange:(UITextField *)textField
{
    if (self.textFieldPhone.text.length && self.textFieldVerifyCode.text.length && self.textFieldPwd.text.length) {
        self.btnConfrm.enabled = YES;
        [self.btnConfrm setBackgroundColor:[UIColor colorWithHexString:MainColor]];
    } else {
        self.btnConfrm.enabled = NO;
        [self.btnConfrm setBackgroundColor:[UIColor colorWithHexString:@"#E0E9FF"]];
    }
}

- (void)btnConfirmClick:(UIButton *)btn
{
    if (![NSString valiMobile:self.textFieldPhone.text]) {
        [MBManager showBriefAlert:@"请输入正确的手机号码"];
        return;
    } else if (self.textFieldVerifyCode.text.length <= 0) {
        [MBManager showBriefAlert:@"请输入验证码"];
        return;
    } else if (![NSString valiPassword:self.textFieldPwd.text]) {
        [MBManager showBriefAlert:@"请输入6-16位数字和字母组合的新密码"];
        self.textFieldPwd.text = @"";
        [self.textFieldPwd becomeFirstResponder];
        return;
    }
    // 调用重置密码方法
    [self ResetPasswordRequest];
}

#pragma mark - Get

- (UIImageView *)imgViewPhoneIcon
{
    if (_imgViewPhoneIcon == nil) {
        _imgViewPhoneIcon = [[UIImageView alloc] init];
        _imgViewPhoneIcon.image = [UIImage tc_imgWithName:@"member_phone" bundle:TCMemberBundelName targetClass:[self class]];
    }
    return _imgViewPhoneIcon;
}

- (UITextField *)textFieldPhone
{
    if (_textFieldPhone == nil) {
        _textFieldPhone = [[UITextField alloc] init];
        _textFieldPhone.placeholder = @"请输入您的手机号";
        [_textFieldPhone setFont:[UIFont systemFontOfSize:15]];
        _textFieldPhone.tintColor = [UIColor colorWithHexString:MainColor];
        _textFieldPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_textFieldPhone addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        _textFieldPhone.keyboardType = UIKeyboardTypePhonePad;
    }
    return _textFieldPhone;
}

- (UIImageView *)imgViewVerifyCodeIcon
{
    if (_imgViewVerifyCodeIcon == nil) {
        _imgViewVerifyCodeIcon = [[UIImageView alloc] init];
        _imgViewVerifyCodeIcon.image = [UIImage tc_imgWithName:@"member_verifyCode" bundle:TCMemberBundelName targetClass:[self class]];
    }
    return _imgViewVerifyCodeIcon;
}

- (UITextField *)textFieldVerifyCode
{
    if (_textFieldVerifyCode == nil) {
        _textFieldVerifyCode = [[UITextField alloc] init];
        _textFieldVerifyCode.placeholder = @"请输入您的验证码";
        [_textFieldVerifyCode setFont:[UIFont systemFontOfSize:15]];
        _textFieldVerifyCode.tintColor = [UIColor colorWithHexString:MainColor];
        [_textFieldVerifyCode addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFieldVerifyCode;
}

- (ZXCountDownBtn *)btnGetCode
{
    if (_btnGetCode == nil) {
        _btnGetCode = [[ZXCountDownBtn alloc] init];
        [_btnGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_btnGetCode setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _btnGetCode.layer.cornerRadius = 3;
        _btnGetCode.layer.masksToBounds = YES;
        _btnGetCode.layer.borderColor = [UIColor grayColor].CGColor;
        _btnGetCode.layer.borderWidth = 0.5;
        _btnGetCode.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btnGetCode initOpr];
        [_btnGetCode addTarget:self action:@selector(btnGetCodeClick:) forControlEvents:UIControlEventTouchUpInside];
        WEAKSELF
        [_btnGetCode setCountDown:10 mark:@"btnRegisterGetCode" resTextFormat:^NSString *(long remainSec) {
            if (remainSec == 0) {
                weakSelf.btnGetCode.enabled = YES;
            }
            return [NSString stringWithFormat:@"%ld秒后重发", remainSec];
        }];
    }
    return _btnGetCode;
}

- (UIImageView *)imgViewPwdIcon
{
    if (_imgViewPwdIcon == nil) {
        _imgViewPwdIcon = [[UIImageView alloc] init];
        _imgViewPwdIcon.image = [UIImage tc_imgWithName:@"member_userPwd" bundle:TCMemberBundelName targetClass:[self class]];
    }
    return _imgViewPwdIcon;
}

- (UITextField *)textFieldPwd
{
    if (_textFieldPwd == nil) {
        _textFieldPwd = [[UITextField alloc] init];
        _textFieldPwd.placeholder = @"请输入您的新密码";
        [_textFieldPwd setFont:[UIFont systemFontOfSize:15]];
        _textFieldPwd.tintColor = [UIColor colorWithHexString:MainColor];
        _textFieldPwd.secureTextEntry = YES;
        [_textFieldPwd addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFieldPwd;
}

- (UIButton *)btnSwich
{
    if (_btnSwich == nil) {
        _btnSwich = [[UIButton alloc] init];
        [_btnSwich setBackgroundImage:[UIImage tc_imgWithName:@"member_closeEye" bundle:TCMemberBundelName targetClass:[self class]] forState:UIControlStateNormal];
        [_btnSwich setBackgroundImage:[UIImage tc_imgWithName:@"member_openEye" bundle:TCMemberBundelName targetClass:[self class]] forState:UIControlStateSelected];
        [_btnSwich addTarget:self action:@selector(btnSwitchStatusClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSwich;
}

- (UIButton *)btnConfrm
{
    if (_btnConfrm == nil) {
        _btnConfrm = [[UIButton alloc] init];
        [_btnConfrm setTitle:@"确 定" forState:UIControlStateNormal];
        [_btnConfrm setBackgroundColor:[UIColor colorWithHexString:MainColor]];
        [_btnConfrm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnConfrm.layer.cornerRadius = 5;
        _btnConfrm.layer.masksToBounds = YES;
        [_btnConfrm setBackgroundColor:[UIColor colorWithHexString:@"#E0E9FF"]];
        _btnConfrm.enabled = NO;
        [_btnConfrm addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnConfrm;
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

- (UIView *)viewLine3
{
    if (_viewLine3 == nil) {
        _viewLine3 = [[UIView alloc] init];
        _viewLine3.backgroundColor = [UIColor colorWithHexString:LineColor];
    }
    return _viewLine3;
}

@end
