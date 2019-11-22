//
//  TCCallRecordsModel.m
//  FBSnapshotTestCase
//
//  Created by Huang ZhiBin on 2019/10/23.
//

#import "TCCallRecordsModel.h"
#import "TCVoipCallListModel.h"
@implementation TCCallRecordsModel



- (void)getInfoFromCallListModel:(TCVoipCallListModel *)model{
    

    self.userId = model.userId;
    self.nickName = model.nickName;
    self.time = model.time;
    self.callDuration = model.callDuration;
    self.headPortrait = model.headPortrait;
    self.callType = model.callType;
    self.callStatus = model.callStatus;
    self.sendCall = model.sendCall;
    
    
}
@end
