//
//  TCCTRecordDetailCell.m
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/23.
//

#import "TCCTRecordDetailCell.h"
#import "TCCTCatEyeHeader.h"
#import "SDWebImage.h"

@implementation TCCTRecordDetailCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.iconImageView];
        [self.backView addSubview:self.playBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self).offset(10);
        make.right.bottom.mas_equalTo(self).offset(-10);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.backView);
    }];
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.backView);
    }];
}

#pragma mark - Get And Set
- (UIView *)backView{
    if (!_backView) {
        _backView = [UIView new];
    }
    return _backView;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        [_iconImageView sd_setImageWithURL:[NSURL new] placeholderImage:nil];
    }
    return _iconImageView;
}

- (UIImageView *)playBtn{
    if (!_playImageView) {
        _playImageView = [UIImageView new];
        [_playImageView setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_playIcon"]];
    }
    return _playImageView;
}

@end
