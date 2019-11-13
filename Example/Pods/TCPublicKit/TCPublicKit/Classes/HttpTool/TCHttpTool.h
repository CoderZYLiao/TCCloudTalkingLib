//
//  TCHttpTool.h
//  TCPublicKit
//
//  Created by Huang ZhiBing on 2019/10/18.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCHttpTool : NSObject
/**
 *  单例
 */
+ (id)sharedHttpTool;

/**
 *  更新mgr请求头的AccessToken
 */
- (void)updateMgrRequestAccessToken:(NSString *)accessToken;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
- (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求（带manager参数）
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
- (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params withManager:(AFHTTPSessionManager *)manager
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure;

/**
 *  发送一个POST请求(上传文件数据)
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param formDataArray  文件参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
- (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
- (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

- (void)postWithResponseWithURL:(NSString *)url
                         params:(NSDictionary *)params
                        success:(void (^)(id))success
                        failure:(void (^)(NSError *))failure;
@end

NS_ASSUME_NONNULL_END



NS_ASSUME_NONNULL_BEGIN
/**
 *  用来封装文件数据的模型
 */
@interface IWFormData : NSObject
/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;

@end
NS_ASSUME_NONNULL_END
