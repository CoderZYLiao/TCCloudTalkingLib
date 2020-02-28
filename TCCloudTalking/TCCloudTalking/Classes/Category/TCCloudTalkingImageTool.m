//
//  TCCloudTalkingImageTool.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/11.
//

#import "TCCloudTalkingImageTool.h"

@implementation TCCloudTalkingImageTool

+ (UIImage *)getToolsBundleImage:(NSString *)imageName {
    static NSBundle *bundle;
    if (bundle == nil) {
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"TCCloudTalking" ofType:@"bundle"]];
    }
    
    if (@available(iOS 8.0, *)) {
        UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
        if (image == nil) {
            image = [UIImage imageNamed:imageName];
        }
        
        return image;
    } else {
        return nil;
    }
}
@end
