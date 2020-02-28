//
//  TCCTAFNetworking.h
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCCTAFNetworking : NSObject

/**
 *  发送一个PATCH请求
 *
 *  @param url     请求路径
 *  @param bodyParams  body请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)patchWithURL:(NSString *)url andbodyParams:(NSArray *)bodyParams success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param urlParams  url请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url urlParams:(NSDictionary *)urlParams success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param bodyParams  body请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url andBodyParams:(NSDictionary *)bodyParams success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个DELETE请求
 *
 *  @param url     请求路径
 *  @param urlParams  url请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)deleteWithURL:(NSString *)url urlParams:(NSDictionary *)urlParams success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个PUT请求
 *
 *  @param url     请求路径
 *  @param bodyParams  body请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)putWithURL:(NSString *)url andBodyParams:(NSDictionary *)bodyParams success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个IMAGE UPLOAD POST请求
 *
 *  @param url     请求路径
 *  @param bodyParams  body请求参数
 *  @param imageData  图片数据
 *  @param imageName  图片自定义名称
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postUploadImageWithURL:(NSString *)url andImageData:(NSData *)imageData andImageName:(NSString *)imageName andBodyParams:(NSDictionary *)bodyParams success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
