//
//  TCCTSetModel.h
//  TCCloudTalking-TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCCTSetModel : NSObject

@property (nonatomic,copy) NSString *title;             //主题
@property (nonatomic,copy) NSString *content;           //内容
@property (nonatomic, assign) BOOL isNewVersion;        //是否有新版本

@end

NS_ASSUME_NONNULL_END
