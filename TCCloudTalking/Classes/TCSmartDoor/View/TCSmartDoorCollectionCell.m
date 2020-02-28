//
//  TCSmartDoorCollectionCell.m
//  TCCloudTalking
//
//  Created by Huang ZhiBin on 2019/11/4.
//

#import "TCSmartDoorCollectionCell.h"
#import "CollectionButtonModel.h"
#import "TCCloudTalkingImageTool.h"
@interface TCSmartDoorCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *BackCellIamge;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation TCSmartDoorCollectionCell


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // 在此添加
        // 初始化时加载collectionCell.xib文件
        NSBundle *bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TCCloudTalking.bundle"]];
        NSArray *arrayOfViews = [bundle loadNibNamed:@"TCSmartDoorCollectionCell" owner:self options:nil];
        // 如果路径不存在，return nil
        if(arrayOfViews.count < 1){return nil;}
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.BackCellIamge.image = [TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_CellView"];
    // Initialization code
}

- (void)setCellModel:(CollectionButtonModel *)CellModel
{
    _CellModel = CellModel;
    self.ImageView.image = CellModel.CollectionImage;
    self.titleLabel.text = CellModel.CollectionTitle;
}

@end
