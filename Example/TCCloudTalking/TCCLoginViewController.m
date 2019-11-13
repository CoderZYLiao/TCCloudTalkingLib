//
//  TCCLoginViewController.m
//  TCC_CloudTalk_demo
//
//  Created by Huang ZhiBin on 2017/8/1.
//  Copyright © 2017年 iCloud Home. All rights reserved.
//

#import "TCCLoginViewController.h"
#import "TCCHomeViewController.h"
#import "TCNavigationController.h"
#import "TCAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Header.h"

static NSTimer *loginTimer;
@interface TCCLoginViewController ()
{
    int timeCounter;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSString *UserCallid;
@property (strong, nonatomic) NSString *UserBeCallid;
@end

@implementation TCCLoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.layer.borderColor = UIColor.orangeColor.CGColor;
    self.textView.layer.borderWidth = 2;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)loginBtnClick {
    
    // 无网则返回
    if ([[UCSTcpClient sharedTcpClientManager] getCurrentNetWorkStatus] == UCSNotReachable) {
        
        return;
    }
    
    if (self.textView.text.length == 0) {
        
    }else
    {
        

        
        [TCCUserDefaulfManager SetLocalDataString:self.textView.text key:UserTccToken];

        [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"Login开始登录"]];
        //连接云平台
        [[UCSTcpClient sharedTcpClientManager] login_connect:self.textView.text  success:^(NSString *userId) {
            [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"Login登录成功"]];
            NSString * log2 = [NSString stringWithFormat:@"%@:%@:TCP链接成功\n",self.textView.text,[self getNowTime]];
            [log2 saveTolog];
            
            [self connectionSuccessful];
            [[UCSFuncEngine getInstance] creatTimerCheckCon];//开启15秒连接定时检测
        } failure:^(UCSError *error) {
            
            NSString * log2 = [NSString stringWithFormat:@"%@:%@:TCP链接失败 error：%zd\n",self.textView.text,[self getNowTime],error.code];
            [log2 saveTolog];
            [self connectionFailed:error.code];
        }];
    }
    
}

-(void)loginTimerAction
{
    NSLog(@"------timeCounter--:%d",timeCounter);
    if (timeCounter<=0) {
        [loginTimer invalidate];
        loginTimer = nil;
        
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
        
        
        
        
    }
    
    timeCounter--;
}

- (IBAction)loginBtnClickWithTest1 {
    
    // 无网则返回
    if ([[UCSTcpClient sharedTcpClientManager] getCurrentNetWorkStatus] == UCSNotReachable) {
        
        return;
    }
    else{
        


        NSString *userToekn =@"eyJBbGciOiJIUzI1NiIsIkFjY2lkIjoiY2I3MzhjZmNkNmFlYTkxMDZiZTk5OTc2NzZlNzJhMDIiLCJBcHBpZCI6ImFjNTdhMDc3ZGIwYjRjY2JhNzEwNTU5Yzk4NzlkYmQ1IiwiVXNlcmlkIjoiNDAxMzA0NTAzZWI1MTE4In0=.0RHcTByw4AMAkGH//oGJc57c223tK+O/kc6Ay7n7LRk=";
        self.UserCallid = @"fe3025aaf8738823";
       
        
        [TCCUserDefaulfManager SetLocalDataString:userToekn key:UserTccToken];
        [TCCUserDefaulfManager SetLocalDataString:self.UserCallid key:UserTccUserID];
        //连接云平台
        [[UCSTcpClient sharedTcpClientManager] login_connect:userToekn  success:^(NSString *userId) {
            

            NSString * log2 = [NSString stringWithFormat:@"%@:%@:TCP链接成功\n",self.textView.text,[self getNowTime]];
            [log2 saveTolog];
            
            [self connectionSuccessful];
        } failure:^(UCSError *error) {
            
            NSString * log2 = [NSString stringWithFormat:@"%@:%@:TCP链接失败 error：%zd\n",self.textView.text,[self getNowTime],error.code];
            [log2 saveTolog];
            [self connectionFailed:error.code];
        }];
    }

}


- (IBAction)loginBtnClickWithTest2 {
    // 无网则返回
    if ([[UCSTcpClient sharedTcpClientManager] getCurrentNetWorkStatus] == UCSNotReachable) {
        
        return;
    }
    else{
        
        
        //userToekn 申请的测试账号的loginToken
//        NSString *userToekn =@"eyJBbGciOiJIUzI1NiIsIkFjY2lkIjoiY2I3MzhjZmNkNmFlYTkxMDZiZTk5OTc2NzZlNzJhMDIiLCJBcHBpZCI6ImFjNTdhMDc3ZGIwYjRjY2JhNzEwNTU5Yzk4NzlkYmQ1IiwiVXNlcmlkIjoiZmUzMDI1YWFmODczODgyMyJ9.YqhSu0pc/eF2O2XmctfZFPCxpf3eKYzkntK0CTDdS5M=";
//        //UserCallid 对方的useid
//        self.UserCallid = @"401304503eb5118";
        NSString *userToekn =@"eyJBbGciOiJIUzI1NiIsIkFjY2lkIjoiY2I3MzhjZmNkNmFlYTkxMDZiZTk5OTc2NzZlNzJhMDIiLCJBcHBpZCI6ImFjNTdhMDc3ZGIwYjRjY2JhNzEwNTU5Yzk4NzlkYmQ1IiwiVXNlcmlkIjoiNDAxMzA0NTAzZWI1MTE4In0=.0RHcTByw4AMAkGH//oGJc57c223tK+O/kc6Ay7n7LRk=";
        self.UserCallid = @"fe3025aaf8738823";
       
        [TCCUserDefaulfManager SetLocalDataString:userToekn key:UserTccToken];
        [TCCUserDefaulfManager SetLocalDataString:self.UserCallid key:UserTccUserID];
        
        //连接云平台
        [[UCSTcpClient sharedTcpClientManager] login_connect:userToekn  success:^(NSString *userId) {
            
            NSString * log2 = [NSString stringWithFormat:@"%@:%@:TCP链接成功\n",self.textView.text,[self getNowTime]];
            [log2 saveTolog];
            
            [self connectionSuccessful];
        } failure:^(UCSError *error) {
            
            NSString * log2 = [NSString stringWithFormat:@"%@:%@:TCP链接失败 error：%zd\n",self.textView.text,[self getNowTime],error.code];
            [log2 saveTolog];
            [self connectionFailed:error.code];
        }];
    }
}

-(void)connectionSuccessful
{

    dispatch_async(dispatch_get_main_queue(), ^{
        
      
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UCLoginStateChangedNotication object:UCLoginStateLoginSuccessNotification];
            
            TCCHomeViewController *homeVC = [[TCCHomeViewController alloc] init];
            homeVC.callUserid = self.UserCallid;
            TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:homeVC];
            TCAppDelegate *delegate = (TCAppDelegate *)[[UIApplication sharedApplication]delegate];
            delegate.window.rootViewController = nav;
        });
        
    });
    
}

-(void)connectionFailed:(UCSErrorCode) errorCode
{

    dispatch_async(dispatch_get_main_queue(), ^{
       
        
    });
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //取消定时器
    [loginTimer invalidate];
    loginTimer = nil;
}

#pragma mark - 登录注册日志
- (NSString *)getNowTime
{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}
@end
