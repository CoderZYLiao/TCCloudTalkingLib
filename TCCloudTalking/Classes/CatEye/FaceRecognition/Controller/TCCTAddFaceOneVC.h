//
//  TCCTAddFaceOneVC.h
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/18.
//

#import "TCCloudTalkingBaseVC.h"
#import "TCCTCatEyeHeader.h"

NS_ASSUME_NONNULL_BEGIN

@class TCCTCatEyeModel;

@protocol TCCTAddFaceOneVCDelegate <NSObject>

- (void)addFaceDelegateWithShootImage:(NSData *)shootImageData;

@end

@interface TCCTAddFaceOneVC : TCCloudTalkingBaseVC

@property (nonatomic, strong) TCCTCatEyeModel *catEyeModel;
@property (nonatomic, assign) AddFacePushType pushType;
@property (nonatomic, weak) id<TCCTAddFaceOneVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
