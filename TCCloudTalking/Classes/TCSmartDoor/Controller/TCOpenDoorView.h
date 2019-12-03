//
//  TCOpenDoorView.h
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, openDoor_Type)
{
    //监视门口
    OpenDoor_LookDoor = 0,
    
    //开锁
    OpenDoor_OpenDoor = 1
};

@interface TCOpenDoorView : UIView
/**
 * 显示
 */
+ (void)show :(openDoor_Type )type;
@end

NS_ASSUME_NONNULL_END
