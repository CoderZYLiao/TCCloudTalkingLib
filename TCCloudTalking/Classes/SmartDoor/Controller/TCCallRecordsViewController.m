//
//  TCCallRecordsViewController.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/12.
//

#import "TCCallRecordsViewController.h"
#import "TCAllCallsViewController.h"
#import "TCMissedCallViewController.h"
#import "TCTitleButton.h"
#import "Header.h"
#import "UIView+Frame.h"

@interface TCCallRecordsViewController ()<UIScrollViewDelegate>
//存放标题的数组
@property (nonatomic, strong) NSArray *titlesArray;
//标题属性
@property (nonatomic,weak) UIView *titleVc;
//记录当前被点击的按钮
@property (nonatomic,weak) UIButton *clickedTitleBtn;
//下划线
@property (nonatomic,weak) UIView *underLine;
//滚动条
@property (nonatomic,weak) UIScrollView *scrollView;


@end

@implementation TCCallRecordsViewController
-(NSArray *)titlesArray{
    if (!_titlesArray) {
        _titlesArray = @[@"全部通话",@"未接通话"];;
    };
    return _titlesArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.title = @"通话记录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加所有的自控制器(View)
    [self setupAllChildVc];
    //设置UIScrollView
    [self setupScrollView];
    //设置title内容
    [self setupTitleContent];
    

}
- (void)setupAllChildVc{
    
    //添加所有的view
    [self addChildViewController:[[TCAllCallsViewController alloc] init]];
    [self addChildViewController:[[TCMissedCallViewController alloc] init]];

    
}

//设置UIScrollView
- (void)setupScrollView{
    
    //不要自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled  = YES;
    scrollView.bounces = NO;
    
    // 点击状态栏的时候，不需要滚动到顶部
    scrollView.scrollsToTop = NO;
    
    scrollView.delegate = self;
    //去掉底部滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    //定义属性后记得赋值  否则属性没有值
    self.scrollView = scrollView;
    
    
    //设置scrollview的滚动范围 (否则不能滚动)
    scrollView.contentSize = CGSizeMake(scrollView.width * self.childViewControllers.count, 0);
    
    
    
    
}
//设置title内容
- (void)setupTitleContent{
    
    
    //整个titile
    UIView *titleVc = [[UIView alloc] init];
    //设置title背景颜色和透明度
    titleVc.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    CGFloat titleW = self.view.width;
    CGFloat titleH = 50;
    
    titleVc.frame = CGRectMake(0, TCNaviH, titleW,titleH);
    [self.view addSubview:titleVc];
    self.titleVc = titleVc;
    
    for (int i = 0; i < self.titlesArray.count; i++) {
        TCTitleButton *titleBtn = [TCTitleButton buttonWithType:UIButtonTypeCustom];
        [self.titleVc addSubview:titleBtn];
        
        titleBtn.tag = i;
        [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        //文字
        [titleBtn setTitle:self.titlesArray[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor colorWithHexString:@"#303133"] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor colorWithHexString:@"#4073F2"] forState:UIControlStateSelected];
        titleBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:17];
        
        //fram
        
        titleBtn.y = 0;
        titleBtn.width = titleW / self.titlesArray.count;
        titleBtn.height = titleH;
        titleBtn.x = i * titleBtn.width;
        
        
        //监听点击
        [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    //设置文字下划线
    [self setuptitleLine];
    
}

#pragma mark - 文字下划线

//设置文字下划线
- (void)setuptitleLine
{
    
    //取出选中按钮的颜色
    
    TCTitleButton *firstTitleButton = self.titleVc.subviews.firstObject;
    
    UIView *underLine = [[UIView alloc] init];
    
    CGFloat underLineW =self.view.size.width/2;
    CGFloat underLineH =3;
    underLine.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    //    underLine.backgroundColor = [UIColor redColor];
    underLine.frame = CGRectMake(0, self.titleVc.height - underLineH-1, underLineW, underLineH);
    [self.titleVc addSubview:underLine];
    self.underLine = underLine;
    
    
    //默认选中第一个
    firstTitleButton.selected = YES;
    self.clickedTitleBtn = firstTitleButton;
    
    //分割线
    self.underLine.width = firstTitleButton.titleLabel.width + 100;
    self.underLine.centerX = firstTitleButton.centerX;
    
    //底部线
    UIView *Line = [[UIView alloc] init];
    Line.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB"];
    Line.frame = CGRectMake(0, self.titleVc.height-1, self.view.size.width, 1);
    [self.titleVc addSubview:Line];
}


#pragma mark - 按钮点击
//点击文字按钮时候调用
- (void)titleClick:(TCTitleButton *)titleButton{
    

    
    //按钮被点击时要执行的其他操作
    [self dealTitleButtonclick:titleButton];
    
}

- (void)dealTitleButtonclick:(TCTitleButton *)titleButton
{
    //切换按钮状态
    self.clickedTitleBtn.selected = NO;
    
    titleButton.selected = YES;
    
    self.clickedTitleBtn = titleButton;
    
    NSInteger index = titleButton.tag;
    //切换下划线状态
    [UIView animateWithDuration:0.25 animations:^{
        
        //        self.underLine.width = titleButton.titleLabel.width + 10;
        
        self.underLine.centerX = titleButton.centerX;
        
    }completion:^(BOOL finished) {
        //添加所有的子view添加到scrollView上
        
        [self setupAllChildVcView:index];
    }];
    
    // 处理tableView的滚动
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        
        //如果控制器的view没有被创建直接返回
        UIViewController *childVcView = self.childViewControllers[i];
        if (!childVcView.isViewLoaded)  continue;
        
        UIView *childVc = childVcView.view;
        
        if ([childVc isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)childVc;
            
            scrollView.scrollsToTop = (i == index);
        }
    }
    
    
    //设置scrollview的滚动
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = titleButton.tag * self.scrollView.width;
    
    [self.scrollView setContentOffset:offset animated:YES];
    
}

- (void)setupAllChildVcView:(NSInteger )index
{
    
    //懒加载子控制器view到scrollview上
    UIViewController *childVc = self.childViewControllers[index];
    [self.scrollView addSubview:childVc.view];
    
    //设置尺寸
    childVc.view.x = index * childVc.view.width;
    childVc.view.y = 0;
    childVc.view.height = self.scrollView.height;
    
    
}


#pragma mark - scrollView
//人为拖拽才会调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //计算按钮的索引
    int index = scrollView.contentOffset.x / scrollView.width;
    //    XMGTitleButton *titleBtn = self.titleButtons[index];
    TCTitleButton *titleBtn = self.titleVc.subviews[index];
    
    //点击按钮
    [self titleClick:titleBtn];
    
    
    //
}
@end
