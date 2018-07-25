
#import "CN_NET_Service.h"

@interface CN_NET_Service()

@end

@implementation CN_NET_Service

+ (instancetype)CN_Instance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] CN_Instance];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone{
    return [[self class] CN_Instance];
}

#pragma mark - Setter/Getter

- (void)setType:(CN_NET_ENV)type {
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:kCN_NET_ENV_TYPE];
}

- (CN_NET_ENV)type {
    CN_NET_ENV type = [[NSUserDefaults standardUserDefaults] integerForKey:kCN_NET_ENV_TYPE];
    return type;
}

- (void)setEnv_local:(CN_NET_Model *)env_local {
    [[NSUserDefaults standardUserDefaults] setObject:env_local.scheme forKey:kCN_NET_ENV_LOC_SCHEME];
    [[NSUserDefaults standardUserDefaults] setObject:env_local.host forKey:kCN_NET_ENV_LOC_HOST];
    [[NSUserDefaults standardUserDefaults] setObject:env_local.port forKey:kCN_NET_ENV_LOC_PORT];
}

- (CN_NET_Model *)env_local {
    CN_NET_Model *model = [[CN_NET_Model alloc] init];
    model.scheme = [[NSUserDefaults standardUserDefaults] objectForKey:kCN_NET_ENV_LOC_SCHEME] ? : @"";
    model.host = [[NSUserDefaults standardUserDefaults] objectForKey:kCN_NET_ENV_LOC_HOST] ? : @"";
    model.port = [[NSUserDefaults standardUserDefaults] objectForKey:kCN_NET_ENV_LOC_PORT] ? : @"";
    return model;
}

#pragma mark - Lazy

- (NSMutableDictionary<NSString *,CN_NET_Model *> *)env {
    if (!_env) {
        _env = [NSMutableDictionary dictionary];
    }
    return _env;
}

@end
