//
//  JCAccountContact.h
//  JCSDKOCShare
//
//  Created by maikireton on 2019/12/18.
//  Copyright © 2019 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCAccountContact : NSObject

@property (nonatomic, copy) NSString *serverUid;

@property (nonatomic) JCAccountContactType type;

@property (nonatomic, copy) NSString *displayName;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic) bool dnd;

@property (nonatomic) JCAccountContactChangeState changeType;

@end

NS_ASSUME_NONNULL_END
