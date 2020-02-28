//
//  CollectionButtonModel.h
//  TCCloudTalking
//
//  Created by Huang ZhiBin on 2019/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionButtonModel : NSObject
/****图片 ******************/
@property(nonatomic, strong) UIImage *CollectionImage;

/****title ******************/
@property(nonatomic, strong) NSString *CollectionTitle;

/****控制器 ******************/
@property(nonatomic, strong) NSString *CollectionName;

+(instancetype)modelWithImage:(UIImage *)Image withTitle:(NSString *)title withUIViewController:(NSString *)VcName;
@end

NS_ASSUME_NONNULL_END
