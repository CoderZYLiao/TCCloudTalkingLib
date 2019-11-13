//
//  TCHttpTool.m
//  TCPublicKit
//
//  Created by Huang ZhiBing on 2019/10/18.
//

#import "TCHttpTool.h"
#import "TCConfigDefine.h"
#import "SVProgressHUD.h"

static AFHTTPSessionManager *mgr = nil;

@implementation TCHttpTool

+ (id)sharedHttpTool {
    static dispatch_once_t onceTask;    
    static TCHttpTool *sharedHttpTool = nil;
    dispatch_once(&onceTask, ^{
        sharedHttpTool = [[TCHttpTool alloc] init];
        mgr = [AFHTTPSessionManager manager];
        [mgr.requestSerializer setTimeoutInterval:10];
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:TCAccessToken];
        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];
    });
    return sharedHttpTool;
}

#pragma mark - Public

- (void)updateMgrRequestAccessToken:(NSString *)accessToken
{
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:TCAccessToken];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];
}

#pragma mark - Get

// 获取token接口
- (void)GetTokenRequestSuccess:(void (^)(id responseObject))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"uhome.ios" forKey:@"client_id"];
    [params setObject:@"123456" forKey:@"client_secret"];
    [params setObject:@"password" forKey:@"grant_type"];
    [params setObject:@"openid profile uhome uhome.rke uhome.o2o uhome.park" forKey:@"scope"];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:TCUsername];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:TCPassword];
    [params setObject:userName forKey:@"username"];
    [params setObject:password forKey:@"password"];
    
    [[TCHttpTool sharedHttpTool] postWithURL:GetTokenURL params:params success:^(id  _Nonnull json) {
        NSString *access_token = [json objectForKey:@"access_token"];
        [self updateMgrRequestAccessToken:access_token];
         if (success)
         {
             success(access_token);
         }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"获取登录Token失败"];
    }];
}

- (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure
{
    [SVProgressHUD show];
    __typeof(self) __weak weakSelf = self;
    [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success)
        {
            [SVProgressHUD dismiss];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"resultCode"] isEqualToString:@"31"]) {  //强制重新登录
                    failure(nil);
                    [[NSNotificationCenter defaultCenter] postNotificationName:ForceToLoginNotification object:responseObject];
                } else if ([responseObject[@"resultCode"] isEqualToString:@"401"]) {  // token过期，刷新再重新请求
                    [weakSelf GetTokenRequestSuccess:^(id responseObject) {
                         [weakSelf postWithURL:url params:params success:success failure:failure];
                    }];
                } else {
                    success(responseObject);
                }
            }else{
                success(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
        {
            [SVProgressHUD dismiss];
            failure(error);
        }
    }];
}

// 自定义的manager
- (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params withManager:(AFHTTPSessionManager *)manager
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure
{
    [SVProgressHUD show];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success)
        {
            [SVProgressHUD dismiss];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"resultCode"] isEqualToString:@"31"]) {  //强制重新登录
                    failure(nil);
                    [[NSNotificationCenter defaultCenter] postNotificationName:ForceToLoginNotification object:responseObject];
                } else{
                    success(responseObject);
                }
            } else{
                success(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:error.description];
            failure(error);
        }
    }];
}

- (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (IWFormData *data in formDataArray)
        {
            [formData appendPartWithFileData:data.data name:data.name fileName:data.filename mimeType:data.mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            DDLog(@"%@",[NSString stringWithFormat:@"[post]请求URL \n%@ 请求参数 \n%@ 回调结果\n%@",url,params,jsonStr]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            DDLog(@"%@",[NSString stringWithFormat:@"[post]请求URL \n%@ 请求参数 \n%@ 错误信息\n%@",url,params,error]);
        }
    }];
}

- (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    [mgr GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success)
        {
            success(responseObject);
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            DDLog(@"%@",[NSString stringWithFormat:@"[post]请求URL \n%@ 请求参数 \n%@ 回调结果\n%@",url,params,jsonStr]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
        {
            failure(error);
            DDLog(@"%@",[NSString stringWithFormat:@"[post]请求URL \n%@ 请求参数 \n%@ 错误信息\n%@",url,params,error]);
        }
    }];
}


- (void)postWithResponseWithURL:(NSString *)url
                         params:(NSDictionary *)params
                        success:(void (^)(id))success
                        failure:(void (^)(NSError *))failure
{
    [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success)
        {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"resultCode"] isEqualToString:@"31"]) {//强制重新登录
                    failure(nil);
                    [[NSNotificationCenter defaultCenter]postNotificationName:ForceToLoginNotification object:responseObject];
                }else{
                    success(responseObject);
                }
            }else{
                success(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
        {
            NSLog(@"%@",[NSString stringWithFormat:@"[post]请求URL \n%@ 请求参数 \n%@ 错误信息\n%@",url,params,error]);
            failure(error);
        }
    }];
}

@end

@implementation IWFormData

@end
