//
//  TCCTAddFaceTwoVC.h
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/18.
//

#import "TCCloudTalkingBaseVC.h"
#import "TCCTCatEyeHeader.h"

NS_ASSUME_NONNULL_BEGIN

@class TCCTCatEyeModel,TCCTFaceModel;

@interface TCCTAddFaceTwoVC : TCCloudTalkingBaseVC

@property (nonatomic, strong) NSData *faceImageData;   //人脸图像
@property (nonatomic, assign) AddFacePushType pushType;
@property (nonatomic, strong) TCCTFaceModel *curFaceModel;
@property (nonatomic, strong) TCCTCatEyeModel *curCatEyeModel;

@end

NS_ASSUME_NONNULL_END
