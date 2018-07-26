
#import <Foundation/Foundation.h>
#import "CN_NET_Constant.h"

@interface CN_NET_Service : NSObject

/**
 单例

 @return -
 */
+ (instancetype)CN_Instance;

/**
 环境类型(持久化)
 */
@property (nonatomic, assign) CN_NET_ENV_TYPE type;

/**
 URL配置-非自定义
 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSDictionary *>*envs;

/**
 URL配置-自定义(持久化)
 */
@property (nonatomic, strong) NSDictionary *env_custom;

@end 
