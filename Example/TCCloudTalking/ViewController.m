//
//  ViewController.m
//  Test
//
//  Created by LiaoZhiYao on 2021/4/16.
//  Copyright © 2021 TC. All rights reserved.
//

#import "ViewController.h"
#import <Header.h>

@interface ViewController ()
@property (nonatomic, strong) UIButton *testBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CloudTalkingManager *manager = [[CloudTalkingManager alloc] init];
    // 初始化云之讯
    [manager initUCSCloudTalkingWithToken:@"eyJBbGciOiJIUzI1NiIsIkFjY2lkIjoiY2I3MzhjZmNkNmFlYTkxMDZiZTk5OTc2NzZlNzJhMDIiLCJBcHBpZCI6ImFjNTdhMDc3ZGIwYjRjY2JhNzEwNTU5Yzk4NzlkYmQ1IiwiVXNlcmlkIjoidjVob3VzZTE2NjI2MjA2ODg0In0=.NNhJFD8F6PwBapg0JIbc0dYaw/Q2LMnbmDEro7d6hgs="];
    // 初始化菊风
    [manager initJuphoneCloudTalkingWithServerAddress:@"http:cn.router.justalkcloud.com:8080" withAppKey:@"cad1a228ea4733f68b1a5097" withAccount:@"v5house17817565746"];
    
    [self.view addSubview:self.testBtn];
}

#pragma mark - Private

- (void)Test
{
    CloudTalkingManager *manager = [[CloudTalkingManager alloc] init];
    TCDoorMachineModel *machineModel = [[TCDoorMachineModel alloc] init];
    machineModel.name = @"test";
    machineModel.intercomUserId = @"V5210408ae0db9199ed2efb1";
    [manager makingCallViewVideoWithDoorMachineModel:machineModel withCloudTalkingType:CloudTalkingTypeJuphone];
}

#pragma mark - Get

- (UIButton *)testBtn
{
    if (_testBtn == nil) {
        _testBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
        [_testBtn addTarget:self action:@selector(Test) forControlEvents:UIControlEventTouchUpInside];
        _testBtn.backgroundColor = [UIColor redColor];
    }
    return _testBtn;
}

@end
