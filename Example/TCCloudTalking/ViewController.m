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
    [manager initCloudTalkingWithAccount:@"eyJBbGciOiJIUzI1NiIsIkFjY2lkIjoiY2I3MzhjZmNkNmFlYTkxMDZiZTk5OTc2NzZlNzJhMDIiLCJBcHBpZCI6ImFjNTdhMDc3ZGIwYjRjY2JhNzEwNTU5Yzk4NzlkYmQ1IiwiVXNlcmlkIjoidjVob3VzZTE2NjI2MjA2ODg0In0=.NNhJFD8F6PwBapg0JIbc0dYaw/Q2LMnbmDEro7d6hgs=" withType:CloudTalkingTypeUCS];
    
    [self.view addSubview:self.testBtn];
}

#pragma mark - Private

// 菊风初始化
- (void)initJuphoon
{
    [JCManager.shared initialize];  // 初始化菊风
    // 菊风消息监测
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSuccess:) name:kClientOnLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginFail:) name:kClientOnLoginFailNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clientStateChange:) name:kClientStateChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kickOff) name:kClientOnLogoutNotification object:nil];
}

- (void)Test
{
    [self initJuphoon];
    CloudTalkingManager *manager = [[CloudTalkingManager alloc] init];
    TCDoorMachineModel *machineModel = [[TCDoorMachineModel alloc] init];
    machineModel.name = @"test";
    machineModel.intercomUserId = @"V5210408ae0db9199ed2efb1";
    [manager makingCallViewWithDoorMachineModel:machineModel withCallType:UCSCallType_VideoPhone];
}

#pragma mark 菊风消息回调

- (void)onLoginSuccess:(NSNotification *)info
{
    NSLog(@"菊风服务器登录回调成功");
}

- (void)onLoginFail:(NSNotification *)info
{
    NSLog(@"菊风服务器登录回调失败---%@",info);
}

- (void)clientStateChange:(NSNotification*)info
{
    JCClientState state = JCManager.shared.client.state;
    if (state == JCClientStateIdle) {
        NSLog(@"登录");
    } else if (state == JCClientStateLogined) {
        NSLog(@"已登录");
    } else if (state == JCClientStateLogining) {
        NSLog(@"登录中");
    } else if (state == JCClientStateLogouting) {
        NSLog(@"登出中");
    }
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
