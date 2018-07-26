
#import <Foundation/Foundation.h>
#import "CN_NET_Constant.h"

@interface CN_NET_Util : NSObject

/**
 协议转化字符串

 @param scheme -
 @return -
 */
+ (NSString *)CN_StringFromScheme:(CN_URL_SCHEME)scheme;

/**
 请求方法转化字符串

 @param method -
 @return -
 */
+ (NSString *)CN_StringFromMethod:(CN_REQ_METHOD)method;

@end
