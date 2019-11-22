//
//  TCCommunityModel.m
//  TCMember
//
//  Created by Huang ZhiBing on 2019/11/6.
//

#import "TCCommunityModel.h"

@implementation TCCommunityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"communityId" : @"id"
             };
}
@end
