//
//  TCPasswordOpenViewController.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/6.
//

#import "TCPasswordOpenViewController.h"
#import "Header.h"

@interface TCPasswordOpenViewController ()
@property (nonatomic ,copy) NSString *PasswordCode;//动态密码
@end

@implementation TCPasswordOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"动态密码";

    self.view.backgroundColor = [UIColor whiteColor];
    self.PasswordCode = @"123456";
    [self initUI];
    [self initPasswordUI];
}

- (void)initUI
{
    UIView *View = [[UIView alloc] init];
    View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:View];
    [View mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.leading.trailing.top.bottom.equalTo(self.view);
        }
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_动态密码"];
    [View addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View).offset(135);
        make.centerX.equalTo(View);
        make.width.height.mas_equalTo(88);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"动态开门密码";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    label.textColor = [UIColor colorWithRed:48/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
    [View addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
}

- (void)initPasswordUI
{
    NSUInteger LabelW = (MainScreenCGRect.size.width-84)/6;
    for (int index = 0; index < 6; index ++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(42+index*(LabelW-3), 270+TCNaviH, LabelW, LabelW)];
        [self.view addSubview:label];
        NSString *subStr=[self.PasswordCode substringWithRange:NSMakeRange(index, 1)];
        DDLog(@"%@",subStr);
        label.text =subStr;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:40];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.backgroundColor =  [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0].CGColor;
        label.layer.borderColor = [UIColor blueColor].CGColor;//颜色
        label.layer.borderWidth = 3.0f;//设置边框粗细
        label.layer.cornerRadius = 10;
        label.layer.masksToBounds = YES;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 270+TCNaviH+LabelW+5, MainScreenCGRect.size.width, 30)];
    [self.view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"提示：密码仅单次有效，如遇失效请重新获取";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    label.textColor = [UIColor colorWithRed:144/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
}

@end
