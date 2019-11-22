//
//  TCUserModel.m
//  TCMember
//
//  Created by Huang ZhiBing on 2019/11/6.
//

#import "TCUserModel.h"
#import "TCCommunityModel.h"

@implementation TCUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"userId" : @"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"communities" : [TCCommunityModel class],
             };
}

@end
