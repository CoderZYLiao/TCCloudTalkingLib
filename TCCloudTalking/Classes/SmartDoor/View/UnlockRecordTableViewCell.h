//
//  UnlockRecordTableViewCell.h
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TCUnlcokRecordModel;
@interface UnlockRecordTableViewCell : UITableViewCell
/****模型 ******************/
@property (nonatomic, strong) TCUnlcokRecordModel *RecordModel;
+(instancetype)viewFromBundleXib;
@end

NS_ASSUME_NONNULL_END
