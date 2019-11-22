//
//  UIImage+ZYAdd.h
//  HuoBanTong
//
//  Created by huobantong on 2018/12/3.
//  Copyright © 2018年 huobantong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZYAdd)
/** 图文 合成 **/
+ (UIImage *)imageWithText:(NSString *)text
                  textFont:(UIFont *)font
                 textColor:(UIColor *)textColor
                 textFrame:(CGRect)textFrame
               originImage:(UIImage *)image
    imageLocationViewFrame:(CGRect)viewFrame;
/** 获取Bundle里面的图片 **/
+ (instancetype)tc_imgWithName:(NSString *)name bundle:(NSString *)bundleName targetClass:(Class)targetClass;
+ (UIImage *)scaleImage:(UIImage *)img ToSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
