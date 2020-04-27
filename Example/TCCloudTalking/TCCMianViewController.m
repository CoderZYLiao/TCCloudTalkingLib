//
//  TCCMianViewController.m
//  TCCloudTalking_Example
//
//  Created by Huang ZhiBin on 2020/4/23.
//  Copyright © 2020 TYL. All rights reserved.
//

#import "TCCMianViewController.h"
#import "TCTextViewController.h"
#import "TCCHomeViewController.h"
#import "Header.h"
#import "MemberBaseHeader.h"
#import "ZYNavigationController.h"
#import "TCLoginViewController.h"
#import "TCPersonalInfoModel.h"
#import "TCAppDelegate.h"
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
@interface TCCMianViewController ()

@end

@implementation TCCMianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"测试主页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdBtn.frame = CGRectMake((kMainScreenWidth-200)/2, TCNaviH+20, 200, 60);
    thirdBtn.layer.cornerRadius = 20;
    thirdBtn.layer.masksToBounds = YES;
    [thirdBtn addTarget:self action:@selector(DoorMachineSelect) forControlEvents:UIControlEventTouchUpInside];
    
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 200, 60);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)[[UIColor blueColor] CGColor],(id)[RGBCOLOR(100, 100, 100) CGColor]]];//渐变数组
    [thirdBtn.layer addSublayer:gradientLayer];
    
    [thirdBtn setTitle:@"门口机测试" forState:UIControlStateNormal];
    [self.view addSubview:thirdBtn];
    
    
    UIButton *SecondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    SecondBtn.frame = CGRectMake((kMainScreenWidth-200)/2, TCNaviH+100, 200, 60);
    SecondBtn.layer.cornerRadius = 20;
    SecondBtn.layer.masksToBounds = YES;
    [SecondBtn addTarget:self action:@selector(CatEyeSelect) forControlEvents:UIControlEventTouchUpInside];
    
    CAGradientLayer *GradientLayer =  [CAGradientLayer layer];
    GradientLayer.frame = CGRectMake(0, 0, 200, 60);
    GradientLayer.startPoint = CGPointMake(0, 0);
    GradientLayer.endPoint = CGPointMake(1, 0);
    GradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
    [GradientLayer setColors:@[(id)[[UIColor blueColor] CGColor],(id)[RGBCOLOR(100, 100, 100) CGColor]]];//渐变数组
    [SecondBtn.layer addSublayer:GradientLayer];
    
    [SecondBtn setTitle:@"猫眼测试" forState:UIControlStateNormal];
    [self.view addSubview:SecondBtn];
    
    UIButton *ThreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ThreeBtn.frame = CGRectMake((kMainScreenWidth-200)/2, TCNaviH+180, 200, 60);
    ThreeBtn.layer.cornerRadius = 20;
    ThreeBtn.layer.masksToBounds = YES;
    [ThreeBtn addTarget:self action:@selector(LoginOut) forControlEvents:UIControlEventTouchUpInside];
    
    CAGradientLayer *Gradientlayer =  [CAGradientLayer layer];
    Gradientlayer.frame = CGRectMake(0, 0, 200, 60);
    Gradientlayer.startPoint = CGPointMake(0, 0);
    Gradientlayer.endPoint = CGPointMake(1, 0);
    Gradientlayer.locations = @[@(0.5),@(1.0)];//渐变点
    [Gradientlayer setColors:@[(id)[[UIColor blueColor] CGColor],(id)[RGBCOLOR(100, 100, 100) CGColor]]];//渐变数组
    [ThreeBtn.layer addSublayer:Gradientlayer];
    
    [ThreeBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.view addSubview:ThreeBtn];
    
}


- (void)DoorMachineSelect
{
    TCCHomeViewController *TextVc = [[TCCHomeViewController alloc] init];
    [self.navigationController pushViewController:TextVc animated:YES];
}


- (void)CatEyeSelect
{
    TCTextViewController *TextVc = [[TCTextViewController alloc] init];
    [self.navigationController pushViewController:TextVc animated:YES];
}

- (void)LoginOut
{
    [[TCPersonalInfoModel shareInstance] logout];
    
    //清空偏好设置存储的内容
    BOOL flag = [[NSUserDefaults standardUserDefaults] objectForKey:TCLoginStyleKey];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (flag) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TCLoginStyleKey];
    }
    
    //关闭15秒连接定时检测
    [[UCSFuncEngine getInstance] stopTimerCheckCon];
    //断开tcp连接,并关闭viop推送
    [[UCSTcpClient sharedTcpClientManager] login_uninitWithFlag:YES];
    
    
    //移除沙盒文件
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:DocumentsPath];
    for (NSString *fileName in enumerator) {
        [[NSFileManager defaultManager] removeItemAtPath:[DocumentsPath stringByAppendingPathComponent:fileName] error:nil];
    }
    
    TCLoginViewController *loginVC = [[TCLoginViewController alloc] init];
    ZYNavigationController *navVc = [[ZYNavigationController alloc] initWithRootViewController:loginVC];
    TCAppDelegate *delegate = (TCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegate.window.rootViewController = navVc;
}
@end
