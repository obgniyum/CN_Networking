
#import "CN_Network.h"
#import "AFNetworking.h"
#import "CN_NET_Util.h"
#import "CN_NET_Queue.h"
#import "CN_NET_Service.h"
#import "CN_Network+Environment.h"

@interface CN_Network ()

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
@property (nonatomic, copy) void(^progressBlock)(float p);
/**
 成功回调
 */
@property (nonatomic, copy) void(^successBlock)(id data);
/**
 失败回调
 */
@property (nonatomic, copy) void(^failureBlock)(NSError *error);

@end

@implementation CN_Network

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
    [self config_env:CN_NET_ENV_TYPE_DEBUG
          scheme:scheme
            host:host
            port:port];
}

+ (void)CN_TEST:(CN_URL_SCHEME)scheme
           host:(NSString *)host
           port:(NSString *)port {
    [self config_env:CN_NET_ENV_TYPE_TEST
          scheme:scheme
            host:host
            port:port];
}

+ (void)CN_RELEASE:(CN_URL_SCHEME)scheme
              host:(NSString *)host
              port:(NSString *)port {
    [self config_env:CN_NET_ENV_TYPE_RELEASE
          scheme:scheme
            host:host
            port:port];
}

// MARK: └ 其他配置
- (void)setTimeout:(NSTimeInterval)timeout {
    self.sessionManager.requestSerializer.timeoutInterval = timeout;
}

// MARK: └ 请求
+ (instancetype)CN_Request:(void(^)(CN_Network *http))request progress:(void(^)(float pValue))progress success:(void(^)(id result))success failure:(void(^)(NSError *error))failure {
    // 0 new
    CN_Network *http = [[self alloc] init];
    
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
    
    // 1.2 block
    http.progressBlock = progress;
    http.successBlock = success;
    http.failureBlock = failure;
    
    // 2 log
    NSLog(@"\nRequesting...\n[U-R-L]:%@\n[Method]:%@\n[Params]:%@\n[Header]:%@\n[Cookie]:%@", http.url, [CN_NET_Util CN_StringFromMethod:http.method], http.params, http.header, http.cookie);
    
    // 3 request
    [http request];
    
    return http;
}

+ (instancetype)CN_Request:(void(^)(CN_Network *http))request success:(void(^)(id result))success failure:(void(^)(NSError *error))failure {
    return [self CN_Request:request progress:nil success:success failure:failure];
}

// MARK: └ 撤销请求
- (void)CN_CancelTask {
    [self.task cancel];
}

+ (void)CN_CancelAllTasks {
    [CN_NET_Queue CN_CancelAll];
}

// MARK:- Private
// MARK: └ 环境配置
+ (void)config_env:(CN_NET_ENV_TYPE)type
           scheme:(CN_URL_SCHEME)scheme
             host:(NSString *)host
             port:(NSString *)port {
    // 0.1 key
    NSString *key_id = NSStringFromClass(self);
    NSString *key_envType = [NSString stringWithFormat:@"%lu", (unsigned long)type];
    NSString *key = [NSString stringWithFormat:@"%@_%@", key_id, key_envType];
    // 0.2 value
    NSDictionary *env = @{
                          @"scheme" : [CN_NET_Util CN_StringFromScheme:scheme],
                          @"host" : host,
                          @"port" : port
                          };
    // 1 chche
    [CN_NET_Service CN_Instance].envs[key] = env;
}

// MARK: └ 请求
- (void)request {
    // request
    switch (self.method) {
        case CN_REQ_METHOD_GET: {
            [self request_get];
        }
            break;
        case CN_REQ_METHOD_POST: {
            [self request_post];
        }
            break;
        case CN_REQ_METHOD_FORM: {
            [self request_form];
        }
            break;
    }
    // handle task
    [self task_cache];
}

- (void)request_get {
    self.task = [self.sessionManager GET:self.url parameters:self.params progress:^(NSProgress * _Nonnull downloadProgress) {
        [self response_progress:downloadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self response_success:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self response_failure:error];
    }];
}

- (void)request_post {
    self.task = [self.sessionManager POST:self.url parameters:self.params progress:^(NSProgress * _Nonnull uploadProgress) {
        [self response_progress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self response_success:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self response_failure:error];
    }];
}

- (void)request_form {
    self.task = [self.sessionManager POST:self.url parameters:self.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSArray *allNames = [self.formData allKeys];
        for (NSString *name in allNames) {
            [formData appendPartWithFormData:self.formData[name] name:name];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [self response_progress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self response_success:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self response_failure:error];
    }];
}

// MARK: └ 任务
- (void)task_cache {
    if (self.requestErrorCount == 0) {
        [CN_NET_Queue CN_AddTask:self.task];
    }
}

// MARK: └ 响应
- (void)response_progress:(NSProgress * _Nonnull)progress {
    float p = progress.completedUnitCount * 1.0 / progress.totalUnitCount;
//    NSLog(@"The current progress is:%lf", p);
    [self callback_progress:p];
}

- (void)response_success:(id _Nullable)responseObject {
    NSLog(@"\n✅✅✅ Success.");
    id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"\n%@", result);
    [self callback_success:result];
}

- (void)response_failure:(NSError * _Nonnull)error {
    _requestErrorCount++;
    if ((error.code == -1009 || error.code == -1005) && _requestErrorCount <= CN_NET_RECONNECT_COUNT) {
        NSLog(@"\n♻️♻️♻️ Try reconnecting...");
        [self request];
    } else {
        NSLog(@"\n❌❌❌ Failure.\n[Code]:%ld\n[Desc]:%@", error.code, error.localizedDescription);
        [self callback_failure:error];
    }
}

// MARK: └ 回调
- (void)callback_progress:(float)progress {
    if (self.progressBlock) {
        self.progressBlock(progress);
    }
}

- (void)callback_success:(id _Nullable)result {
    if (self.successBlock) {
        self.successBlock(result);
    }
}

- (void)callback_failure:(NSError * _Nonnull)error {
    if (self.failureBlock) {
        self.failureBlock(error);
    }
}

#pragma mark - Setter/Getter

- (NSString *)url {
    // 优先级： 完整URL（1） > 配置（2） > 默认（3）
    if (!_url) {    //
        // URL...
        NSString *scheme = @"";
        NSString *host = @"";
        NSString *port = @"";
        NSString *path = @"";
        
        // 配置
        CN_NET_ENV_TYPE type = [CN_NET_Service CN_Instance].type;
    
        if (type == CN_NET_ENV_TYPE_CUSTOM) {  // 自定义配置（2.1）
            NSDictionary *env_custom = [CN_NET_Service CN_Instance].env_custom;
            scheme = env_custom[@"scheme"] ? [NSString stringWithFormat:@"%@://", env_custom[@"scheme"]]: @"";
            host = env_custom[@"host"] ?: @"";
            port = env_custom[@"port"] ? [NSString stringWithFormat:@":%@", env_custom[@"port"]] : @"";
        } else {                                // 全局配置（2.2）
            
            NSString *key = [self CN_KeyWithEnvType:type];
            NSDictionary *envs = [CN_NET_Service CN_Instance].envs;
            NSDictionary *env = envs[key];
            
            if (!env) {
                NSLog(@"❌❌❌ 请配置环境！！！");
            } else {
                // url.scheme
                NSString *url_scheme = env[@"scheme"];
                if (url_scheme.length) {
                    scheme = [NSString stringWithFormat:@"%@://", url_scheme];
                } else {
                    NSLog(@"❌❌❌ 请配置 scheme !!!");
                }
                
                // url.host
                NSString *url_host = env[@"host"];
                if (url_host.length) {
                    host = url_host;
                } else {
                    NSLog(@"❌❌❌ 请配置 host !!!");
                }
                
                // url.port
                NSString *url_port = env[@"port"];
                if (url_port.length) {
                    port = [NSString stringWithFormat:@":%@", url_port];
                } else {
                    NSLog(@"❌❌❌ 请配置 port !!!");
                }
            }
        }
        
        // url.path
        if (self.path.length) {
            path = self.path;
        }
        
        // URL
        return [NSString stringWithFormat:@"%@%@%@%@", scheme, host, port, path];
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

