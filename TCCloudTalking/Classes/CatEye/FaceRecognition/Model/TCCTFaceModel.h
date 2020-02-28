//
//  TCCTFaceModel.h
//  TCCloudTalking-TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCCTFaceModel : NSObject

@property (nonatomic,copy) NSString *id;             //人脸ID
@property (nonatomic,copy) NSString *nickName;       //人脸名称
@property (nonatomic,copy) NSString *fileURL;        //图片地址
@property (nonatomic,copy) NSString *num;            //猫眼机身号

@end

NS_ASSUME_NONNULL_END
