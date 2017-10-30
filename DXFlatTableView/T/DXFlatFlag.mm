//
//  DXFlatFlag.m
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import "DXFlatFlag.h"

#import <stdatomic.h>

#import <stdio.h>

@interface DXFlatFlag()

@property (assign, nonatomic) atomic_uint_least32_t cnt;

@end

@implementation DXFlatFlag

- (instancetype)init{
    if(self = [super init]){
        self.cnt = ATOMIC_VAR_INIT(0);
    }
    return self;
}

- (uint32_t)currentValue{
    return _cnt;
}

- (void)raiseValue{
    atomic_fetch_add(&_cnt, 1);
}

@end
