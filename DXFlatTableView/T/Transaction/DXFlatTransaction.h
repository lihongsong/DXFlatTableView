//
//  DXFlatTransaction.h
//  DXFlatTableView
//
//  Created by yoser on 2017/10/10.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DXFlatTransactionState){
    DXFlatTransactionStateCancel   = 0,
    DXFlatTransactionStateRunning  = 1,
    DXFlatTransactionStateComplete = 2,
    DXFlatTransactionStateWaiting  = 3,
};

@class DXFlatTransaction;

typedef void (^DXAsyncTransactionCompletionBlock) (DXFlatTransaction *transaction, BOOL isCancel);
typedef void (^DXAsyncTransactionOperationCompletionBlock) (BOOL isCancel);

@interface DXFlatTransaction : NSObject

@property (assign, nonatomic) DXFlatTransactionState state;

- (DXFlatTransaction *)initWithCallbackQueue:(dispatch_queue_t)callbackQueue
                             completionBlock:(DXAsyncTransactionCompletionBlock)completionBlock;

/**
 给当前的事件添加一个操作

 @param target 目标
 @param selector 执行方法
 @param object 参数
 @param complete 完成的回调
 */
- (void)addOperationWithTarget:(id)target
                      selector:(SEL)selector
                        object:(id)object
                      complete:(DXAsyncTransactionOperationCompletionBlock)complete;

- (void)commit;

- (void)cancel;

@end
