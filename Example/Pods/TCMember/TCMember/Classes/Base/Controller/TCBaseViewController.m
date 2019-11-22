//
//  TCBaseViewController.m
//  UHomeMember
//
//  Created by Huang ZhiBing on 2019/10/16.
//  Copyright © 2019 TC. All rights reserved.
//

#import "TCBaseViewController.h"
#import "TCPublicKit.h"
#import "MemberBaseHeader.h"

@interface TCBaseViewController ()
@property(nonatomic, strong) UIButton *btnLeft;
@property(nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIButton *btnRight;
@property(nonatomic, strong) UIView *viewBottomLine;
@end

@implementation TCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.btnLeft];
    [self.view addSubview:self.lblTitle];
    [self.view addSubview:self.btnRight];
    [self.view addSubview:self.viewBottomLine];
}

#pragma mark - Public

- (void)setTitle:(NSString *)title withBottomLineHidden:(BOOL)isHidden
{
    self.viewBottomLine.hidden = isHidden;
    self.lblTitle.text = title;
}

#pragma mark - Private

- (void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AlertViewController
/**添加alertViewController*/
-(void)addAlertWithTitle:(NSString *)title text:(NSString *)text sureStr:(NSString *)sureStr cancelStr:(NSString *)cancelStr{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    if (sureStr) {
        UIAlertAction * sure = [UIAlertAction actionWithTitle:sureStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self alertClickSureAction:action];
        }];
        [alert addAction:sure];
    }
    if (cancelStr.length > 0) {
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self alertClickCancelAction:action];
        }];
        [alert addAction:cancel];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**alertViewController点击确定*/
-(void)alertClickSureAction:(UIAlertAction *)sureAction{
    
}
/**alertViewController点击取消*/
-(void)alertClickCancelAction:(UIAlertAction *)sureAction{
    
}


#pragma mark - Get

- (UIButton *)btnLeft
{
    if (_btnLeft == nil) {
        CGFloat Y = TCStatusH + 7;
        CGFloat WH = 30;
        CGFloat X = 10;
        _btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(X, Y, WH, WH)];
        [_btnLeft setImage:[UIImage tc_imgWithName:@"tc_back" bundle:TCMemberBundelName targetClass:[self class]] forState:UIControlStateNormal];
        [_btnLeft addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLeft;
}

- (UILabel *)lblTitle
{
    if (_lblTitle == nil) {
        CGFloat X = CGRectGetMaxX(self.btnLeft.frame);
        CGFloat W = MainScreenCGRect.size.width - X*2;
        CGFloat Y = TCStatusH + 7;
        CGFloat H = 30;
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        _lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        _lblTitle.text = @"标题";
        _lblTitle.font = [UIFont boldSystemFontOfSize:20];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _lblTitle;
}

- (UIView *)viewBottomLine
{
    if (_viewBottomLine == nil) {
        _viewBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, TCNaviH-1, MainScreenCGRect.size.width, 1)];
        _viewBottomLine.backgroundColor = [UIColor colorWithHexString:LineColor];
    }
    return _viewBottomLine;
}

- (UIButton *)btnRight
{
    if (_btnRight == nil) {
        CGFloat Y = TCStatusH + 7;
        CGFloat WH = 30;
        CGFloat X = MainScreenCGRect.size.width - WH - 10;
        _btnRight = [[UIButton alloc] initWithFrame:CGRectMake(X, Y, WH, WH)];
        [_btnRight setImage:[UIImage tc_imgWithName:@"home_back" bundle:TCMemberBundelName targetClass:[self class]] forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

@end
