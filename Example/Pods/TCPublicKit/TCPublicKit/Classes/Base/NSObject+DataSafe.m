//
//  NSObject+DataSafe.m
//  Ulife
//
//  Created by NJTC on 2017/10/16.
//  Copyright © 2017年 NJTC. All rights reserved.
//

#import "NSObject+DataSafe.h"

@implementation NSObject (DataSafe)



#pragma mark - 数组NSArray
///数组NSArray





#pragma mark - 可变数组NSMutableArray



#pragma mark - 字典 NSDictionary

-(id)xyValueForKey:(NSString *)key{

    if (self == nil || [self isKindOfClass:[NSNull class]] || ![self isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary * dict = (NSDictionary *)self;
    id value = [dict objectForKey:key];
    if ([value isKindOfClass:[NSNull class]] || !value ) {
        return nil;
    }
    return value;
}



#pragma mark - 可变字典NSMutableDictionary






@end
