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

@end

@implementation TCTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArray = [NSMutableArray array];
}

- (IBAction)Text1BtnClick:(id)sender {
    [TCCTAFNetworking getWithURL:[NSString stringWithFormat:@"%@/smarthome/api/device",KProjectAPIBaseURL] urlParams:[NSDictionary new] success:^(id  _Nonnull json) {
        
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
            
            TCCTCatEyeMonitorVC *monitorVC = [TCCTCatEyeMonitorVC new];
            monitorVC.catEyeModel = model;
            [self.navigationController pushViewController:monitorVC animated:YES];
            
            
            
//            TCCTCatEyeOperateVC *vc = [[TCCTCatEyeOperateVC alloc] init];
//            vc.deviceOperate = CatEyeDeviceOperate_Edit;
//            vc.catEyeModel = model;
//            [self.navigationController pushViewController:vc animated:YES];
        }else{
            TCCTCatEyeOperateVC *vc = [[TCCTCatEyeOperateVC alloc] init];
            vc.deviceOperate = CatEyeDeviceOperate_Add;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (IBAction)text2BtnClick:(UIButton *)sender {
    [TCCTAFNetworking getWithURL:[NSString stringWithFormat:@"%@/smarthome/api/device",KProjectAPIBaseURL] urlParams:[NSDictionary new] success:^(id  _Nonnull json) {
            
            [self.dataArray removeAllObjects];
            NSArray *dataArr = [json objectForKey:@"data"];
            //1、JSON数据初步处理
            for (NSDictionary *dataDict in dataArr) {
                NSInteger dataType = [[dataDict objectForKey:@"type"] integerValue];
                NSArray *subDataAarry = [dataDict objectForKey:@"data"];
                if (dataType == 2) {    //
                    for (NSDictionary *dict in subDataAarry) {
                        [self.dataArray addObject:[TCCTCatEyeModel modelWithJSON:dict]];
                    }
                }
            }
            
            if (self.dataArray.count > 0) {
                TCCTCatEyeModel *model = (TCCTCatEyeModel *)self.dataArray[0];
//
//                TCCTCatEyeMonitorVC *monitorVC = [TCCTCatEyeMonitorVC new];
//                monitorVC.catEyeModel = model;
//                [self.navigationController pushViewController:monitorVC animated:YES];
//
                
                
                TCCTCatEyeOperateVC *vc = [[TCCTCatEyeOperateVC alloc] init];
                vc.deviceOperate = CatEyeDeviceOperate_Edit;
                vc.catEyeModel = model;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                TCCTCatEyeOperateVC *vc = [[TCCTCatEyeOperateVC alloc] init];
                vc.deviceOperate = CatEyeDeviceOperate_Add;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
}

@end
