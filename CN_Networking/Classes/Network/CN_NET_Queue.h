
#import <Foundation/Foundation.h>

@interface CN_NET_Queue : NSObject

/**
 单例

 @return -
 */
+ (instancetype)CN_Instance;

/**
 添加任务

 @param task -
 */
+ (void)CN_AddTask:(NSURLSessionDataTask *)task;

/**
 取消所有任务
 */
+ (void)CN_CancelAll;

@end
