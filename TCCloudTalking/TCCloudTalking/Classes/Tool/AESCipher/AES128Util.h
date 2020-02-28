//
//  AES128Util.h
//  TCCommunityAssociation
//
//  Created by Huang ZhiBin on 2017/9/18.
//  Copyright © 2017年 Zhuhai Taichuan Cloud Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES128Util : NSObject


+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;


+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key;


+ (NSData*)dataForHexString:(NSString*)hexString;
@end
