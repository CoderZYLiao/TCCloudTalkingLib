//
//  TCSmartDoorViewController.m
//  TCCloudTalking
//
//  Created by Huang ZhiBin on 2019/11/4.
//

#import "TCSmartDoorViewController.h"
#import "CollectionButtonModel.h"
#import "TCSmartDoorCollectionCell.h"
#import "TCPasswordOpenViewController.h"
#import "TCUnlockRecordViewController.h"
#import "TCQRCodeUnlockViewController.h"
#import "TCMyCardViewController.h"
#import "TCCallRecordsViewController.h"
#import "TCOpenDoorView.h"
#import "Header.h"
static NSString *const SmartDoorID = @"SmartDoorID";
@interface TCSmartDoorViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
/*************collectionView所需的属性 **************************/
//标题数组
@property(nonatomic, strong) NSArray *collTitlsArray;

//图片数组
@property(nonatomic, strong) NSArray *collImagesArray;

//控制器名称数组
@property(nonatomic, strong) NSArray *collConVcNameArray;

/****模型数组 ******************/
@property(nonatomic, strong) NSMutableArray *displayArray;
@end

@implementation TCSmartDoorViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置顶部导航栏透明，TODO 可移植于基类
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //退出顶部导航栏还原，TODO 可移植于基类
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"智能门禁";
    //初始化collectionview
    [self initCollectionViewUI];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initBackImgeUI];
}

- (void)initBackImgeUI
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_bg"]];
    imgView.frame = self.view.bounds;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:imgView atIndex:0];
    
}

- (void)initCollectionViewUI
{
    // 创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置cell尺寸
    CGFloat margin = 5;
    NSInteger cols = 2;
    CGFloat cellWH = (MainScreenCGRect.size.width-20 - (cols - 1) * margin) / cols;
    
    layout.itemSize = CGSizeMake(cellWH, cellWH*1.1414);
    
    layout.minimumInteritemSpacing = margin;//item水平间距
    layout.minimumLineSpacing = 0;//item垂直间距
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, TCNaviH+15, MainScreenCGRect.size.width-20, MainScreenCGRect.size.height-TCNaviH-15) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    // 设置数据源
    _collectionView.dataSource = self;
    _collectionView.delegate = self;

    // 注册cell(Pods的注册方式)
     [self.collectionView registerClass:[TCSmartDoorCollectionCell class] forCellWithReuseIdentifier:SmartDoorID];
    _collectionView.scrollEnabled = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.displayArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    TCSmartDoorCollectionCell *cell = (TCSmartDoorCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:SmartDoorID forIndexPath:indexPath];
    cell.CellModel = self.displayArray[indexPath.item];
    
    return cell;
    
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionButtonModel *model = self.displayArray[indexPath.item];
    if ([model.CollectionName isEqualToString:@"监视门口"]) {

        [TCOpenDoorView show:OpenDoor_LookDoor];
    }else if ([model.CollectionName isEqualToString:@"通话记录"])
    {
        TCCallRecordsViewController *CallVc = [[TCCallRecordsViewController alloc] init];
        [self.navigationController pushViewController:CallVc animated:YES];
    }else if ([model.CollectionName isEqualToString:@"动态密码"])
    {
        TCPasswordOpenViewController *PasswordVc = [[TCPasswordOpenViewController alloc] init];
        [self.navigationController pushViewController:PasswordVc animated:YES];
    }else if ([model.CollectionName isEqualToString:@"二维码开锁"])
    {
        TCQRCodeUnlockViewController *QRCodeVc = [[TCQRCodeUnlockViewController alloc] init];
        [self.navigationController pushViewController:QRCodeVc animated:YES];
    }else if ([model.CollectionName isEqualToString:@"开锁记录"])
    {
        TCUnlockRecordViewController *UnlockVc = [[TCUnlockRecordViewController alloc] init];
        [self.navigationController pushViewController:UnlockVc animated:YES];
    }else if ([model.CollectionName isEqualToString:@"我的卡"])
    {
        TCMyCardViewController *MyCardVc = [[TCMyCardViewController alloc] init];
        [self.navigationController pushViewController:MyCardVc animated:YES];
    }
}



-(NSMutableArray *)displayArray
{
    NSMutableArray *tempModelArray = [NSMutableArray array];
    for (int i = 0; i < self.collTitlsArray.count; i++) {
        CollectionButtonModel *model = [CollectionButtonModel modelWithImage:[TCCloudTalkingImageTool getToolsBundleImage:self.collImagesArray[i]]  withTitle:self.collTitlsArray[i] withUIViewController:self.collConVcNameArray[i] ];
        [tempModelArray addObject:model];
    }
    _displayArray = tempModelArray;
    return _displayArray;
}
//按钮对应的名字
-(NSArray *)collTitlsArray
{
    if (!_collTitlsArray) {
        _collTitlsArray = @[@"监视门口",@"通话记录",@"动态密码",@"二维码开锁",@"我的卡",@"开锁记录"];
    }
    return _collTitlsArray;
}

//按钮对应的图片
-(NSArray *)collImagesArray
{
    if (!_collImagesArray) {
        _collImagesArray = @[@"TCCT_ico_监视",@"TCCT_ico_监视",@"TCCT_ico_监视",@"TCCT_ico_监视",@"TCCT_ico_监视",@"TCCT_ico_监视"];
    }
    return _collImagesArray;
}

//点击按钮要跳转进入的控制器的名字
-(NSArray *)collConVcNameArray
{
    if (!_collConVcNameArray) {
        _collConVcNameArray = @[@"监视门口",@"通话记录",@"动态密码",@"二维码开锁",@"我的卡",@"开锁记录"];
    }
    return _collConVcNameArray;
}
@end
