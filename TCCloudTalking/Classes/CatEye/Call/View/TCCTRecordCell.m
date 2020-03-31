//
//  TCCTRecordCell.m
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/23.
//

#import "TCCTRecordCell.h"
#import "TCCTRecordModel.h"
#import "SDWebImage.h"

@interface TCCTRecordCell ()

@property (nonatomic, strong) UIView *redPointView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *photoView;        //图片视频视图
@property (nonatomic, strong) UIImageView *photoImageView;      //图片或视频图片
@property (nonatomic, strong) UIImageView *playImageView;       //播放、暂停或数字背景图
@property (nonatomic, strong) UILabel *numLabel;        //图片数字

@property (nonatomic, strong) TCCTRecordModel *recordModel;
@property (nonatomic, assign) CatEyeRecordType recordType;

@end

@implementation TCCTRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.redPointView];
        [self addSubview:self.timeLabel];
        [self addSubview:self.lineView];
        [self addSubview:self.photoView];
        [self.photoView addSubview:self.photoImageView];
        [self.photoView addSubview:self.playImageView];
        [self.photoView addSubview:self.numLabel];
        [self addSubview:self.contentLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self).offset(20);
        make.width.height.mas_equalTo(10);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redPointView.mas_right).offset(TccWidth(5));
        make.centerY.equalTo(self.redPointView.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.redPointView.mas_bottom).offset(20);
        make.width.mas_equalTo(0.5);
        make.centerX.mas_equalTo(self.redPointView.mas_centerX);
        make.height.mas_equalTo(90);
    }];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lineView.mas_centerY);
        make.right.mas_equalTo(self).offset(-20);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(90);
    }];
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.photoView);
    }];
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.photoView);
        make.width.height.mas_equalTo(60);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.photoView);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineView).offset(10);
        make.centerY.mas_equalTo(self.lineView);
        make.right.mas_equalTo(self.photoView.mas_left).offset(-10);
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

- (void)setRecordModel:(TCCTRecordModel *)recordModel andRecordType:(CatEyeRecordType)recordType{
    _recordModel = recordModel;
    _recordType = recordType;
    
    //数据赋值
    self.timeLabel.text = [self timeWithTimeIntervalString:[self getTimestampFromTimeWithTimeStr:recordModel.recordDate]];
    if (recordModel.type.integerValue == CatEyeRecordType_Call) {//通话记录
        if (recordModel.callType.integerValue == 0) {
            if (recordModel.handle.integerValue == 0) {//呼入未接听
                self.contentLabel.text = [NSString stringWithFormat:@"%@呼入,未接听",recordModel.account];
            }else if (recordModel.handle.integerValue == 1) {//呼入已接听
                self.contentLabel.text = [NSString stringWithFormat:@"%@呼入,通话%ld分%ld秒",recordModel.account,recordModel.recordLen.integerValue/60,recordModel.recordLen.integerValue%60];
            }
        }else  if (recordModel.callType.integerValue == 1){
            if (recordModel.handle.integerValue == 0) {//呼出未接听
                self.contentLabel.text = [NSString stringWithFormat:@"呼叫%@,未接听",recordModel.account];
            }else if (recordModel.handle.integerValue == 1) {//呼出已接听
                self.contentLabel.text = [NSString stringWithFormat:@"呼叫%@,通话%ld分%ld秒",recordModel.account,(long)recordModel.recordLen.integerValue/60,(long)recordModel.recordLen.integerValue%60];
            }
        }
    }else if (recordModel.type.integerValue == CatEyeRecordType_Police) {//报警记录
        if (recordModel.alertType.integerValue == 1) {
            self.contentLabel.text = @"电量已低于20%，请及时充电";
        }else if (recordModel.alertType.integerValue == 2){
            if (recordModel.age.integerValue == 0) {
                self.contentLabel.text = @"陌生人在家门口长时间徘徊逗留";
            }else{
                self.contentLabel.text = [NSString stringWithFormat:@"%@岁%@在家门口长时间徘徊逗留",recordModel.age,recordModel.sex.integerValue == 0?@"女性":@"男性"];
            }
        }
    }else if (recordModel.type.integerValue == CatEyeRecordType_Face) {//人脸记录
        self.contentLabel.text = [NSString stringWithFormat:@"%@回家了",recordModel.account];
    }else{
        self.contentLabel.text = @"";
    }
    
    NSArray *catEyeFileListArray = recordModel.catEyeFileList;
    if (catEyeFileListArray.count > 0) {
        self.photoView.hidden = NO;
        
        TCCTCatEyeFileListModel *catEyeFileListModel = (TCCTCatEyeFileListModel *)catEyeFileListArray[0];
        if ([catEyeFileListModel.type integerValue] == 0) {     //图片
            [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:catEyeFileListModel.url] placeholderImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_empty"]];
            self.playImageView.image = [TCCloudTalkingImageTool getToolsBundleImage:@"sm_numIcon"];
            self.numLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)catEyeFileListArray.count];
        }else if ([catEyeFileListModel.type integerValue] == 1){    //视频
            self.numLabel.hidden = YES;
            self.playImageView.image = [TCCloudTalkingImageTool getToolsBundleImage:@"sm_playIcon"];
            
            //设置播放的项目
            AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:catEyeFileListModel.url]];
            //初始化player对象
            AVPlayer *avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
            //设置播放页面
            AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
            //设置播放页面的大小
            layer.frame = CGRectMake(0, 0, 150, 100);
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.videoGravity = AVLayerVideoGravityResizeAspect;
            [self.photoImageView.layer addSublayer:layer];
        }
    }else{
        self.photoView.hidden = YES;
    }
}

#pragma mark - Get And Set
- (UIView *)redPointView{
    if (!_redPointView) {
        _redPointView = [UIView new];
        [_redPointView setBackgroundColor:[UIColor redColor]];
        [_redPointView.layer setCornerRadius:5];
    }
    return _redPointView;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        [_timeLabel setText:@"Test 23:59:59"];
        [_timeLabel setTextColor:[UIColor redColor]];
        [_timeLabel setFont:Font_Text_System14];
    }
    return _timeLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        [_lineView setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _lineView;
}

- (UIView *)photoView{
    if (!_photoView) {
        _photoView = [UIView new];
    }
    return _photoView;
}

- (UIImageView *)photoImageView{
    if (!_photoImageView) {
        _photoImageView = [UIImageView new];
        [_photoImageView sd_setImageWithURL:[NSURL new] placeholderImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_empty"]];
    }
    return _photoImageView;
}

- (UIImageView *)playImageView{
    if (!_playImageView) {
        _playImageView = [UIImageView new];
    }
    return _playImageView;
}

- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [UILabel new];
        [_numLabel setText:@"0"];
        [_numLabel setTextAlignment:NSTextAlignmentCenter];
        [_numLabel setTextColor:[UIColor whiteColor]];
        [_numLabel setFont:Font_Title_System17];
    }
    return _numLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        [_contentLabel setText:@"Test Test Test Test Test Test Test "];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setTextColor:[UIColor blackColor]];
        [_contentLabel setFont:Font_Title_System17];
    }
    return _contentLabel;
}

#pragma mark - 辅助代码
//时间戳转换日期时分秒对象
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString{
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[timeString doubleValue]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:nd];
    return dateString;
}

- (NSString *)getTimestampFromTimeWithTimeStr:(NSString *)timeStr{
    // 时间转时间戳的方法:
    NSDate *strDate = [NSDate dateWithString:timeStr format:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[strDate timeIntervalSince1970]];
    return timeSp;
}


@end
