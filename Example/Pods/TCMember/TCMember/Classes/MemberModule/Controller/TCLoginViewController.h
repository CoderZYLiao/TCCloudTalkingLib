//
//  TCLoginViewController.h
//  UHomeMember
//
//  Created by Huang ZhiBing on 2019/10/10.
//  Copyright © 2019 TC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LoginSucceedAction) (NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface TCLoginViewController : UIViewController
@property (nonatomic, strong) LoginSucceedAction loginSucceedAction;
@end

NS_ASSUME_NONNULL_END
