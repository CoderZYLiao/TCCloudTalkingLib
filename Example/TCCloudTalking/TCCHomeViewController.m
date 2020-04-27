//
//  TCCHomeViewController.m
//  TCC_CloudTalk_demo
//
//  Created by Huang ZhiBin on 2017/8/1.
//  Copyright © 2017年 iCloud Home. All rights reserved.
//

#import "TCCHomeViewController.h"
#import "TCCLoginViewController.h"
#import "TCAppDelegate.h"
#import "Header.h"
#import "TCSmartDoorViewController.h"
#import "TCVoiceView.h"
#import "TCVoiceUnlockViewController.h"
#import "TCOpenDoorView.h"


@interface TCCHomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *LongTouchBtn;

@end

@implementation TCCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
    self.UserIDTextView.text = [TCCUserDefaulfManager GetLocalDataString:UserTccUserID];
    
    self.UserIDTextView.layer.borderColor = UIColor.orangeColor.CGColor;
    self.UserIDTextView.layer.borderWidth = 2;
    
    //button长按事件
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress.minimumPressDuration = 0.5; //定义按的时间
    [self.LongTouchBtn addGestureRecognizer:longPress];
}

- (void)btnLong:(UILongPressGestureRecognizer*)sender
{
    //直接return掉，不在开始的状态里面添加任何操作，则长按手势就会被少调用一次了
    if (sender.state == UIGestureRecognizerStateBegan)
    {
//        [TCVoiceView  show];
        TCVoiceUnlockViewController * vc = [[TCVoiceUnlockViewController alloc]init];;
        [self presentViewController:vc animated:YES completion:nil];
    }
    

}

- (IBAction)openDoorBtn:(UIButton *)sender {
    
    [TCOpenDoorView show:OpenDoor_OpenDoor];
}

- (IBAction)VideoCallBtnClick {
    
    [TCOpenDoorView show:OpenDoor_LookDoor];
    
}

- (IBAction)VoipCallBtnClick {
    

}

- (IBAction)PhoneCallBtnClick {
    
    TCSmartDoorViewController *SmartDoorVc = [[TCSmartDoorViewController alloc] init];
    NSLog(@"%@", self.navigationController);
    [self.navigationController pushViewController:SmartDoorVc animated:YES];
}


- (IBAction)TransParentBtnClick {
    
    
}

- (IBAction)loginOutBtnClick {
    
    
}


- (IBAction)SettingBtnClick:(UIButton *)sender {
    

}


@end
