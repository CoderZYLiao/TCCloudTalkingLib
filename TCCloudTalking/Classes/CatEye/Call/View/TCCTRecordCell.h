//
//  TCCTRecordCell.h
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/23.
//

#import <UIKit/UIKit.h>
#import "TCCTCatEyeHeader.h"

@class TCCTRecordModel;

NS_ASSUME_NONNULL_BEGIN

@interface TCCTRecordCell : UITableViewCell

- (void)setRecordModel:(TCCTRecordModel *)recordModel andRecordType:(CatEyeRecordType)recordType;

@end

NS_ASSUME_NONNULL_END
