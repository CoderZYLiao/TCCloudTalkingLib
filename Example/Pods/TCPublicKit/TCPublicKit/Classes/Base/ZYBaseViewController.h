//
//  ZYBaseViewController.h
//  TCCloudParking
//
//  Created by LiaoZhiyao on 2019/8/8.
//  Copyright © 2019 LiaoZhiyao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ZYBaseVCBtnAction) (NSInteger tag);

@interface ZYBaseViewController : UIViewController
@property(nonatomic, strong) UIButton *btnLeft;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIButton *btnRight;
@property(nonatomic, strong) ZYBaseVCBtnAction btnClickAction;
@end
