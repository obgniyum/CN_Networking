//
//  CN_Network+Environment.m
//  CN_Networking
//
//  Created by Obgniyum on 2018/7/26.
//

#import "CN_Network+Environment.h"

@implementation CN_Network (Environment)

- (NSString *)CN_KeyWithEnvType:(CN_NET_ENV_TYPE)type {
    NSString *key_id = NSStringFromClass([self class]);
    NSString *key_type = [NSString stringWithFormat:@"%lu", (unsigned long)type];
    NSString *key = [NSString stringWithFormat:@"%@_%@", key_id, key_type];
    return key;
}

@end
