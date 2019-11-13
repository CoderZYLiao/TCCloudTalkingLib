//
//  ZYBaseViewController.m
//  TCCloudParking
//
//  Created by LiaoZhiyao on 2019/8/8.
//  Copyright © 2019 LiaoZhiyao. All rights reserved.
//

#import "ZYBaseViewController.h"

@interface ZYBaseViewController ()

@end

@implementation ZYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightBarBtn];
}

#pragma mark - Public

- (void)btnRightClick:(UIButton *)btn
{
    if (self.btnClickAction) {
        self.btnClickAction(btn.tag);
    }
}

#pragma mark - Private

- (void)setRightBarBtn
{
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 44)];
    _btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 44)];
    [rightButtonView addSubview:_btnRight];
    [_btnRight setImage:[UIImage imageNamed:@"notice_icon"] forState:UIControlStateNormal];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];    
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    _btnRight.tag = 2;
    [_btnRight addTarget:self action:@selector(btnRightClick:) forControlEvents:UIControlEventTouchUpInside];
}

@end
