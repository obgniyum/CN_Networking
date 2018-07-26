

#import <Foundation/Foundation.h>
#import "CN_NET_Constant.h"

@protocol CN_NET_Protocol <NSObject>

@optional

/**
 开发环境

 @param scheme scheme
 @param host scheme
 @param port port
 */
+ (void)CN_DEBUG:(CN_URL_SCHEME)scheme
            host:(NSString *)host
            port:(NSString *)port;

/**
 测试环境

 @param scheme scheme
 @param host host
 @param port port
 */
+ (void)CN_TEST:(CN_URL_SCHEME)scheme
           host:(NSString *)host
           port:(NSString *)port;

/**
 发布环境

 @param scheme scheme
 @param host host
 @param port port
 */
+ (void)CN_RELEASE:(CN_URL_SCHEME)scheme
              host:(NSString *)host
              port:(NSString *)port;

@end
