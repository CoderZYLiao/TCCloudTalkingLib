//
//  JCDoodleAction.h
//  JCSDKOC
//
//  Created by young on 2017/12/29.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#define JCColor UIColor
#elif TARGET_OS_MAC
#define JCColor NSColor
#endif

/**
 *  @brief 涂鸦类型
 */
typedef NS_ENUM(NSInteger, JCDoodleActionType) {
    /// 开始涂鸦
    JCDoodleActionStart = 0x100,
    /// 结束涂鸦
    JCDoodleActionStop,
    /// 撤销
    JCDoodleActionUndo,
    /// 清除涂鸦
    JCDoodleActionClear,
    /// 画曲线
    JCDoodleActionDraw,
    /// 橡皮檫
    JCDoodleActionErase,
    /// 贴图
    JCDoodleActionSticker,
    /// 翻页
    JCDoodleActionSelectPage,
    /// 获取数据
    JCDoodleActionFetch,
    /// 请求
    JCDoodleActionRequest,
    /// 回应
    JCDoodleActionResponse,
    /// 自定义类型
    JCDoodleActionExtraBase = 0x200
};

/**
 *  @brief 涂鸦操作类
 */
@interface JCDoodleAction : NSObject


/**
 *  @brief 类型，可在JCDoodleActionExtraBase基础上来扩展自定义类型
 */
@property (nonatomic) JCDoodleActionType actionType;


/**
 *  @brief 发起者
 */
@property (nullable, nonatomic, copy) NSString *userId;


/**
 *  @brief 自定义数据
 */
@property (nullable, nonatomic, copy) NSString *userDefined;


/**
 *  @brief 用于多页涂鸦，默认为0
 */
@property (nonatomic) NSUInteger pageNumber;


/**
 *  @brief 设置涂鸦轨迹或橡皮擦宽度，默认为0
 */
@property (nonatomic) float brushWidth;


/**
 *  @brief 设置涂鸦轨迹的颜色，默认为nil
 */
@property (nullable, nonatomic, copy) JCColor *brushColor;


/**
 *  @brief 设置贴图 unicode。当贴图为 emoji 表情时，需要设置 unicode。
 */
@property (nullable, nonatomic, copy) NSString *stickerUnicode;

/**
 *  @brief 设置 stickerName。当贴图为自定义图片时，需要设置 stickerName。
 */
@property (nullable, nonatomic, copy) NSString *stickerName;

/**
 *  @brief 设置贴图逻辑 x 值，逻辑坐标点由屏幕坐标点根据屏幕尺寸转化。
 */
@property (nonatomic) float stickerX;

/**
 *  @brief 设置贴图逻辑 y 值，逻辑坐标点由屏幕坐标点根据屏幕尺寸转化。
 */
@property (nonatomic) float stickerY;

/**
 *  @brief 设置贴图宽度
 */
@property (nonatomic) float stickerWidth;

/**
 *  @brief 设置贴图高度
 */
@property (nonatomic) float stickerHeight;

/**
 *  @brief 设置贴图角度
 */
@property (nonatomic) int stickerRotate;

/**
 *  @brief 涂鸦轨迹的点集合，数组内的每一个NSArray，表示一个点。一个点(NSArray)内包含了3个值，第一个值是和上一个点的时间间隔(毫秒, int型)，第二个值是点的x坐标(float型)，第三个值是点的y坐标(float型)。
 *  @discussion  x, y是逻辑坐标点，需使用以下方法转换成屏幕的坐标点(sX, sY)
 *  size屏幕view的尺寸（如(375, 667)）
 *  CGFloat sX = (x + 1.0) * size.width / 2;
 *  CGFloat sY = (y + 1.0) * size.height / 2;
 *  
 *  @discussion 加点使用接口 - (void)addPointWithPositionX:(float)x positionY:(float)y timeInterval:(int)timeInterval;
 */
@property (nullable, nonatomic, readonly, strong) NSArray<NSArray<NSNumber *> *> *pathPoints;

/**
 *  @brief 加点
 *  point屏幕的坐标点（如(100, 100)），size屏幕view的尺寸（如(375, 667)）
 *  float x = 2 * point.x / size.width - 1.0;
 *  float y = 2 * point.y / size.height - 1.0;
 *  @param x 需使用以下方法把屏幕的坐标点转换成逻辑坐标点
    @param y 需使用以下方法把屏幕的坐标点转换成逻辑坐标点
 *  @param timeInterval 点与点的时间间隔
 */
- (void)addPointWithPositionX:(float)x positionY:(float)y timeInterval:(int)timeInterval;

@end

