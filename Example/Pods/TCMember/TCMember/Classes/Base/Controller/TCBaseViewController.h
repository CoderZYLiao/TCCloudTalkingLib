//
//  TCBaseViewController.h
//  UHomeMember
//
//  Created by Huang ZhiBing on 2019/10/16.
//  Copyright © 2019 TC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCBaseViewController : UIViewController
- (void)setTitle:(NSString *)title withBottomLineHidden:(BOOL)isHidden;

/**添加alertViewController,多个alert不可用*/
-(void)addAlertWithTitle:(NSString *)title text:(NSString *)text sureStr:(NSString *)sureStr cancelStr:(NSString *)cancelStr;
/**alertViewController点击确定*/
-(void)alertClickSureAction:(UIAlertAction *)sureAction;
/**alertViewController点击取消*/
-(void)alertClickCancelAction:(UIAlertAction *)sureAction;
@end

NS_ASSUME_NONNULL_END
