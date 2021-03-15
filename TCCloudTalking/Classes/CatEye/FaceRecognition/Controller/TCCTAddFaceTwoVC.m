//
//  TCCTAddFaceTwoVC.m
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/18.
//

#import "TCCTAddFaceTwoVC.h"
#import "TCCTCatEyeModel.h"
#import "TCCTFaceModel.h"
#import "TCCTNameCell.h"
#import "TCCTAddFaceOneVC.h"
#import "TCCTApiManager.h"
#import "TCCTFaceListVC.h"

@interface TCCTAddFaceTwoVC ()<UICollectionViewDelegate,UICollectionViewDataSource,TCCTAddFaceOneVCDelegate>

@property (nonatomic, strong) UIView *faceView;
@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UIImageView *resetPhotoImageView;

@property (nonatomic, strong) UIView *nameView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UICollectionView *nameCollectionView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *updateBtn;

@property (nonatomic, strong) NSData *curFaceImageData;    //当前拍摄的人脸识别图像
@property (nonatomic, strong) NSArray *dataArray;       //自定义数据
@property (nonatomic, assign) BOOL isResetShootImage;       //是否重新设置人脸图片
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSIndexPath *DeselectIndexpath;


@end

@implementation TCCTAddFaceTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
    self.view.backgroundColor = [UIColor colorWithHexString:Color_bgColor];
    self.dataArray = @[@"主人",@"爸爸",@"妈妈",@"爷爷",@"奶奶",@"老公",@"老婆",@"儿子",@"女儿"];
    _isResetShootImage = NO;
    
    [self initThePageLayout];
    
    if (_pushType == AddFacePushType_Add) {
        self.navigationItem.title = @"添加家庭成员";
        [self isHiddenCommitBtn:NO];
        
        self.curFaceImageData = self.faceImageData;
        self.faceImageView.image  = [UIImage imageWithData:self.curFaceImageData];
        self.resetPhotoImageView.hidden = YES;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.nameCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.nameCollectionView didSelectItemAtIndexPath:indexPath];
    }else{
        self.navigationItem.title = @"编辑家庭成员";
        [self isHiddenCommitBtn:YES];
        
        [self.faceImageView sd_setImageWithURL:[NSURL URLWithString:self.curFaceModel.fileURL]];
        self.resetPhotoImageView.hidden = NO;
        self.resetPhotoImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetShootImageClick:)];
        [self.resetPhotoImageView addGestureRecognizer:tg];
        
        for (NSInteger i =0; i < self.dataArray.count; i ++) {
            NSString *nickNameStr = self.dataArray[i];
            if ([nickNameStr isEqualToString:self.curFaceModel.nickName]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.nameCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                [self collectionView:self.nameCollectionView didSelectItemAtIndexPath:indexPath];
            }
        }
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self.faceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(TccHeight(50));
        make.centerX.mas_equalTo(self.view);
        make.width.height.mas_equalTo(200);
    }];
    [self.faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.faceView);
    }];
    [self.resetPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.faceView);
    }];
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.faceView.mas_bottom).offset(TccHeight(30));
        make.left.mas_equalTo(self.view).offset(TccWidth(20));
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(TccHeight(150));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameView).offset(TccHeight(10));
        make.left.mas_equalTo(self.nameView);
        make.height.mas_equalTo(TccHeight(20));
    }];
    [self.nameCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(TccHeight(5));
        make.left.right.mas_equalTo(self.nameView);
        make.bottom.mas_equalTo(self.nameView.mas_bottom).offset(-TccHeight(10));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(TccHeight(100));
    }];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(TccWidth(20));
        make.centerX.mas_equalTo(self.bottomView);
        make.centerY.mas_equalTo(self.bottomView);
        make.height.mas_equalTo(TccHeight(40));
    }];
    
    NSArray *buttonArr = @[self.deleteBtn,self.updateBtn];
    [buttonArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:20 tailSpacing:20];
    [buttonArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView);
        make.height.mas_equalTo(TccHeight(40));
    }];
}

#pragma mark - Init Page Layout
- (void)initThePageLayout{
    [self.view addSubview:self.faceView];
    [self.faceView addSubview:self.faceImageView];
    [self.faceView addSubview:self.resetPhotoImageView];
    
    [self.view addSubview:self.nameView];
    [self.nameView addSubview:self.nameLabel];
    [self.nameView addSubview:self.nameCollectionView];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.commitBtn];
    [self.bottomView addSubview:self.deleteBtn];
    [self.bottomView addSubview:self.updateBtn];
}

#pragma mark - Event Response
//是否隐藏拍摄按钮，其余按钮反之
- (void)isHiddenCommitBtn:(BOOL)isHidden{
    self.commitBtn.hidden = isHidden;
    self.deleteBtn.hidden = !isHidden;
    self.updateBtn.hidden = !isHidden;
}
//提交
- (void)commitBtnClick:(id)sender{
    [self reloadUploadFaceImagesRequestWithOperateType:1];
}
//删除
- (void)deleteBtnClick:(id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您是否确认删除该家庭成员" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reloadDelCatEyeFaceRequest];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
//修改
- (void)updateBtnClick:(id)sender{
    if (_isResetShootImage) {
        [self reloadUploadFaceImagesRequestWithOperateType:2];
    }else{
        [self reloadUpdateCatEyeFaceRequestWithRequestImageUrl:self.curFaceModel.fileURL];
    }
}
//重新拍摄照片
- (void)resetShootImageClick:(id)sender{
    TCCTAddFaceOneVC *addFaceVC = [[TCCTAddFaceOneVC alloc] init];
    addFaceVC.pushType = AddFacePushType_Edit;
    addFaceVC.delegate = self;
    [self.navigationController pushViewController:addFaceVC animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TCCTNameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TCCTNameCell" forIndexPath:indexPath];
    cell.nameLabel.text = self.dataArray[indexPath.row];
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.cornerRadius = 3.0;
    
    if ([self.selectIndexPath isEqual:indexPath]) {
        cell.backgroundColor = [UIColor colorWithHexString:Color_globalColor];
        cell.nameLabel.textColor = [UIColor whiteColor];
        cell.layer.borderWidth = 0;
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.nameLabel.textColor = [UIColor darkGrayColor];
        cell.layer.borderWidth = 0.5;
    }
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndexPath = indexPath;
    
    TCCTNameCell *cell = (TCCTNameCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:Color_globalColor];
    //选中之后的cell变颜色
    [self updateCellStatus:cell selected:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kMainScreenWidth - 60 - 40) / 5, 40);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.DeselectIndexpath = indexPath;
    
    TCCTNameCell *cell = (TCCTNameCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell == nil) { // 如果重用之后拿不到cell,就直接返回
        return;
    }
    [self updateCellStatus:cell selected:NO];
}

// 改变cell的背景颜色
-(void)updateCellStatus:(UICollectionViewCell *)cell selected:(BOOL)selected
{
    TCCTNameCell *familyCell = (TCCTNameCell *)cell;
    familyCell.backgroundColor = selected ? [UIColor colorWithHexString:Color_globalColor]:[UIColor whiteColor];
    familyCell.nameLabel.textColor = selected ? [UIColor whiteColor]:[UIColor darkGrayColor];
    familyCell.layer.borderWidth = selected ? 0 : 0.5;
}

#pragma mark - TCCTAddFaceOneVCDelegate
- (void)addFaceDelegateWithShootImage:(NSData *)shootImageData{
    _isResetShootImage = YES;
    self.curFaceImageData = shootImageData;
    self.faceImageView.image = [UIImage imageWithData:self.curFaceImageData];
}

#pragma mark - HTTP  上传图片、新增人脸、修改人脸、删除人脸
//上传图片 operateType：1-新增  2-修改
- (void)reloadUploadFaceImagesRequestWithOperateType:(NSInteger)operateType{
    [MBManager showLoading];
    [TCCTApiManager uploadPhotoImagesWithPhotoImageData:self.curFaceImageData andImageName:@"userFace" success:^(id  _Nonnull responseObject) {
        [MBManager hideAlert];
        if (responseObject && ([[responseObject objectForKey:jsonResult_Code] integerValue] == 0)) {
            NSString *requestImageUrl = [responseObject objectForKey:jsonResult_Data][@"url"];
            if (operateType == 1) {
                [self reloadAddCatEyeFaceRequestWithRequestImageUrl:requestImageUrl];
            }else{
                [self reloadUpdateCatEyeFaceRequestWithRequestImageUrl:requestImageUrl];
            }
        }else{
            [MBManager showBriefAlert:[responseObject objectForKey:jsonResult_Msg]];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:https_requestTimeout];
    }];
}

//新增人脸
- (void)reloadAddCatEyeFaceRequestWithRequestImageUrl:(NSString *)requestImageUrl{
    [MBManager showLoading];
    [TCCTApiManager addAndEditFaceWithDeviceNum:self.curCatEyeModel.deviceNum andType:CatEyeFaceType_Add andFaceID:@"" andFaceImage:requestImageUrl andNickName:self.dataArray[self.selectIndexPath.row] success:^(id  _Nonnull responseObject) {
        [MBManager hideAlert];
        if (responseObject && ([[responseObject objectForKey:jsonResult_Code] integerValue] == 0)) {
            BOOL requestBool = [[responseObject objectForKey:jsonResult_Data] boolValue];
            if (requestBool) {
                [MBManager showBriefAlert:@"新增家庭成员成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //返回人脸列表页
                    [self backToViewController:[TCCTFaceListVC class]];
                });
            }else{
                [MBManager showBriefAlert:@"新增家庭成员失败"];
            }
        }else{
            [MBManager showBriefAlert:[responseObject objectForKey:jsonResult_Msg]];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:https_requestTimeout];
    }];
}

//修改人脸
- (void)reloadUpdateCatEyeFaceRequestWithRequestImageUrl:(NSString *)requestImageUrl{
    [MBManager showLoading];
    [TCCTApiManager addAndEditFaceWithDeviceNum:self.curCatEyeModel.deviceNum andType:CatEyeFaceType_Edit andFaceID:self.curFaceModel.id andFaceImage:requestImageUrl andNickName:self.dataArray[self.selectIndexPath.row] success:^(id  _Nonnull responseObject) {
        [MBManager hideAlert];
        if (responseObject && ([[responseObject objectForKey:jsonResult_Code] integerValue] == 0)) {
            BOOL requestBool = [[responseObject objectForKey:jsonResult_Data] boolValue];
            if (requestBool) {
                [MBManager showBriefAlert:@"修改家庭成员成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //返回人脸列表页
                    [self backToViewController:[TCCTFaceListVC class]];
                });
            }else{
                [MBManager showBriefAlert:@"修改家庭成员失败"];
            }
        }else{
            [MBManager showBriefAlert:[responseObject objectForKey:jsonResult_Msg]];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:https_requestTimeout];
    }];
}

- (void)reloadDelCatEyeFaceRequest{
    [MBManager showLoading];
    [TCCTApiManager deleteFaceWithDeviceNum:self.curCatEyeModel.deviceNum andFaceID:self.curFaceModel.id success:^(id  _Nonnull responseObject) {
        [MBManager hideAlert];
        if (responseObject && ([[responseObject objectForKey:jsonResult_Code] integerValue] == 0)) {
            BOOL requestBool = [[responseObject objectForKey:jsonResult_Data] boolValue];
            if (requestBool) {
                [MBManager showBriefAlert:@"删除家庭成员成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //返回人脸列表页
                    [self backToViewController:[TCCTFaceListVC class]];
                });
            }else{
                [MBManager showBriefAlert:@"删除家庭成员失败"];
            }
        }else{
            [MBManager showBriefAlert:[responseObject objectForKey:jsonResult_Msg]];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:https_requestTimeout];
    }];
}

- (void)backToViewController:(Class)viewController{
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_RefreshFaceList object:nil];
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[viewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}

#pragma mark - Get And Set
- (UIView *)faceView{
    if (!_faceView) {
        _faceView = [UIView new];
    }
    return _faceView;
}

- (UIImageView *)faceImageView{
    if (!_faceImageView) {
        _faceImageView = [UIImageView new];
        _faceImageView.layer.masksToBounds = YES;
        _faceImageView.layer.cornerRadius = 100.f;
    }
    return _faceImageView;
}

- (UIImageView *)resetPhotoImageView{
    if (!_resetPhotoImageView) {
        _resetPhotoImageView = [UIImageView new];
        [_resetPhotoImageView setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_resetPhoto"]];
    }
    return _resetPhotoImageView;
}

- (UIView *)nameView{
    if (!_nameView) {
        _nameView = [UIView new];
    }
    return _nameView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        [_nameLabel setText:@"常用名称"];
        [_nameLabel setFont:Font_Title_System18];
        [_nameLabel setTextColor:[UIColor blackColor]];
    }
    return _nameLabel;
}

- (UICollectionView *)nameCollectionView{
    if (!_nameCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _nameCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _nameCollectionView.backgroundColor = [UIColor clearColor];
        _nameCollectionView.dataSource = self;
        _nameCollectionView.delegate = self;
        _nameCollectionView.showsVerticalScrollIndicator = NO;
        _nameCollectionView.showsHorizontalScrollIndicator = NO;
        //解决categoryView在吸顶状态下，且collectionView的显示内容不满屏时，出现竖直方向滑动失效的问题
        _nameCollectionView.alwaysBounceHorizontal = YES;
        [_nameCollectionView registerClass:[TCCTNameCell class] forCellWithReuseIdentifier:@"TCCTNameCell"];
    }
    return _nameCollectionView;
}


- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
    }
    return _bottomView;
}

- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [UIButton new];
        [_commitBtn setBackgroundColor:[UIColor colorWithHexString:Color_globalColor]];
        [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn.layer setCornerRadius:Fillet_CornerRadius];
        [_commitBtn addTarget:self action:@selector(commitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
        [_deleteBtn setBackgroundColor:[UIColor whiteColor]];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_deleteBtn.layer setCornerRadius:Fillet_CornerRadius];
        [_deleteBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [_deleteBtn.layer setBorderWidth:SplitLine_Height];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIButton *)updateBtn{
    if (!_updateBtn) {
        _updateBtn = [UIButton new];
        [_updateBtn setBackgroundColor:[UIColor colorWithHexString:Color_globalColor]];
        [_updateBtn setTitle:@"修改" forState:UIControlStateNormal];
        [_updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_updateBtn.layer setCornerRadius:Fillet_CornerRadius];
        [_updateBtn addTarget:self action:@selector(updateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateBtn;
}

@end
