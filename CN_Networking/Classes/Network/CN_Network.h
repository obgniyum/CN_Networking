
#import <Foundation/Foundation.h>
#import "CN_NET_Protocol.h"
#import "CN_NET_Constant.h"

@interface CN_Network : NSObject <CN_NET_Protocol>

// MARK:- Request framework
/**
 Request framework
 
 ps: you don't have to use weakself in request block
 
 @param request request object callback in order to set request message
 @param success success callback
 @param failure failure callback
 @return self
 */
+ (instancetype)CN_Request:(void(^)(CN_Network *http))request success:(void(^)(id result))success failure:(void(^)(NSString *errMsg))failure;

/**
 Request framework (progress)
 
 ps: you don't have to use weakself in request block
 
 @param request request object callback in order to set request message
 @param progress progress callback
 @param success success callback
 @param failure failure callback
 @return self
 */
+ (instancetype)CN_Request:(void(^)(CN_Network *http))request progress:(void(^)(CGFloat))progress success:(void(^)(id))success failure:(void(^)(NSString *))failure;

// MARK:- Request Configuration
@property (nonatomic, assign) CN_REQ_METHOD method; /** URL */
/** URL */
@property (nonatomic, copy) NSString *url;
/** url.scheme */
//@property (nonatomic, assign) CN_URL_SCHEME scheme;
///** url.host */
//@property (nonatomic, copy) NSString *host;
///** url.port */
//@property (nonatomic, copy) NSString *port;
/** url.path */
@property (nonatomic, copy) NSString *path;

/** params */
@property (nonatomic, strong) NSDictionary <NSString *, NSObject *>*params;
/** formData */
@property (nonatomic, strong) NSDictionary <NSString *, NSData *>*formData;

/** timeout */
@property (nonatomic, assign) NSTimeInterval timeout;

/** header */
@property (nonatomic, strong) NSDictionary <NSString *, NSString *>*header;

/** header.cookie */
@property (nonatomic, strong) NSDictionary <NSString *, NSString *>*cookie;
// NSArray <NSHTTPCookie *>*cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;

// MARK:- Request Cancel
/**
 Cancel task
 */
- (void)CN_CancelTask;

/**
 Cancel all tasks
 
 ps: you should callback this method at `-viewWillDisappear`, if you want to cancel all tasks in current viewcontroller.
 */
+ (void)CN_CancelAllTasks;

@end

