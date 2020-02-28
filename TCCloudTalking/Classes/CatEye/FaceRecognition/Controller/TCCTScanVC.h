//
//  TCCTScanVC.h
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/18.
//

#import "TCCloudTalkingBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TCCTScanVCDelegate <NSObject>
/// 代理返回
/// @param scanCode 扫描的二维码字符
- (void)delegateWithScanCode:(NSString *)scanCode;
@end

@interface TCCTScanVC : TCCloudTalkingBaseVC

@property (nonatomic, weak) id<TCCTScanVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
