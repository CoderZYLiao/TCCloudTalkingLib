//
//  UIImage+ZYAdd.m
//  HuoBanTong
//
//  Created by huobantong on 2018/12/3.
//  Copyright © 2018年 huobantong. All rights reserved.
//

#import "UIImage+ZYAdd.h"

@implementation UIImage (ZYAdd)
/** 图文 合成 **/
+ (UIImage *)imageWithText:(NSString *)text
                  textFont:(UIFont *)font
                 textColor:(UIColor *)textColor
                 textFrame:(CGRect)textFrame
               originImage:(UIImage *)image
    imageLocationViewFrame:(CGRect)viewFrame {
    
    if (!text)      {  return image;   }
    if (!textColor) {  textColor = [UIColor blackColor];   }
    if (!image)     {  return nil;  }
    if (viewFrame.size.height==0 || viewFrame.size.width==0 || textFrame.size.width==0 || textFrame.size.height==0 )
    {  return nil; }
    // 用UIGraphics进行2D图像渲染 不要用UIGraphicsBeginImageContext(size); 不然图片会模糊
    UIGraphicsBeginImageContextWithOptions(viewFrame.size, NO, 0.0);
    [image drawInRect:viewFrame];
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGContextDrawPath (context, kCGPathStroke );
    
    NSDictionary *attr = @{NSFontAttributeName: font, NSForegroundColorAttributeName : textColor };
    //位置显示
    [text drawInRect:textFrame withAttributes:attr];
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}

/** 获取Bundle里面的图片 **/
+ (instancetype)tc_imgWithName:(NSString *)name bundle:(NSString *)bundleName targetClass:(Class)targetClass{
    NSInteger scale = [[UIScreen mainScreen] scale];
    NSBundle *curB = [NSBundle bundleForClass:targetClass];
    NSString *imgName = [NSString stringWithFormat:@"%@@%zdx.png", name,scale];
    NSString *dir = [NSString stringWithFormat:@"%@.bundle",bundleName];
    NSString *path = [curB pathForResource:imgName ofType:nil inDirectory:dir];
    return path?[UIImage imageWithContentsOfFile:path]:nil;
}

+ (UIImage *)scaleImage:(UIImage *)img ToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
