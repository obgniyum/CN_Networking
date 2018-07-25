
#ifndef CN_NET_Constant_h
#define CN_NET_Constant_h

/**
 闪断重连次数
 */
static const NSInteger CN_NET_RECONNECT_COUNT = 3;

/**
 网络环境

 - CN_NET_ENV_DEBUG:    开发
 - CN_NET_ENV_TEST:     测试
 - CN_NET_ENV_LOCAL:    本地（临时调试使用）
 - CN_NET_ENV_RELEASE:  线上
 */
typedef NS_ENUM(NSUInteger, CN_NET_ENV) {
    CN_NET_ENV_DEBUG,      // -D
    CN_NET_ENV_TEST,
    CN_NET_ENV_LOCAL,
    CN_NET_ENV_RELEASE
};

/**
 请求方法

 - CN_REQ_METHOD_GET: GET
 - CN_REQ_METHOD_POST: POST
 */
typedef NS_ENUM(NSUInteger, CN_REQ_METHOD) {
    CN_REQ_METHOD_GET,
    CN_REQ_METHOD_POST, // -D
    CN_REQ_METHOD_FORM,
};

/**
 请求协议

 - CN_URL_SCHEME_HTTP:  HTTP
 - CN_URL_SCHEME_HTTPS: HTTPS
 */
typedef NS_ENUM(NSUInteger, CN_URL_SCHEME) {
    CN_URL_SCHEME_HTTP = 1, // -D
    CN_URL_SCHEME_HTTPS,
};


static NSString *kCN_NET_ENV_TYPE = @"kCN_NET_ENV_TYPE";  //
static NSString *kCN_NET_ENV_LOC_SCHEME = @"kCN_NET_ENV_LOC_SCHEME";
static NSString *kCN_NET_ENV_LOC_HOST = @"kCN_NET_ENV_LOC_HOST";
static NSString *kCN_NET_ENV_LOC_PORT = @"kCN_NET_ENV_LOC_PORT";

#endif
