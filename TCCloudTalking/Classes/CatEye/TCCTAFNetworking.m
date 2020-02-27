//
//  TCCTAFNetworking.m
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/17.
//

#import "TCCTAFNetworking.h"
#import <TCPublicKit.h>
#import "TCCTCatEyeHeader.h"

@implementation TCCTAFNetworking

/**
 *  发送一个PATCH请求
 *
 *  @param url     请求路径
 *  @param bodyParams  body请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)patchWithURL:(NSString *)url andbodyParams:(NSArray *)bodyParams success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    //创建请求管理对象
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置HeaderField
    [sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", [[NSUserDefaults standardUserDefaults] objectForKey:TCAccessToken]] forHTTPHeaderField:@"Authorization"];
    [sessionManager.requestSerializer setValue:@"application/json-patch+json" forHTTPHeaderField:@"Content-Type"];
    [sessionManager.requestSerializer setTimeoutInterval:10];
    
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
    [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil]];
    sessionManager.responseSerializer= responseSerializer;
    
    [sessionManager PATCH:url parameters:bodyParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        TCCTLog(@"%@",[NSString stringWithFormat:@"[patch]请求URL \n%@ 请求参数 \n%@ 回调结果\n%@",url,bodyParams,jsonStr]);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TCCTLog(@"%@",[NSString stringWithFormat:@"[patch]请求URL \n%@ 请求参数 \n%@ 错误信息\n%@",url,bodyParams,error]);
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param urlParams  url请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url urlParams:(NSDictionary *)urlParams success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    //创建请求管理对象
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", [[NSUserDefaults standardUserDefaults] objectForKey:TCAccessToken]] forHTTPHeaderField:@"Authorization"];
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [sessionManager.requestSerializer setTimeoutInterval:10];
    
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
    [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil]];
    sessionManager.responseSerializer= responseSerializer;
    
    [sessionManager GET:url parameters:urlParams progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        TCCTLog(@"%@",[NSString stringWithFormat:@"[get]请求URL \n%@ 请求参数 \n%@ 回调结果\n%@",url,urlParams,jsonStr]);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TCCTLog(@"%@",[NSString stringWithFormat:@"[get]请求URL \n%@ 请求参数 \n%@ 错误信息\n%@",url,urlParams,error]);
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param bodyParams  body请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url andBodyParams:(NSDictionary *)bodyParams success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    //创建请求管理对象
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", [[NSUserDefaults standardUserDefaults] objectForKey:TCAccessToken]] forHTTPHeaderField:@"Authorization"];
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [sessionManager.requestSerializer setTimeoutInterval:10];
    
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
    [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil]];
    sessionManager.responseSerializer= responseSerializer;
    
    [sessionManager POST:url parameters:bodyParams progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        TCCTLog(@"%@",[NSString stringWithFormat:@"[post]请求URL \n%@ 请求参数 \n%@ 回调结果\n%@",url,bodyParams,jsonStr]);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TCCTLog(@"%@",[NSString stringWithFormat:@"[post]请求URL \n%@ 请求参数 \n%@ 错误信息\n%@",url,bodyParams,error]);
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  发送一个DELETE请求
 *
 *  @param url     请求路径
 *  @param urlParams  url请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)deleteWithURL:(NSString *)url urlParams:(NSDictionary *)urlParams success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    //创建请求管理对象
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", [[NSUserDefaults standardUserDefaults] objectForKey:TCAccessToken]] forHTTPHeaderField:@"Authorization"];
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [sessionManager.requestSerializer setTimeoutInterval:10];
    
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
    [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil]];
    sessionManager.responseSerializer= responseSerializer;
    
    [sessionManager DELETE:url parameters:urlParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        TCCTLog(@"%@",[NSString stringWithFormat:@"[DELETE]请求URL \n%@ 请求参数 \n%@ 回调结果\n%@",url,urlParams,jsonStr]);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TCCTLog(@"%@",[NSString stringWithFormat:@"[DELETE]请求URL \n%@ 请求参数 \n%@ 错误信息\n%@",url,urlParams,error]);
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  发送一个PUT请求
 *
 *  @param url     请求路径
 *  @param bodyParams  body请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)putWithURL:(NSString *)url andBodyParams:(NSDictionary *)bodyParams success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    //创建请求管理对象
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", [[NSUserDefaults standardUserDefaults] objectForKey:TCAccessToken]] forHTTPHeaderField:@"Authorization"];
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [sessionManager.requestSerializer setTimeoutInterval:10];
    
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
    [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil]];
    sessionManager.responseSerializer= responseSerializer;
    
    [sessionManager PUT:url parameters:bodyParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        TCCTLog(@"%@",[NSString stringWithFormat:@"[put]请求URL \n%@ 请求参数 \n%@ 回调结果\n%@",url,bodyParams,jsonStr]);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TCCTLog(@"%@",[NSString stringWithFormat:@"[put]请求URL \n%@ 请求参数 \n%@ 错误信息\n%@",url,bodyParams,error]);
        if (failure) {
            failure(error);
        }
    }];
}

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
+ (void)postUploadImageWithURL:(NSString *)url andImageData:(NSData *)imageData andImageName:(NSString *)imageName andBodyParams:(NSDictionary *)bodyParams success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    //创建请求管理对象
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    //设置HeaderField
    [sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", [[NSUserDefaults standardUserDefaults] objectForKey:TCAccessToken]] forHTTPHeaderField:@"Authorization"];
    [sessionManager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [sessionManager.requestSerializer setTimeoutInterval:10];
    
    [sessionManager POST:url parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传文件参数
        [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"%@.jpeg",imageName] mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印上传进度
        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        TCCTLog(@"上传进度:%f",progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        TCCTLog(@"%@",[NSString stringWithFormat:@"[post]请求URL \n%@ 请求参数 \n%@ 回调结果\n%@",url,bodyParams,jsonStr]);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TCCTLog(@"%@",[NSString stringWithFormat:@"[post]请求URL \n%@ 请求参数 \n%@ 错误信息\n%@",url,bodyParams,error]);
        if (failure) {
            failure(error);
        }
    }];
}

@end
