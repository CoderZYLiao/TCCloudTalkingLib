//
//  MBManager.h
//  Created by Leo on 16/1/23.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MBManager : NSObject

/**
 *  是否显示变淡效果，默认为YES，  PS：只为 showPermanentAlert:(NSString *) alert 和 showLoading 方法添加
 */
+ (void)showGloomy:(BOOL) isShow;
/**
 *  带Logo圈圈图片
 */
+ (void)showLoading;
/**
 *  自定义等待提示语，效果同showLoading
 *
 *  @param title 提示语
 */
+ (void)showWaitingWithTitle:(NSString *)title;
/**
 *  一直显示自定义提示语，不带圈圈
 *
 *  @param alert 提示信息
 */
+ (void) showPermanentAlert:(NSString *) alert;
/**
 *  显示简短的提示语，默认2秒钟，时间可直接修改kShowTime
 *
 *  @param alert 提示信息
 */
+ (void) showBriefAlert:(NSString *) alert;
/**
 自定义加载视图
 @param imageName 图片名字
 @param title 标题
 */
+(void)showAlertWithCustomImage:(NSString *)imageName title:(NSString *)title;

/**
 自定义提示的显示时间，默认横屏

 @param message 提示语
 @param showTime 提示时间
 */
+ (void)showBriefAlert:(NSString *)message time:(NSInteger)showTime;
/**
 *  隐藏alert
 */
+(void)hideAlert;

@end


@interface GloomyView : UIView<UIGestureRecognizerDelegate>
@end
