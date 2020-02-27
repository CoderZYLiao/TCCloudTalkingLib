//
//  TCCTNameCell.m
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/19.
//

#import "TCCTNameCell.h"
#import "TCCTCatEyeHeader.h"

@implementation TCCTNameCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - Get And Set
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        [_nameLabel setTextColor:[UIColor blackColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setFont:Font_Title_System18];
    }
    return _nameLabel;
}

@end
