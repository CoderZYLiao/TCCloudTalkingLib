//
//  CollectionButtonModel.m
//  TCCloudTalking
//
//  Created by Huang ZhiBin on 2019/11/4.
//

#import "CollectionButtonModel.h"

@implementation CollectionButtonModel

+(instancetype)modelWithImage:(UIImage *)Image withTitle:(NSString *)title withUIViewController:(NSString *)VcName
{
    CollectionButtonModel *model = [[CollectionButtonModel alloc] init];
    model.CollectionImage = Image;
    model.CollectionTitle = title;
    model.CollectionName  = VcName;
    return model;
}
@end
