
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

- (void)setType:(CN_NET_ENV_TYPE)type {
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:kCN_NET_ENV_TYPE];
}

- (CN_NET_ENV_TYPE)type {
    CN_NET_ENV_TYPE type = [[NSUserDefaults standardUserDefaults] integerForKey:kCN_NET_ENV_TYPE];
    return type;
}

- (void)setEnv_custom:(NSDictionary *)env_custom {
    [[NSUserDefaults standardUserDefaults] setObject:env_custom forKey:kCN_NET_ENV_TYPE_CUSTOM];
}

- (NSDictionary *)env_custom {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:kCN_NET_ENV_TYPE_CUSTOM];
}

#pragma mark - Lazy

- (NSMutableDictionary<NSString *,NSDictionary *> *)envs {
    if (!_envs) {
        _envs = [NSMutableDictionary dictionary];
    }
    return _envs;
}

@end
