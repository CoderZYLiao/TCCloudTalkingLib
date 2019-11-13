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

@interface TCCHomeViewController ()


@end

@implementation TCCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
    self.UserIDTextView.text = [TCCUserDefaulfManager GetLocalDataString:UserTccUserID];
    
    self.UserIDTextView.layer.borderColor = UIColor.orangeColor.CGColor;
    self.UserIDTextView.layer.borderWidth = 2;
}


- (IBAction)VideoCallBtnClick {
    
   [[UCSVOIPViewEngine getInstance] makingCallViewCallNumber:self.UserIDTextView.text callType:UCSCallType_VideoPhone callName:self.UserIDTextView.text];
    
}

- (IBAction)VoipCallBtnClick {
    
    [[UCSVOIPViewEngine getInstance] makingCallViewCallNumber:self.UserIDTextView.text callType:UCSCallType_VOIP callName:self.UserIDTextView.text];
}

- (IBAction)PhoneCallBtnClick {
    
    TCSmartDoorViewController *SmartDoorVc = [[TCSmartDoorViewController alloc] init];
    NSLog(@"%@", self.navigationController);
    [self.navigationController pushViewController:SmartDoorVc animated:YES];
}


- (IBAction)TransParentBtnClick {
    
    
}

- (IBAction)loginOutBtnClick {
    
    TCCLoginViewController *tcclogin = [[TCCLoginViewController alloc] initWithNibName:@"TCCLoginViewController" bundle:nil];
    TCAppDelegate *delegate = (TCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegate.window.rootViewController = tcclogin;
}


- (IBAction)SettingBtnClick:(UIButton *)sender {
    

}


@end
