//
//  TCCTFaceCell.m
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/18.
//

#import "TCCTFaceCell.h"
#import "TCCTFaceModel.h"

#import "TCCTCatEyeHeader.h"

@interface TCCTFaceCell ()

@property (nonatomic, strong) TCCTFaceModel *faceModel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation TCCTFaceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.rightImageView];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(TccWidth(20));
        make.centerY.mas_equalTo(self);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-TccWidth(20));
        make.height.mas_equalTo(TccHeight(16));
        make.width.mas_equalTo(TccWidth(14));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(TccWidth(20));
        make.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFaceModel:(TCCTFaceModel *)faceModel{
    _faceModel = faceModel;
    self.titleLabel.text = faceModel.nickName;
}

#pragma mark - Get And Set
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setFont:Font_Title_System18];
    }
    return _titleLabel;
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
        [_rightImageView setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_cellRight"]];
    }
    return _rightImageView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        [_lineView setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _lineView;
}

@end
