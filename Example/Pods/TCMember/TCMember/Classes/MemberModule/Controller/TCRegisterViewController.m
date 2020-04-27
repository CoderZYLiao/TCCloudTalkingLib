//
//  TCRegisterViewController.m
//  UHomeMember
//
//  Created by Huang ZhiBing on 2019/10/16.
//  Copyright © 2019 TC. All rights reserved.
//

#import "TCRegisterViewController.h"
#import <Masonry/Masonry.h>
#import <TCPublicKit/TCPublicKit.h>
#import <YYKit/YYKit.h>
#import <AFNetworking/AFNetworking.h>
#import "MemberBaseHeader.h"

@interface TCRegisterViewController ()
@property (nonatomic, strong) UIImageView *imgViewPhoneIcon;
@property (nonatomic, strong) UITextField *textFieldPhone;
@property (nonatomic, strong) UIImageView *imgViewPwdIcon;
@property (nonatomic, strong) UITextField *textFieldPwd;
@property (nonatomic, strong) UIButton *btnSwich;
@property (nonatomic, strong) UIImageView *imgViewPwdIcon2;
@property (nonatomic, strong) UITextField *textFieldPwd2;
@property (nonatomic, strong) UIButton *btnSwich2;
@property (nonatomic, strong) UIButton *btnConfrm;
@property (nonatomic, strong) UIView *viewLine1;
@property (nonatomic, strong) UIView *viewLine2;
@property (nonatomic, strong) UIView *viewLine3;
@property (nonatomic, strong) YYLabel *lblAgree;
@property (nonatomic, strong) YYLabel *lblGotoLogin;
@end

@implementation TCRegisterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"新用户注册" withBottomLineHidden:YES];
    [self.view addSubview:self.imgViewPhoneIcon];
    [self.view addSubview:self.textFieldPhone];
    [self.view addSubview:self.viewLine1];
    [self.view addSubview:self.imgViewPwdIcon];
    [self.view addSubview:self.textFieldPwd];
    [self.view addSubview:self.viewLine2];
    [self.view addSubview:self.imgViewPwdIcon2];
    [self.view addSubview:self.textFieldPwd2];
    [self.view addSubview:self.viewLine3];
    [self.view addSubview:self.lblAgree];
    [self.view addSubview:self.btnConfrm];
    [self.view addSubview:self.lblGotoLogin];
}

#pragma mark - Private

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.imgViewPhoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36);
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
    [self.imgViewPwdIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36);
        make.top.mas_equalTo(self.viewLine1.mas_bottom).offset(20);
        make.width.height.mas_equalTo(22);
    }];
    [self.textFieldPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.imgViewPwdIcon.mas_centerY);
        make.left.mas_equalTo(self.imgViewPwdIcon.mas_right).offset(20);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
    }];
    [self.viewLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.textFieldPwd.mas_bottom).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(0.5);
    }];
    [self.imgViewPwdIcon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36);
        make.top.mas_equalTo(self.viewLine2.mas_bottom).offset(20);
        make.width.height.mas_equalTo(22);
    }];
    [self.textFieldPwd2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.imgViewPwdIcon2.mas_centerY);
        make.left.mas_equalTo(self.imgViewPwdIcon2.mas_right).offset(20);
        make.height.mas_equalTo(35);
       make.right.mas_equalTo(self.view.mas_right).offset(-30);
    }];
    [self.viewLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.textFieldPwd2.mas_bottom).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(0.5);
    }];
    [self.lblAgree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.viewLine3.mas_bottom).offset(18);
    }];
    [self.btnConfrm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.lblAgree.mas_bottom).offset(30);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(50);
    }];
    [self.lblGotoLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.btnConfrm.mas_bottom).offset(28);
    }];
}

- (void)btnConfrmClick:(UIButton *)btn
{
    if (![NSString valiMobile:self.textFieldPhone.text]) {
        [MBManager showBriefAlert:@"请输入正确的手机号码"];
        return;
    } else if (![NSString valiPassword:self.textFieldPwd.text]) {
        [MBManager showBriefAlert:@"请输入6-16位数字和字母组合的注册密码"];
        return;
    } else if (self.textFieldPwd2.text.length <= 0) {
        [MBManager showBriefAlert:@"请再次输入密码"];
        return;
    } else if (![self.textFieldPwd.text isEqualToString:self.textFieldPwd2.text]) {
        [MBManager showBriefAlert:@"两次输入的密码不一致"];
        self.btnConfrm.enabled = NO;
        [self.btnConfrm setBackgroundColor:[UIColor colorWithHexString:@"#E0E9FF"]];
        self.textFieldPwd.text = @"";
        self.textFieldPwd2.text = @"";
        [self.textFieldPwd becomeFirstResponder];
        return;
    }
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
        [[TCHttpTool sharedHttpTool] updateMgrRequestAccessToken:[json objectForKey:@"access_token"]];
        [weakSelf RegisterRequest];
    } failure:^(NSError * _Nonnull error) {
         [MBManager showBriefAlert:error.localizedDescription];
    }];
}

// 注册接口
- (void)RegisterRequest
{
    NSDictionary *params = @{@"phoneNumber" : self.textFieldPhone.text, @"userName" : self.textFieldPhone.text , @"password" : self.textFieldPwd2.text};
    WEAKSELF
    [[TCHttpTool sharedHttpTool] postWithURL:RegisterURL params:params success:^(id json) {
        [MBManager hideAlert];
        NSInteger code = [[json objectForKey:@"code"] integerValue];
        if (code == 0) {
            [weakSelf addAlertWithTitle:@"提示" text:@"注册成功" sureStr:@"确定" cancelStr:@""];
        } else {
            NSString *msg = [json objectForKey:@"message"];
            [weakSelf addAlertWithTitle:@"提示" text:msg sureStr:@"确定" cancelStr:@""];
        }
    } failure:^(NSError *error) {
        [MBManager showBriefAlert:@"服务器异常"];
        NSLog(@"%@", error);
    }];
}

- (void)alertClickSureAction:(UIAlertAction *)sureAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (void)btnSwitchStatusClick2:(UIButton *)btn
{
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {
        self.textFieldPwd2.secureTextEntry = NO;
    } else {
        self.textFieldPwd2.secureTextEntry = YES;
    }
}

- (void)textFieldChange:(UITextField *)textField
{
    if (self.textFieldPhone.text.length && self.textFieldPwd.text.length && self.textFieldPwd2.text.length) {
        self.btnConfrm.enabled = YES;
        [self.btnConfrm setBackgroundColor:[UIColor colorWithHexString:MainColor]];
    } else {
        self.btnConfrm.enabled = NO;
        [self.btnConfrm setBackgroundColor:[UIColor colorWithHexString:@"#E0E9FF"]];
    }
}

#pragma mark - Get

- (UIImageView *)imgViewPhoneIcon
{
    if (_imgViewPhoneIcon == nil) {
        _imgViewPhoneIcon = [[UIImageView alloc] init];
        _imgViewPhoneIcon.image = [UIImage tc_imgWithName:@"member_userName" bundle:TCMemberBundelName targetClass:[self class]];
    }
    return _imgViewPhoneIcon;
}

- (UITextField *)textFieldPhone
{
    if (_textFieldPhone == nil) {
        _textFieldPhone = [[UITextField alloc] init];
        _textFieldPhone.placeholder = @"请输入您的手机号";
        [_textFieldPhone setFont:[UIFont systemFontOfSize:14]];
        _textFieldPhone.tintColor = [UIColor colorWithHexString:MainColor];
        _textFieldPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_textFieldPhone addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        _textFieldPhone.keyboardType = UIKeyboardTypePhonePad;
    }
    return _textFieldPhone;
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
        _textFieldPwd.placeholder = @"请输入6-16位数字字母组合的密码";
        [_textFieldPwd setFont:[UIFont systemFontOfSize:14]];
        _textFieldPwd.tintColor = [UIColor colorWithHexString:MainColor];
        _textFieldPwd.secureTextEntry = YES;
        _textFieldPwd.rightView = self.btnSwich;
        _textFieldPwd.rightViewMode = UITextFieldViewModeAlways;
        [_textFieldPwd addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFieldPwd;
}

- (UIButton *)btnSwich
{
    if (_btnSwich == nil) {
        _btnSwich = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 23)];
        [_btnSwich setBackgroundImage:[UIImage tc_imgWithName:@"member_closeEye" bundle:TCMemberBundelName targetClass:[self class]] forState:UIControlStateNormal];
        [_btnSwich setBackgroundImage:[UIImage tc_imgWithName:@"member_openEye" bundle:TCMemberBundelName targetClass:[self class]] forState:UIControlStateSelected];
        [_btnSwich addTarget:self action:@selector(btnSwitchStatusClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSwich;
}

- (UIImageView *)imgViewPwdIcon2
{
    if (_imgViewPwdIcon2 == nil) {
        _imgViewPwdIcon2 = [[UIImageView alloc] init];
       _imgViewPwdIcon2.image = [UIImage tc_imgWithName:@"member_userPwd" bundle:TCMemberBundelName targetClass:[self class]];
    }
    return _imgViewPwdIcon2;
}

- (UITextField *)textFieldPwd2
{
    if (_textFieldPwd2 == nil) {
        _textFieldPwd2 = [[UITextField alloc] init];
        _textFieldPwd2.placeholder = @"请再次输入密码";
        [_textFieldPwd2 setFont:[UIFont systemFontOfSize:14]];
        _textFieldPwd2.tintColor = [UIColor colorWithHexString:MainColor];
        _textFieldPwd2.secureTextEntry = YES;
        _textFieldPwd2.rightView = self.btnSwich2;
        _textFieldPwd2.rightViewMode = UITextFieldViewModeAlways;
        [_textFieldPwd2 addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFieldPwd2;
}

- (UIButton *)btnSwich2
{
    if (_btnSwich2 == nil) {
        _btnSwich2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 23)];
        [_btnSwich2 setBackgroundImage:[UIImage tc_imgWithName:@"member_closeEye" bundle:TCMemberBundelName targetClass:[self class]] forState:UIControlStateNormal];
        [_btnSwich2 setBackgroundImage:[UIImage tc_imgWithName:@"member_openEye" bundle:TCMemberBundelName targetClass:[self class]] forState:UIControlStateSelected];
        [_btnSwich2 addTarget:self action:@selector(btnSwitchStatusClick2:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSwich2;
}

- (YYLabel *)lblAgree
{
    if (_lblAgree == nil) {
        _lblAgree = [[YYLabel alloc] init];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"注册即代表您已经同意《用户协议》"];
        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, text.length)];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#C0C4CC"] range:NSMakeRange(0, text.length)];
    
        [text setTextHighlightRange:NSMakeRange(10, 6)
                               color:[UIColor colorWithHexString:MainColor]
                     backgroundColor:[UIColor whiteColor]
                           tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                               [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToUserAgreementNotification" object:nil];
                           }];
        _lblAgree.attributedText = text;
    }
    return _lblAgree;
}

- (YYLabel *)lblGotoLogin
{
    if (_lblGotoLogin == nil) {
        _lblGotoLogin = [[YYLabel alloc] init];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"我已有账号，马上登录"];
        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, text.length)];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#C0C4CC"] range:NSMakeRange(0, text.length)];
        
        WEAKSELF
        [text setTextHighlightRange:NSMakeRange(6, 4)
                              color:[UIColor colorWithHexString:MainColor]
                    backgroundColor:[UIColor whiteColor]
                          tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                              [weakSelf.navigationController popViewControllerAnimated:YES];
                          }];
        _lblGotoLogin.attributedText = text;
    }
    return _lblGotoLogin;
}

- (UIButton *)btnConfrm
{
    if (_btnConfrm == nil) {
        _btnConfrm = [[UIButton alloc] init];
        [_btnConfrm setTitle:@"注 册" forState:UIControlStateNormal];
        [_btnConfrm setBackgroundColor:[UIColor colorWithHexString:@"#E0E9FF"]];
        _btnConfrm.enabled = NO;
        [_btnConfrm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnConfrm.layer.cornerRadius = 5;
        _btnConfrm.layer.masksToBounds = YES;
        [_btnConfrm addTarget:self action:@selector(btnConfrmClick:) forControlEvents:UIControlEventTouchUpInside];
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
