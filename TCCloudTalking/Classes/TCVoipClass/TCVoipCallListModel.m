//
//  TCVoipCallListModel.m
//  FBSnapshotTestCase
//
//  Created by Huang ZhiBin on 2019/10/23.
//

#import "TCVoipCallListModel.h"

@implementation TCVoipCallListModel

- (instancetype)init{
    
    if (self = [super init]) {
    }
    
    return self;
}


- (BOOL)checkModelInfo{
    
    if (self.userId == nil ||
        self.nickName == nil ||
        self.time == nil ||
        self.callDuration == nil||
        self.headPortrait == nil ||
        self.callType == nil ||
        self.callStatus ==nil ||
        self.sendCall == nil) {
        
        
        return YES;
    }
    
    return NO;
}
@end
