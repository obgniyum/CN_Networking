//
//  Share.h
//  CN_Networking_Example
//
//  Created by Obgniyum on 2018/7/25.
//  Copyright © 2018年 obgniyum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CN_NET_Float : NSObject

+ (instancetype)CN_Instance;

- (void)cn_show:(BOOL)show;

@property (nonatomic, strong) NSMutableArray <NSMutableDictionary *>*dataSource;

@end
