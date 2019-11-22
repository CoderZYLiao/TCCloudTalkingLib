//
//  MyCardTableViewCell.h
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TCMyCardModel;
@interface MyCardTableViewCell : UITableViewCell
//卡模型
@property (nonatomic,strong) TCMyCardModel *CardItems;
//卡背景色选择
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *CardBackImageView;
+(instancetype)viewFromBundleXib;
@end

NS_ASSUME_NONNULL_END
