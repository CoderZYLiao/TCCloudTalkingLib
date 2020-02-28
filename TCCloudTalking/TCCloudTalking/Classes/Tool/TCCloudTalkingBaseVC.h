//
//  TCCloudTalkingBaseVC.h
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCCloudTalkingBaseVC : UIViewController
//设置标题和文字颜色
-(void)setNavTitleWithTitleName:(NSString *)titleName andTitleColor:(UIColor *)titelColor;

//触发左侧返回
-(void)clickLeftBarButtonItem;
//触发右侧列表
-(void)clickRightBarButtonItem:(id)sender;

//设置导航栏左侧按钮
-(void)setBackBarButton;

//设置导航栏右侧列表按钮
-(void)setRightBarButtonWithTitle:(NSString *)title;
-(void)setRightBarButtonWithImageName:(NSString *)imageName;

//设置通用导航栏
- (void)setNavigationBar;

//设置顶部导航栏透明
- (void)setNavigationBarTransparent;
//退出顶部导航栏还原，
- (void)returnNavigationBarTransparent;
@end

NS_ASSUME_NONNULL_END
