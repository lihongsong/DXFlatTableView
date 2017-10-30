//
//  DXFlatTransaction.m
//  DXFlatTableView
//
//  Created by yoser on 2017/10/10.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import "DXFlatTransaction.h"

#import <objc/message.h>

@interface DXFlatTransactionOperation : NSObject

@property (strong, nonatomic) id target;

@property (assign, nonatomic) SEL selector;

@property (strong, nonatomic) id object;

@property (copy, nonatomic) DXAsyncTransactionOperationCompletionBlock completionBlock;

- (void)resume:(BOOL)isCancel;

@end

@implementation DXFlatTransactionOperation

- (void)resume:(BOOL)isCancel{
    
    if (!isCancel) {
        ((void(*)(id,SEL,id))objc_msgSend)(_target, _selector, _object);
    }
    
    _target = nil;
    _selector = nil;
    _object = nil;
    
    _completionBlock(isCancel);
    
}

@end

@interface DXFlatTransaction()

@property (strong, nonatomic) dispatch_queue_t callbackQueue;

@property (copy, nonatomic) DXAsyncTransactionCompletionBlock completeBlock;

@property (strong, nonatomic) NSMutableArray <DXFlatTransactionOperation *> *operations;

@property (assign, nonatomic) BOOL isCancel;

@end

@implementation DXFlatTransaction

- (DXFlatTransaction *)initWithCallbackQueue:(dispatch_queue_t)callbackQueue
                             completionBlock:(DXAsyncTransactionCompletionBlock)completionBlock{
    
    DXFlatTransaction *transaction = [DXFlatTransaction new];
    transaction.callbackQueue = callbackQueue;
    transaction.completeBlock = [completionBlock copy];
    return transaction;
}

- (void)addOperationWithTarget:(id)target
                      selector:(SEL)selector
                        object:(id)object
                      complete:(DXAsyncTransactionOperationCompletionBlock)complete{
    
    _state = DXFlatTransactionStateWaiting;
    
    DXFlatTransactionOperation *operation = [DXFlatTransactionOperation new];
    operation.target = target;
    operation.selector = selector;
    operation.object = object;
    operation.completionBlock = [complete copy];
    [self.operations addObject:operation];
}

- (void)commit{
    
    _state = DXFlatTransactionStateRunning;

    if(_operations.count == 0){
        [self complete];
    }else{
        for(DXFlatTransactionOperation *operation in _operations){
            [operation resume:self.isCancel];
        }
        
        if(!self.isCancel){
            [self complete];
        }
    }
}

- (void)complete{
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async(_callbackQueue, ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        // FIXME: 这里self为什么被释放了
        if(strongSelf){
            strongSelf.completeBlock(strongSelf, strongSelf.isCancel);
        }
    });
    
    [self.operations removeAllObjects];
    
    _state = DXFlatTransactionStateComplete;
}

- (BOOL)isCancel{
    return _state == DXFlatTransactionStateCancel;
}

- (void)cancel{
    _state = DXFlatTransactionStateCancel;
}

#pragma mark GET & SET
- (NSMutableArray<DXFlatTransactionOperation *> *)operations{
    if(_operations == nil){
        _operations = [NSMutableArray array];
    }
    return _operations;
}

@end
