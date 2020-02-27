//
//  TCCTRecordDetailVC.m
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/23.
//

#import "TCCTRecordDetailVC.h"
#import "TCCTRecordDetailCell.h"
#import "TCCTCatEyeHeader.h"
#import "TCCTRecordModel.h"
#import "TCCTApiManager.h"

@interface TCCTRecordDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *videoView;                //显示视频
@property (nonatomic, strong) UIImageView *photoImageView;      //显示图片
@property (nonatomic, strong) UIView *showView;         //显示上层视图
@property (nonatomic, strong) UIButton *playStopBtn;    //播放停止按钮
@property (nonatomic, strong) UILabel *timeLabel;       //时间
@property (nonatomic, strong) UIView *downView;         //下载视图
@property (nonatomic, strong) UIButton *downBtn;        //下载按钮
@property (nonatomic, strong) UICollectionView *contentCollectionView;  //资源视图

@property (nonatomic, assign) NSInteger curIndexPathRow;
@property (strong, nonatomic) AVPlayer *avPlayer;


@end

@implementation TCCTRecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
    self.view.backgroundColor = [UIColor colorWithHexString:Color_bgColor];
    [self setRightBarButtonWithImageName:@"sm_navDel"];
    
    [self initThePageLayout];
    if (self.recordModel.catEyeFileList.count > 0) {
        _curIndexPathRow = 0;
        [self processResourceViewShow];
        [self.contentCollectionView reloadData];
    }else{
        [MBManager showBriefAlert:@"数据异常"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.avPlayer = nil;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(TccHeight(220));
    }];
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.backView);
        make.height.mas_equalTo(TccHeight(180));
    }];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.backView);
        make.height.mas_equalTo(TccHeight(180));
    }];
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.backView);
        make.height.mas_equalTo(TccHeight(180));
    }];
    [self.playStopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.showView);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.showView).offset(-TccWidth(20));
        make.bottom.mas_equalTo(self.showView).offset(-TccWidth(20));
    }];
    [self.downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.backView);
        make.height.mas_equalTo(TccHeight(40));
    }];
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.downView);
    }];
    
    [self.contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_bottom).offset(TccHeight(2));
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

- (void)processResourceViewShow{
    TCCTCatEyeFileListModel *listModel = (TCCTCatEyeFileListModel *)self.recordModel.catEyeFileList[_curIndexPathRow];
    self.timeLabel.text = self.recordModel.recordDate;
    self.playStopBtn.selected = NO;
    
    if (listModel.type.integerValue == 0) {
        self.playStopBtn.hidden = YES;
        self.videoView.hidden = YES;
        self.photoImageView.hidden = NO;
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:listModel.url] placeholderImage:nil];
        
    }else if (listModel.type.integerValue == 1){
        self.playStopBtn.hidden = NO;
        self.videoView.hidden = NO;
        self.photoImageView.hidden = YES;
        [self.videoView.layer removeAllSublayers];
        //设置播放的项目
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:listModel.url]];
        //初始化player对象
        self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
        //设置播放页面
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
        //设置播放页面的大小
        layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, TccHeight(180));
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.videoGravity = AVLayerVideoGravityResizeAspect;
        //添加播放视图到self.view
        [self.videoView.layer addSublayer:layer];
    }
}

#pragma mark - Init Page Layout
- (void)initThePageLayout{
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.photoImageView];
    [self.backView addSubview:self.videoView];
    [self.backView addSubview:self.showView];
    [self.showView addSubview:self.playStopBtn];
    [self.showView addSubview:self.timeLabel];
    [self.view addSubview:self.downView];
    [self.downView addSubview:self.downBtn];
    [self.view addSubview:self.contentCollectionView];
}

#pragma mark - Event Response
//播放暂停
- (void)playStopBtnClick:(id)sender{
    UIButton *selectBtn = (UIButton *)sender;
    selectBtn.selected = !selectBtn.selected;
    if (selectBtn.isSelected) {
        [self.avPlayer play];
    }else{
        [self.avPlayer pause];
    }
}

//下载
- (void)downBtnClick:(id)sender{
    TCCTCatEyeFileListModel *listModel = self.recordModel.catEyeFileList[_curIndexPathRow];
    [MBManager showLoading];
    
    if (listModel.type.integerValue == 0) {
        [self toSaveImage:listModel.url];
    }else{
        [self playerDownload:listModel.url andTimeName:self.recordModel.recordDate];
    }
}

- (void)clickRightBarButtonItem:(id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"删除记录将同步删除相关联的文件,删除之后不可恢复，是否确认删除？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reloadDeleteRecordByRecordIDRequest];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.recordModel.catEyeFileList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   TCCTRecordDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TCCTRecordDetailCell" forIndexPath:indexPath];
    
    TCCTCatEyeFileListModel *listModel = self.recordModel.catEyeFileList[indexPath.row];
    NSInteger resourceType = [listModel.type integerValue];
    if (resourceType == 0) {
        cell.playImageView.hidden = YES;
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:listModel.url] placeholderImage:nil];
    }else if (resourceType == 1){
        cell.playImageView.hidden = NO;
        
        //设置播放的项目
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:listModel.url]];
        //初始化player对象
        AVPlayer *avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
        //设置播放页面
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
        //设置播放页面的大小
        layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 2, TccHeight(120));
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.videoGravity = AVLayerVideoGravityResizeAspect;
        [cell.iconImageView.layer addSublayer:layer];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _curIndexPathRow = indexPath.row;
    [self processResourceViewShow];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth / 2, TccHeight(120));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

#pragma mark - HTTPS 删除记录
- (void)reloadDeleteRecordByRecordIDRequest{
    [MBManager showLoading];
    [TCCTApiManager deleteRecordWothID:self.recordModel.id success:^(id  _Nonnull responseObject) {
        [MBManager hideAlert];
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:jsonResult_Code] integerValue] == 0) {
                BOOL requestBool = [[responseObject objectForKey:jsonResult_Data] boolValue];
                if (requestBool) {
                    [MBManager showBriefAlert:@"删除文件记录成功"];
                    //TODO
                    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_RefreshRecordList object:nil];
                    //返回上一页面
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    [MBManager showBriefAlert:@"删除文件记录失败"];
                }
            }else{
                [MBManager showBriefAlert:[responseObject objectForKey:jsonResult_Msg]];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:https_requestTimeout];
    }];
}

#pragma mark - Get And Set
- (UIView *)backView{
    if (!_backView) {
        _backView = [UIView new];
        [_backView setBackgroundColor:[UIColor blackColor]];
    }
    return _backView;
}

- (UIImageView *)photoImageView{
    if (!_photoImageView) {
        _photoImageView = [UIImageView new];
        [_photoImageView sd_setImageWithURL:[NSURL new] placeholderImage:nil];
    }
    return _photoImageView;
}

- (UIView *)videoView{
    if (!_videoView) {
        _videoView = [UIView new];
    }
    return _videoView;
}

- (UIView *)showView{
    if (!_showView) {
        _showView = [UIView new];
    }
    return _showView;
}

- (UIButton *)playStopBtn{
    if (!_playStopBtn) {
        _playStopBtn = [UIButton new];
        [_playStopBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_playIcon"] forState:UIControlStateNormal];
        [_playStopBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_stopIcon"] forState:UIControlStateSelected];
        [_playStopBtn setTarget:self action:@selector(playStopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playStopBtn;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        [_timeLabel setTextColor:[UIColor redColor]];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        [_timeLabel setFont:Font_Text_System14];
    }
    return _timeLabel;
}

- (UIView *)downView{
    if (!_downView) {
        _downView = [UIView new];
        [_downView setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _downView;
}

- (UIButton *)downBtn{
    if (!_downBtn) {
        _downBtn = [UIButton new];
        [_downBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_down"] forState:UIControlStateNormal];
        [_downBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"sm_downPre"] forState:UIControlStateHighlighted];
        [_downBtn setTarget:self action:@selector(downBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downBtn;
}

- (UICollectionView *)contentCollectionView{
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentCollectionView.backgroundColor = [UIColor clearColor];
        _contentCollectionView.dataSource = self;
        _contentCollectionView.delegate = self;
        _contentCollectionView.showsVerticalScrollIndicator = NO;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        //解决categoryView在吸顶状态下，且collectionView的显示内容不满屏时，出现竖直方向滑动失效的问题
        _contentCollectionView.alwaysBounceHorizontal = YES;
        [_contentCollectionView registerClass:[TCCTRecordDetailCell class] forCellWithReuseIdentifier:@"TCCTRecordDetailCell"];
    }
    return _contentCollectionView;
}

#pragma mark - 辅助代码
//时间戳转换日期年月月对象
- (NSString *)dateWithTimeIntervalString:(NSString *)timeString{
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[timeString doubleValue] / 1000];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:nd];
    return dateString;
}

- (void)toSaveImage:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString: urlString];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    __block UIImage *img;
    
    NSString *cacheImgStr = [manager cacheKeyForURL:url];
    if (cacheImgStr.length > 0) {
//        img = [[manager imageCache] imageFromDiskCacheForKey:cacheImgStr];
        img = [((SDImageCache *)[manager  imageCache]) imageFromDiskCacheForKey:cacheImgStr];
        // 保存图片到相册中
        UIImageWriteToSavedPhotosAlbum(img,self,@selector(image:didFinishSavingWithError:contextInfo:), nil );
    }else{
        NSData *data = [NSData dataWithContentsOfURL:url];
        img = [UIImage imageWithData:data];
        // 保存图片到相册中
        UIImageWriteToSavedPhotosAlbum(img,self,@selector(image:didFinishSavingWithError:contextInfo:), nil );
    }
}

//保存图片完成之后的回调

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [MBManager hideAlert];
    if(error){
        [MBManager showBriefAlert:@"图片下载保存失败"];
    }else{
        [MBManager showBriefAlert:@"图片下载保存成功"];
    }
}

- (void)playerDownload:(NSString *)url andTimeName:(NSString *)timeName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, [NSString stringWithFormat:@"%@.mp4",timeName]];
    NSURL *urlNew = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [self saveVideo:fullPath];
    }];
    [task resume];
}

- (void)saveVideo:(NSString *)videoPath{
    if (videoPath) {
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath);
        if (compatible) {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

//保存视频完成之后的回调
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    [MBManager hideAlert];
    if(error){
        [MBManager showBriefAlert:@"视频下载保存失败"];
    }else{
        [MBManager showBriefAlert:@"视频下载保存成功"];
    }
}

@end
