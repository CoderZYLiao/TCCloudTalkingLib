//
//  TCCTCatEyeSetVC.m
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/18.
//

#import "TCCTCatEyeSetVC.h"
#import "TCCTCatEyeModel.h"
#import "TCCTCatEyeHeader.h"
#import "TCCTApiManager.h"

#import "TCCTFaceListVC.h"

@interface TCCTCatEyeSetVC ()

@property (nonatomic, strong) UIView *familyPersonView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation TCCTCatEyeSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
    self.view.backgroundColor = [UIColor colorWithHexString:Color_bgColor];
    self.navigationItem.title = @"设备设置";
    [self initThePageLayout];
    
    [self reloadAwakenCatEyeRequest];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.familyPersonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(TccHeight(10));
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(TccHeight(50));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.familyPersonView).offset(TccWidth(20));
        make.centerY.mas_equalTo(self.familyPersonView);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.familyPersonView);
        make.right.mas_equalTo(self.familyPersonView).offset(-TccWidth(20));
        make.height.mas_equalTo(TccHeight(16));
        make.width.mas_equalTo(TccWidth(14));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.familyPersonView);
        make.right.mas_equalTo(self.rightImageView.mas_right).offset(-TccWidth(20));
    }];
    
}

#pragma mark - Init Page Layout
- (void)initThePageLayout{
    [self.view addSubview:self.familyPersonView];
    [self.familyPersonView addSubview:self.titleLabel];
    [self.familyPersonView addSubview:self.contentLabel];
    [self.familyPersonView addSubview:self.rightImageView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(familyPersonViewTap:)];
    [self.familyPersonView addGestureRecognizer:tapGes];
}

#pragma mark - Event Response
//管理家庭成员响应
- (void)familyPersonViewTap:(id)sender{
    TCCTFaceListVC *faceListVC = [TCCTFaceListVC new];
    faceListVC.catEyeModel = self.catEyeModel;
    [self.navigationController pushViewController:faceListVC animated:YES];
}

#pragma mark - HTTP请求：唤醒猫眼
/// 唤醒猫眼
- (void)reloadAwakenCatEyeRequest{
    [MBManager showLoading];
    [TCCTApiManager awakenCatEyeWithDeviceNum:self.catEyeModel.deviceNum success:^(id  _Nonnull responseObject) {
        [MBManager hideAlert];
        if (responseObject && ([[responseObject objectForKey:jsonResult_Code] integerValue] == 0)) {
            BOOL requestBool = [[responseObject objectForKey:jsonResult_Data] boolValue];
            if (requestBool) {
                [MBManager showBriefAlert:@"设备唤醒中,请稍后"];
            }else{
                [MBManager showBriefAlert:@"设备唤醒失败,请稍后重试"];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:@"设备唤醒超时,请稍后重试"];
    }];
}

#pragma mark - Get And Set
- (UIView *)familyPersonView{
    if (!_familyPersonView) {
        _familyPersonView = [UIView new];
        _familyPersonView.backgroundColor = [UIColor whiteColor];
    }
    return _familyPersonView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [_titleLabel setText:@"人脸识别"];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setFont:Font_Title_System18];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        [_contentLabel setText:@"管理家庭成员"];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        [_contentLabel setTextColor:[UIColor grayColor]];
        [_contentLabel setFont:Font_Title_System17];
    }
    return _contentLabel;
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
        [_rightImageView setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_cellRight"]];
    }
    return _rightImageView;
}

@end
