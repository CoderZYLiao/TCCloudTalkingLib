//
//  TCOpenDoorTool.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/12/3.
//

#import "TCOpenDoorTool.h"
#import "Header.h"

@implementation TCOpenDoorTool

+ (void)openTheDoorWithID:(NSString *)ID DoorName:(NSString *)DoorName
{
    [SVProgressHUD showWithStatus:@""];
    [TCCloudTalkRequestTool OpenMyDoorWithDoorID:ID Success:^(id  _Nonnull result) {
        [SVProgressHUD dismiss];
        debugLog(@"开锁回调----%@",result);
        if ([result[@"code"] intValue] == 0) {
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@\n开锁成功",DoorName]];

        }else
        {
//            TCHousesInfoModel *houesModel = [[TCPersonalInfoModel shareInstance] getHousesInfoModel];
//            if ([[UCSTcpClient sharedTcpClientManager] login_isConnected]) {
//                NSDictionary * dict1 = @{
//                                         @"messageSenderType" : @(2),
//                                         @"formuid" : houesModel.housesInfoId
//                                         };
//
//
//                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict1 options:NSJSONWritingPrettyPrinted error:nil];
//
//                NSString *UMessage = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//
//                //开锁第二通道(在第一通道开锁不成功的情况下调用)
//                UCSTCPTransParentRequest *request = [UCSTCPTransParentRequest initWithCmdString:UMessage receiveId:houesModel.name];
//                [[UCSTcpClient sharedTcpClientManager] sendTransParentData:request success:^(UCSTCPTransParentRequest *request) {
//
//
//                    NSString * tmpack = [NSString stringWithFormat:@"发送成功:ackData-->%@",request.ackData];
//                    NSLog(@"---%@",tmpack);
//                    [SVProgressHUD dismiss];
//                    ShowSucessNoti(@"开锁成功");
//
//
//                } failure:^(UCSTCPTransParentRequest *request, UCSError *error) {
//                    [SVProgressHUD dismiss];
//                    NSLog(@"发送失败：%@ackData-->%@",error.errorDescription,request.ackData);
//                    ShowNoti(@"开锁失败");
//
//                }];
//            }
        }
    } faile:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        ShowNoti(@"请求失败");
    }];
}
@end
