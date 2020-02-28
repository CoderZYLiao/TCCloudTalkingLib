//
//  UnlockRecordTableViewCell.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/12.
//

#import "UnlockRecordTableViewCell.h"
#import "TCUnlcokRecordModel.h"
#import "TCCallRecordsModel.h"
#import "TCCloudTalkingTool.h"
@interface UnlockRecordTableViewCell()
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *DoorMachineNameL;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *UnlockingTimeL;

@end
@implementation UnlockRecordTableViewCell

+(instancetype)viewFromBundleXib{
    // 初始化时加载collectionCell.xib文件
    NSBundle *bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TCCloudTalking.bundle"]];
    NSArray *arrayOfViews = [bundle loadNibNamed:@"UnlockRecordTableViewCell" owner:self options:nil];
    
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
    // Initialization code
}

- (void)setRecordModel:(TCUnlcokRecordModel *)RecordModel
{
    _RecordModel = RecordModel;
    self.DoorMachineNameL.text = RecordModel.eqName;
    self.UnlockingTimeL.text = RecordModel.createTime;
}

- (void)setCallRecordModel:(TCCallRecordsModel *)callRecordModel
{
    _callRecordModel = callRecordModel;
    self.DoorMachineNameL.text = callRecordModel.nickName;
    self.UnlockingTimeL.text =[TCCloudTalkingTool ConvertStrToTime:callRecordModel.time];
    if ([callRecordModel.callStatus intValue]==0) {
        [self.DoorMachineNameL setTextColor:[UIColor blackColor]];
        [self.UnlockingTimeL setTextColor:[UIColor blackColor]];
    }else
    {
        [self.DoorMachineNameL setTextColor:[UIColor redColor]];
        [self.UnlockingTimeL setTextColor:[UIColor redColor]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
