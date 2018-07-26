
#import <Foundation/Foundation.h>
#import "CN_NET_Constant.h"
#import "CN_NET_URL.h"

@interface CN_NET_Service : NSObject

/**
 单例
 
 @return -
 */
+ (instancetype)CN_Instance;

/**
 环境类型
 */
@property (nonatomic, assign) CN_NET_ENV type;

/**
 环境配置信息
 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, CN_NET_URL *>*env;

/**
 本地环境配置信息
 */
@property (nonatomic, strong) CN_NET_URL *env_local;

@end 
