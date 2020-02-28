//
//  UIImage+HLS.h
//  AutoBuy
//
//  Created by AutoBuy on 14/11/19.
//  Copyright (c) 2014年 HORIZON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HLS)

+ (UIImage *)imageWithName:(NSString *)name;

+ (UIImage *)resizedImage:(NSString *)name;

+ (UIImage *)imageWithNamed:(NSString *)name;
//对图片尺寸进行压缩--
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

-(UIImage*)scaleToSize:(CGSize)size;

/**
 根据指定宽或高等比例缩放图片，宽和高都给以宽为标准
 */
-(CGSize)scaleWithWidth:(CGFloat)width orHeight:(CGFloat)height;

+ (UIImage *)imageWithTitle:(NSString *)title fontSize:(CGFloat)size;

+ (UIImage *)placeHolderImageWithName:(NSString *)name;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithRandomColor;

+ (UIImage *)imageWithimage:(UIImage *)image;

+ (UIImage *)resizedImage:(NSString *)name leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale;

+ (UIImage *)imageWithRect:(CGRect)rect;
@end
