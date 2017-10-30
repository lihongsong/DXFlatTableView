//
//  DXFlatTransactionGroup.m
//  DXFlatTableView
//
//  Created by yoser on 2017/10/10.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import "DXFlatTransactionGroup.h"
#import "CALayer+DXFlatTransaction.h"

static void _transactionGroupRunLoopObserverCallback(CFRunLoopObserverRef observer,
                                                     CFRunLoopActivity activity,
                                                     void* info);

static void _transactionGroupRunLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void* info) {
    DXFlatTransactionGroup* group = (__bridge DXFlatTransactionGroup *)info;
    [group commit];
}

@interface DXFlatTransactionGroup()

@property (strong, nonatomic) NSHashTable *layersContainers;

@end

@implementation DXFlatTransactionGroup

static DXFlatTransactionGroup *group;
static CFRunLoopObserverRef observer;

+ (instancetype)shared{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        group = [DXFlatTransactionGroup new];
        group.layersContainers = [NSHashTable hashTableWithOptions:NSPointerFunctionsObjectPointerPersonality];
        [DXFlatTransactionGroup registerTransactionGroupAsMainRunloopObserver:group];
    });
    return group;
}

+ (void)registerTransactionGroupAsMainRunloopObserver:(DXFlatTransactionGroup *)transactionGroup{
    
    CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();

    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)transactionGroup,  // 观察runloop中所传递的消息
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    //    activity：runloop当前的运行阶段。
    CFOptionFlags activities = (kCFRunLoopBeforeWaiting | kCFRunLoopExit);
    
    //    _transactionGroupRunLoopObserverCallback：回调的block。
    //
    //    这个block有两个参数：
    //
    //    observer：正在运行的run loop observe。
    //    activity: 回调所处的状态 (kCFRunLoopBeforeWaiting | kCFRunLoopExit)
    
    observer = CFRunLoopObserverCreate(NULL,
                                       activities,
                                       YES,
                                       INT_MAX,
                                       &_transactionGroupRunLoopObserverCallback,
                                       &context);
    CFRunLoopAddObserver(currentRunLoop, observer, kCFRunLoopCommonModes);
    CFRelease(observer);
}

- (void)addLayersContainers:(CALayer *)layer{
    
    [_layersContainers addObject:layer];
    
}

- (void)commit{
    
    for (CALayer *layer in self.layersContainers) {
        // 一定要确保 currentTransaction 是栈顶的事件
        [layer.currentTransaction commit];
    }
    
}

@end

