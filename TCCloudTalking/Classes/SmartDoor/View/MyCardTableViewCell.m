//
//  MyCardTableViewCell.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/12.
//

#import "MyCardTableViewCell.h"
#import "TCCloudTalkingImageTool.h"
@interface MyCardTableViewCell()
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *CardIDL;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *CardStatusL;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *CardTimeL;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *CardTypeL;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *CardBackImageView;

@end
@implementation MyCardTableViewCell

+(instancetype)viewFromBundleXib{
    // 初始化时加载collectionCell.xib文件
    NSBundle *bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TCCloudTalking.bundle"]];
    NSArray *arrayOfViews = [bundle loadNibNamed:@"MyCardTableViewCell" owner:self options:nil];
    
    // 如果路径不存在，return nil
    
    if(arrayOfViews.count < 1){return nil;}
    // 如果xib中view不属于UICollectionViewCell类，return nil
    if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UITableViewCell class]]){
        return nil;
    }
    // 加载nib
    return [arrayOfViews objectAtIndex:0];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.CardTypeL.text = @"门\n禁\nIC\n卡";
    self.CardTypeL.numberOfLines = [self.CardTypeL.text length];
    self.CardTypeL.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:15];
    self.CardTypeL.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    
    self.CardBackImageView.image = [TCCloudTalkingImageTool getToolsBundleImage:@"bg_卡片1"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
