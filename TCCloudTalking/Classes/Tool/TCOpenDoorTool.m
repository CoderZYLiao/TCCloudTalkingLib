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

//    [TCCloudTalkRequestTool OpenMyDoorWithDoorID:ID Success:^(id  _Nonnull result) {
//        debugLog(@"开锁回调----%@",result);
//        if ([result[@"code"] intValue] == 0 &&[result[@"data"] intValue] == 1) {
//
//            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@\n开锁成功",DoorName]];
//
//        }else
//        {
            TCHousesInfoModel *houesModel = [[TCPersonalInfoModel shareInstance] getHousesInfoModel];
            if ([[UCSTcpClient sharedTcpClientManager] login_isConnected]) {
                NSDictionary * dict1 = @{
                                         @"messageSenderType" : @(2),
                                         @"formuid" : houesModel.housesInfoId
                                         };


                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict1 options:NSJSONWritingPrettyPrinted error:nil];

                NSString *UMessage = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

                //开锁第二通道(在第一通道开锁不成功的情况下调用)
                UCSTCPTransParentRequest *request = [UCSTCPTransParentRequest initWithCmdString:UMessage receiveId:houesModel.intercomUserId];
                [[UCSTcpClient sharedTcpClientManager] sendTransParentData:request success:^(UCSTCPTransParentRequest *request) {


                    NSString * tmpack = [NSString stringWithFormat:@"发送成功:ackData-->%@",request.ackData];
                    NSLog(@"---%@",tmpack);
                    [MBManager hideAlert];;
                    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@\n开锁成功",DoorName]];


                } failure:^(UCSTCPTransParentRequest *request, UCSError *error) {
                    [MBManager hideAlert];;
                    NSLog(@"发送失败：%@ackData-->%@",error.errorDescription,request.ackData);
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@\n开锁失败",DoorName]];

                }];
            }
//        }
//    } faile:^(NSError * _Nonnull error) {
//
//        ShowErrorNoti(@"请求失败");
//
//    }];
}
@end
