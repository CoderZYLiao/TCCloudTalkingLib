//
//  TCCloudTalkingBaseVC.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/28.
//

#import "TCCloudTalkingBaseVC.h"
#import "TCCloudTalkingImageTool.h"
//导航栏颜色
#define NavBarColor [UIColor colorWithRed:64/255.0 green:115/255.0 blue:242/255.0 alpha:1/1.0]
@interface TCCloudTalkingBaseVC ()

@end

@implementation TCCloudTalkingBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
}

- (void)setNavigationBar{
    self.navigationController.navigationBar.barTintColor = NavBarColor;
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    //字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    
    [self setBackBarButton];
}

- (void)setNavigationBarTransparent{
    //设置顶部导航栏透明，可移植于基类
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)returnNavigationBarTransparent{
    //退出顶部导航栏还原，可移植于基类
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

//设置标题和文字颜色
-(void)setNavTitleWithTitleName:(NSString *)titleName andTitleColor:(UIColor *)titelColor{
    
}

//触发左侧返回
-(void)clickLeftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

//触发右侧列表
-(void)clickRightBarButtonItem:(id)sender{
}

//设置导航栏左侧按钮
-(void)setBackBarButton{
    [self setLeftButtonImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_return_icon"] offSet:10];
    //    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithImage:[[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_return_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButtonItem)];
    //    self.navigationItem.leftBarButtonItem = rightBarItem;
}

- (UIBarButtonItem *)setLeftButtonImage:(UIImage *)image offSet:(CGFloat )offSet{
    
    //    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickLeftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    //    [button sizeToFit];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    //    if(IOS_VERSION >= 11.0)  {
    //        button.contentEdgeInsets =UIEdgeInsetsMake(0, -10,0, 0);
    //        button.imageEdgeInsets =UIEdgeInsetsMake(0, -10,0, 0);
    //    }else{
    //        if (offSet != 0) {
    //            UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    // 设置边框距离
    //            fixedItem.width = 0;
    //            self.navigationItem.leftBarButtonItems = @[fixedItem, leftItem];
    //            return leftItem;
    //        }
    //    }
    //    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationItem setLeftBarButtonItems:@[leftItem]];
    return leftItem;
}

- (void)clickLeftBarItem{
    if (self.navigationController.viewControllers.count>1) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
    }
}

//设置导航栏右侧列表按钮
-(void)setRightBarButtonWithTitle:(NSString *)title{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarButtonItem:)];
    [rightBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
-(void)setRightBarButtonWithImageName:(NSString *)imageName{
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarBtn addTarget:self action:@selector(clickRightBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [rightBarBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:imageName] forState:UIControlStateNormal];
    
    [rightBarBtn sizeToFit];
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
    //    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarButtonItem:)];
    //    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return image;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
