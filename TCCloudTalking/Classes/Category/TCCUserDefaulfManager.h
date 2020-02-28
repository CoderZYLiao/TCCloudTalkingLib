//
//  TCCUserDefaulfManager.h
//  TCCService
//
//  Created by taichuan on 15/11/27.
//  Copyright © 2015年 chenguichun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCCUserDefaulfManager : NSObject

+ (NSString *) GetLocalDataString:(NSString *)aKey;
+ (void)SetLocalDataString:(NSString *)aValue key:(NSString *)aKey;
+ (id) GetLocalDataObject:(NSString *)aKey;
+ (void) SetLocalDataObject:(id)aValue key:(NSString *)aKey;
+ (bool) GetLocalDataBoolen:(NSString *)aKey;
+ (void) SetLocalDataBoolen:(bool)bValue key:(NSString *)aKey;

@end
