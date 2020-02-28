//
//  TCTextViewController.m
//  TCCloudTalking_Example
//
//  Created by Huang ZhiBin on 2019/12/13.
//  Copyright © 2019 TYL. All rights reserved.
//

#import "TCTextViewController.h"
#import "TCSmartDoorViewController.h"
#import "TCCTAFNetworking.h"
#import "TCCTCatEyeModel.h"
#import "TCCTCatEyeMonitorVC.h"
#import "TCCTCatEyeOperateVC.h"
#import "TCCTCatEyeAccountManager.h"

@interface TCTextViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *catEyeDeviceNumLabel;

@end

@implementation TCTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArray = [NSMutableArray array];
    
    [MBManager showLoading];
    [TCCTAFNetworking getWithURL:[NSString stringWithFormat:@"%@/smarthome/api/device",KProjectAPIBaseURL] urlParams:[NSDictionary new] success:^(id  _Nonnull json) {
        [MBManager hideAlert];
        
        if (json && [json isKindOfClass:[NSDictionary class]] && [[json objectForKey:@"code"] integerValue] == 0) {
            
            [self.dataArray removeAllObjects];
            NSArray *dataArr = [json objectForKey:@"data"];
            //1、JSON数据初步处理
            for (NSDictionary *dataDict in dataArr) {
                NSInteger dataType = [[dataDict objectForKey:@"type"] integerValue];
                NSArray *subDataAarry = [dataDict objectForKey:@"data"];
                if (dataType == 2) {
                    if (subDataAarry.count > 0) {
                        [TCCTCatEyeAccountManager tcSaveCatEyeListDataDict:dataDict];
                    }
                    for (NSDictionary *dict in subDataAarry) {
                        [self.dataArray addObject:[TCCTCatEyeModel modelWithJSON:dict]];
                    }
                }
            }
            if (self.dataArray.count > 0) {
                TCCTCatEyeModel *model = (TCCTCatEyeModel *)self.dataArray[0];
                self.catEyeDeviceNumLabel.text = [NSString stringWithFormat:@"%@-%@",model.deviceName,model.deviceNum];
                
            }else{
                [MBManager showBriefAlert:@"暂无猫眼,请先添加"];
            }
        }else{
            [MBManager showBriefAlert:[json objectForKey:@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:@"请求超时"];
    }];
}

- (IBAction)Text1BtnClick:(id)sender {
    if (self.dataArray.count <= 0) {
        TCCTCatEyeOperateVC *vc = [[TCCTCatEyeOperateVC alloc] init];
        vc.deviceOperate = CatEyeDeviceOperate_Add;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [MBManager showBriefAlert:@"猫眼已存在,请点击查看"];
    }
}

- (IBAction)text2BtnClick:(UIButton *)sender {
    if (self.dataArray.count > 0) {
        TCCTCatEyeModel *model = (TCCTCatEyeModel *)self.dataArray[0];
        
        TCCTCatEyeOperateVC *vc = [[TCCTCatEyeOperateVC alloc] init];
        vc.deviceOperate = CatEyeDeviceOperate_Edit;
        vc.catEyeModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [MBManager showBriefAlert:@"暂无猫眼,请先添加"];
    }
}

- (IBAction)selectBtnClick:(id)sender {
    if (self.dataArray.count > 0) {
        TCCTCatEyeModel *model = (TCCTCatEyeModel *)self.dataArray[0];
        
        TCCTCatEyeMonitorVC *monitorVC = [TCCTCatEyeMonitorVC new];
        monitorVC.catEyeModel = model;
        [self.navigationController pushViewController:monitorVC animated:YES];
        
    }else{
        [MBManager showBriefAlert:@"暂无猫眼,请先添加"];
    }
}

@end
