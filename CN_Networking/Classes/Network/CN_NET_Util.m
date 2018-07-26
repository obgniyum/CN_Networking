

#import "CN_NET_Util.h"

@implementation CN_NET_Util

+ (NSString *)CN_StringFromScheme:(CN_URL_SCHEME)scheme {
    switch (scheme) {
        case CN_URL_SCHEME_HTTP:
            return @"http";
            break;
        case CN_URL_SCHEME_HTTPS:
            return @"https";
            break;
    }
}

+ (NSString *)CN_StringFromMethod:(CN_REQ_METHOD)method {
    switch (method) {
        case CN_REQ_METHOD_GET:
            return @"GET";
            break;
        case CN_REQ_METHOD_POST:
            return @"POST";
            break;
        case CN_REQ_METHOD_FORM:
            return @"FORM";
            break;
    }
}


@end
