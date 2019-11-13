//
//  TCNavigationController.m
//  TaiChuanPricloud
//
//  Created by 林子 on 16/9/1.
//  Copyright © 2016年 yalintian. All rights reserved.
//

#import "TCNavigationController.h"

#define NavBarColor [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]
@interface TCNavigationController ()

@end

@implementation TCNavigationController

+ (void)load
{
    UIBarButtonItem *item=[UIBarButtonItem appearanceWhenContainedIn:self, nil ];
 
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    dic[NSForegroundColorAttributeName]= NavBarColor;
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    UINavigationBar * bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
 
//    [bar setBackgroundImage:[UIImage imageWithColor:NavBarColor] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *dicBar=[NSMutableDictionary dictionary];
    
    dicBar[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    [bar setTitleTextAttributes:dic];
    [bar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        // 非根控制器才需要
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"return_nav_mine.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"return_nav_mine.png"] forState:UIControlStateHighlighted];
    
        
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn sizeToFit];
        
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        // 内容内边距
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        
        // 不是跟控制器
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
    }
    
    return [super pushViewController:viewController animated:animated];
}


//是否出发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    //只有非根控制器才学要滑动手势
    return self.childViewControllers.count > 1;
}

//点击返回按钮时候调用
- (void)back{
    
    [self popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
