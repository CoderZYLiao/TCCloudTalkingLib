//
//  TCCTVideoOperateModel.h
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCCTVideoOperateModel : NSObject

@property (nonatomic, copy) NSString *titleName;            //名称
@property (nonatomic, assign) NSInteger type;                //类型标识
@property (nonatomic, copy) NSString *iconName;             //图标名称
@property (nonatomic, copy) NSString *pressIconName;        //按下图标名称
@property (nonatomic, copy) NSString *selectIconName;       //选择后图标名称
@property (nonatomic, assign) BOOL isSelected;              //是否已选择

@end

NS_ASSUME_NONNULL_END
