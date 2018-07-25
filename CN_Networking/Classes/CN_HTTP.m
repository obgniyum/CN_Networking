
#import "CN_HTTP.h"
#import "AFNetworking.h"
#import "CN_NET_Util.h"
#import "CN_NET_Queue.h"
#import "CN_NET_Model.h"
#import "CN_NET_Service.h"

@interface CN_HTTP ()

/**
 请求会话
 */
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
/**
 请求任务
 */
@property (nonatomic, strong) NSURLSessionDataTask *task;
/**
 请求次数（针对闪断问题，最多三次）
 */
@property (nonatomic, assign) NSInteger requestErrorCount;

/**
 进度回调
 */
@property (nonatomic, copy) void(^callback_progress)(CGFloat p);
/**
 成功回调
 */
@property (nonatomic, copy) void(^callback_success)(id data);
/**
 失败回调
 */
@property (nonatomic, copy) void(^callback_failure)(NSString *errMsg);

@end

@implementation CN_HTTP

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _method = CN_REQ_METHOD_POST;
    }
    return self;
}
// MARK:- Public
// MARK: └ 环境配置
+ (void)CN_DEBUG:(CN_URL_SCHEME)scheme
            host:(NSString *)host
            port:(NSString *)port {
    [self _envConfig:CN_NET_ENV_DEBUG
          scheme:scheme
            host:host
            port:port];
}

+ (void)CN_TEST:(CN_URL_SCHEME)scheme
           host:(NSString *)host
           port:(NSString *)port {
    [self _envConfig:CN_NET_ENV_TEST
          scheme:scheme
            host:host
            port:port];
}

+ (void)CN_RELEASE:(CN_URL_SCHEME)scheme
              host:(NSString *)host
              port:(NSString *)port {
    [self _envConfig:CN_NET_ENV_RELEASE
          scheme:scheme
            host:host
            port:port];
}

+ (void)_envConfig:(CN_NET_ENV)env
        scheme:(CN_URL_SCHEME)scheme
          host:(NSString *)host
          port:(NSString *)port {
    // 0.1 key
    NSString *key_id = NSStringFromClass(self);
    NSString *key_env = [NSString stringWithFormat:@"%lu", (unsigned long)env];
    NSString *key = [NSString stringWithFormat:@"%@_%@", key_id, key_env];
    // 0.2 value
    CN_NET_Model *model = [CN_NET_Model new];
    model.scheme = [CN_NET_Util CN_StringFromScheme:scheme];
    model.host = host;
    model.port = port;
    // 1 save
    [[CN_NET_Service CN_Instance].env setObject:model forKey:key];
}

// MARK: └ 其他配置
- (void)setTimeout:(NSTimeInterval)timeout {
    self.sessionManager.requestSerializer.timeoutInterval = timeout;
}

// MARK: └ 请求
+ (instancetype)CN_Request:(void(^)(CN_HTTP *http))request progress:(void(^)(CGFloat))progress success:(void(^)(id))success failure:(void(^)(NSString *))failure {
    // 0 new
    CN_HTTP *http = [[self alloc] init];
    
    // 1 config
    request(http);
    // 1.1 header
    if (http.header) {
        [http.header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [http.sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    // 1.1.1 cookie
    if (http.cookie) {
        NSMutableArray <NSString *>*kvs = [NSMutableArray array];
        [http.cookie enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [kvs addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }];
        [http.sessionManager.requestSerializer setValue:[kvs componentsJoinedByString:@"; "] forHTTPHeaderField:@"Cookie"];
    }
    // 1.2 log
    NSLog(@"\nRequesting...\n[URL]:%@\n[Method]:%@\n[Params]:%@\n[Header]:%@\n[Cookie]:%@",
          http.url,
          [CN_NET_Util CN_StringFromMethod:http.method],
          http.params,
          http.header,
          http.cookie);
    
    // 2 request
    [http _request];
    
    return http;
}

+ (instancetype)CN_Request:(void(^)(CN_HTTP *http))request success:(void(^)(id result))success failure:(void(^)(NSString *errMsg))failure {
    return [self CN_Request:request progress:nil success:success failure:failure];
}

// MARK: └ 撤销请求
- (void)CN_CancelTask {
    [self.task cancel];
}

+ (void)CN_CancelAllTasks {
    [CN_NET_Queue CN_CancelAll];
}

#pragma mark - Private Methods
#pragma mark request method
- (void)_request {
    // request
    switch (self.method) {
        case CN_REQ_METHOD_GET: {
            [self _GET];
        }
            break;
        case CN_REQ_METHOD_POST: {
            [self _POST];
        }
            break;
        case CN_REQ_METHOD_FORM: {
            [self _FORM];
        }
            break;
    }
    // handle task
    [self _handleTask];
}

- (void)_GET {
    self.task = [self.sessionManager GET:self.url parameters:self.params progress:^(NSProgress * _Nonnull downloadProgress) {
        [self _handleProgress:downloadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self _handleSuccess:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self _handleFailure:error];
    }];
}

- (void)_POST {
    self.task = [self.sessionManager POST:self.url parameters:self.params progress:^(NSProgress * _Nonnull uploadProgress) {
        [self _handleProgress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self _handleSuccess:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self _handleFailure:error];
    }];
}

- (void)_FORM {
    self.task = [self.sessionManager POST:self.url parameters:self.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSArray *allNames = [self.formData allKeys];
        for (NSString *name in allNames) {
            [formData appendPartWithFormData:self.formData[name] name:name];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [self _handleProgress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self _handleSuccess:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self _handleFailure:error];
    }];
}

#pragma mark handle task

- (void)_handleTask {
    if (self.requestErrorCount == 0) {
        [CN_NET_Queue CN_AddTask:self.task];
    }
}

#pragma mark handle callback
- (void)_handleProgress:(NSProgress * _Nonnull)progress {
    if (self.callback_progress) {
        CGFloat p = progress.completedUnitCount * 1.0 / progress.totalUnitCount;
        NSLog(@"The current progress is:%lf", p);
        self.callback_progress(p);
    }
}

- (void)_handleSuccess:(id _Nullable)responseObject {
    NSLog(@"\n✅✅✅ Success.");
    id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"\n%@", result);
    if (self.callback_success) {
        self.callback_success(result);
    }
}

- (void)_handleFailure:(NSError * _Nonnull)error {
    _requestErrorCount++;
    if ((error.code == -1009 || error.code == -1005) && _requestErrorCount <= CN_NET_RECONNECT_COUNT) {
        NSLog(@"\n♻️♻️♻️ Try reconnecting...");
        [self _request];
    } else {
        NSLog(@"\n❌❌❌ Failure.\n[Code]:%ld\n[Desc]:%@", error.code, error.localizedDescription);
        if (self.callback_failure) {
            self.callback_failure(error.localizedDescription);
        }
    }
}

#pragma mark - Setter/Getter

- (NSString *)url {
    if (!_url) {    // 完整URL > 全局配置 > 默认
        // URL...
        NSString *scheme;
        NSString *host;
        NSString *port;
        NSString *path;
        
        // 全局配置
        NSString *key_id = NSStringFromClass([self class]);
        CN_NET_ENV type = [CN_NET_Service CN_Instance].type;
        NSString *key_type = [NSString stringWithFormat:@"%lu", (unsigned long)type];
        NSString *key = [NSString stringWithFormat:@"%@_%@", key_id, key_type];
        NSDictionary *envDic = [CN_NET_Service CN_Instance].env;
        CN_NET_Model *model = envDic[key];
        if (type == CN_NET_ENV_LOCAL) {  // 本地环境优先
            CN_NET_Model *env_loc = [CN_NET_Service CN_Instance].env_local;
            scheme = env_loc.scheme;
            host = env_loc.host;
            port = env_loc.port;
        } else {
            // 1 scheme
            if (self.scheme) {
                scheme = [CN_NET_Util CN_StringFromScheme:self.scheme];
            } else if (model.scheme.length) {
                scheme = model.scheme;
            } else {
                scheme = @"http://";
            }
            
            // 2 host
            if (self.host.length) {
                host = self.host;
            } else if (model.host.length) {
                host = model.host;
            } else {
                host = @"";
            }
            
            // 3 port
            if (self.port.length) {
                port = self.port;
            } else if (model.port.length) {
                port = model.port;
            } else {
                port = @"";
            }
            if (port.length) {
                port = [@":" stringByAppendingString:port];
            }
        }
        
        // 4 path
        path = self.path ? : @"";
        
        // 0 URL
        NSString *url = [NSString stringWithFormat:@"%@%@%@%@", scheme, host, port, path];
        return url;
    }
    return _url;
}


#pragma mark - Lazy Loading

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];

        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.requestSerializer.timeoutInterval = 8;
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                     @"application/json",
                                                                     @"text/json",
                                                                     @"text/javascript",
                                                                     @"text/html",
                                                                     @"text/plain",
                                                                     nil];
    }
    return _sessionManager;
}

- (NSDictionary<NSString *,NSObject *> *)params {
    if (!_params) {
        _params = [NSDictionary dictionary];
    }
    return _params;
}

- (NSDictionary <NSString *, NSData *>*)formDatas {
    if (!_formData) {
        _formData = [NSDictionary dictionary];
    }
    return _formData;
}


@end

