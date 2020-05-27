//
//  TCOfflineFunctionController.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2020/5/12.
//

#import "TCOfflineFunctionController.h"
#import "CollectionButtonModel.h"
#import "TCSmartDoorCollectionCell.h"
#import "TCQRCodeUnlockViewController.h"
#import "TCBluetoothUnlockController.h"
#import "Header.h"

static NSString *const SmartDoorID = @"SmartDoorID";
@interface TCOfflineFunctionController ()<UICollectionViewDataSource,UICollectionViewDelegate>

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

@implementation TCOfflineFunctionController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置顶部导航栏透明，TODO 可移植于基类
    [self setNavigationBarTransparent];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self returnNavigationBarTransparent];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"离线功能";
    //初始化collectionview
    [self initCollectionViewUI];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initBackImgeUI];
}

- (void)initBackImgeUI
{
    UIImage *image = [TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_bg"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
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
    
    if ((kMainScreenHeight -TCNaviH -TCBottomTabH)>=(cellWH*1.1414*3+10)) {
        layout.itemSize = CGSizeMake(cellWH, cellWH*1.1414);
    }else
    {
        layout.itemSize = CGSizeMake(cellWH, (kMainScreenHeight -TCNaviH -TCBottomTabH-10)/3);
    }
    
    
    layout.minimumInteritemSpacing = margin;//item水平间距
    layout.minimumLineSpacing = 0;//item垂直间距
    if (!self.navigationItem.hidesBackButton) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, TCNaviH+10, MainScreenCGRect.size.width-20, MainScreenCGRect.size.height-TCNaviH-15) collectionViewLayout:layout];
    }else
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, TCNaviH+10, MainScreenCGRect.size.width-20, MainScreenCGRect.size.height-TCNaviH-15-TCBottomTabH) collectionViewLayout:layout];
    }
    
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
    if ([model.CollectionName isEqualToString:@"蓝牙开锁"]) {

        TCBluetoothUnlockController *BluetoothVc = [[TCBluetoothUnlockController alloc] init];
        [self.navigationController pushViewController:BluetoothVc animated:YES];
    }else if ([model.CollectionName isEqualToString:@"二维码开锁"])
    {
        TCQRCodeUnlockViewController *QRCodeVc = [[TCQRCodeUnlockViewController alloc] init];
        [self.navigationController pushViewController:QRCodeVc animated:YES];
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
        _collTitlsArray = @[@"蓝牙开锁",@"二维码开锁"];
    }
    return _collTitlsArray;
}

//按钮对应的图片
-(NSArray *)collImagesArray
{
    if (!_collImagesArray) {
        _collImagesArray = @[@"TC_蓝牙开锁icon",@"TCCT_ic_code unlock"];
    }
    return _collImagesArray;
}

//点击按钮要跳转进入的控制器的名字
-(NSArray *)collConVcNameArray
{
    if (!_collConVcNameArray) {
        _collConVcNameArray = @[@"蓝牙开锁",@"二维码开锁"];
    }
    return _collConVcNameArray;
}


@end
