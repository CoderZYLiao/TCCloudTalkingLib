//
//  TCMyCardModel.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/12.
//

#import "TCMyCardModel.h"

@implementation TCMyCardModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
        self.ID = value;
}
@end
