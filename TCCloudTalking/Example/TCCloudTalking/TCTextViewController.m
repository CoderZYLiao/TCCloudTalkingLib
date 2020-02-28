//
//  TCTextViewController.m
//  TCCloudTalking_Example
//
//  Created by Huang ZhiBin on 2019/12/13.
//  Copyright © 2019 TYL. All rights reserved.
//

#import "TCTextViewController.h"
#import "TCSmartDoorViewController.h"

@interface TCTextViewController ()

@end

@implementation TCTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)Text1BtnClick:(id)sender {
    TCSmartDoorViewController *textVc = [[TCSmartDoorViewController alloc] init];
    textVc.isPush = YES;
    [self.navigationController pushViewController:textVc animated:YES];
}

- (IBAction)text2BtnClick:(UIButton *)sender {
    TCSmartDoorViewController *textVc = [[TCSmartDoorViewController alloc] init];
    textVc.isPush = NO;
    [self.navigationController pushViewController:textVc animated:YES];
}

@end
