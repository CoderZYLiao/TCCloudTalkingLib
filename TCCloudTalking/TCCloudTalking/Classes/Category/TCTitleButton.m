//
//  TCTitleButton.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/13.
//

#import "TCTitleButton.h"

@implementation TCTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    return self;
}


//重写整个方法  去除高亮状态下的任何操作
- (void)setHighlighted:(BOOL)highlighted{}
@end
