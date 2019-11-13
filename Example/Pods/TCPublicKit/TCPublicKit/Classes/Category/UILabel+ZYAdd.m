//
//  UILabel+ZYAdd.m
//  HuoBanTong
//
//  Created by huobantong on 2018/12/18.
//  Copyright © 2018年 huobantong. All rights reserved.
//

#import "UILabel+ZYAdd.h"

@implementation UILabel (ZYAdd)

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

@end
