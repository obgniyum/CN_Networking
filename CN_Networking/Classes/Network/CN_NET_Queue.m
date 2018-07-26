

#import "CN_NET_Queue.h"

@interface CN_NET_Queue ()

@property (nonatomic, strong) NSMutableArray <NSURLSessionDataTask *>*tasks;

@end

@implementation CN_NET_Queue

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

#pragma mark - Public

+ (void)CN_AddTask:(NSURLSessionDataTask *)task {
    CN_NET_Queue *queue = [[CN_NET_Queue alloc] init];
    for (NSURLSessionDataTask *t in queue.tasks) {
        if ([task isEqual:t]) {
            return;
        }
    }
    [queue.tasks addObject:task];
}

+ (void)CN_CancelAll {
    CN_NET_Queue *queue = [[CN_NET_Queue alloc] init];
    for (NSURLSessionDataTask *task in queue.tasks) {
        [task cancel];
    }
}

#pragma mark - Lazy

- (NSMutableArray *)tasks {
    if (!_tasks) {
        _tasks = [NSMutableArray array];
    }
    return _tasks;
}

@end
