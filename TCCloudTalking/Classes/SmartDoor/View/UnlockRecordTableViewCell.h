//
//  UnlockRecordTableViewCell.h
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TCUnlcokRecordModel;
@class TCCallRecordsModel;
@interface UnlockRecordTableViewCell : UITableViewCell
/****开锁记录模型 ******************/
@property (nonatomic, strong) TCUnlcokRecordModel *RecordModel;

/****呼叫记录模型 ******************/
@property (nonatomic, strong) TCCallRecordsModel *callRecordModel;
+(instancetype)viewFromBundleXib;
@end

NS_ASSUME_NONNULL_END
