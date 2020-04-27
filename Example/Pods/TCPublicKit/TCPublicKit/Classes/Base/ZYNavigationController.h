//
//  ZYNavigationController.h
//  TCCloudParking
//
//  Created by LiaoZhiyao on 2019/8/7.
//  Copyright © 2019 LiaoZhiyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZYNavigationControllerDelegate <NSObject>
@optional
/**返回按钮点击*/
-(void)ZYNavigationControllerBackAction;
@end

@interface ZYNavigationController : UINavigationController
@property (nonatomic, assign) id<ZYNavigationControllerDelegate> ZYDelegate;
@end
