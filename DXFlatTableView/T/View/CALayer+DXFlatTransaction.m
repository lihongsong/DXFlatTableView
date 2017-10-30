//
//  CALayer+DXFlatTransaction.m
//  DXFlatTableView
//
//  Created by yoser on 2017/10/10.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import "CALayer+DXFlatTransaction.h"

#import "DXFlatTransactionGroup.h"

#import <objc/runtime.h>

static NSString *KcurrentTransaction = @"KcurrentTransaction";

static NSString *Ktransactions = @"Ktransactions";

@interface CALayer()

@property (strong, nonatomic) NSHashTable *transactions;

@end

@implementation CALayer (DXFlatTransaction)

- (DXFlatTransaction *)currentTransaction{
    return objc_getAssociatedObject(self, &KcurrentTransaction);
}

- (void)setCurrentTransaction:(DXFlatTransaction *)currentTransaction{
    objc_setAssociatedObject(self, &KcurrentTransaction, currentTransaction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSHashTable *)transactions{
    return objc_getAssociatedObject(self, &Ktransactions);
}

- (void)setTransactions:(NSHashTable *)transactions{
    objc_setAssociatedObject(self, &Ktransactions, transactions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)transactionContainerWillBeginTransaction:(DXFlatTransaction *)transaction{
    id delegate = self.delegate;
    if([delegate respondsToSelector:@selector(transactionContainerWillBeginTransaction:)]){
        [delegate transactionContainerWillBeginTransaction:transaction];
    }
}

- (void)transactionContainerDidCompleteTransaction:(DXFlatTransaction *)transaction{
    id delegate = self.delegate;
    if([delegate respondsToSelector:@selector(transactionContainerDidCompleteTransaction:)]){
        [delegate transactionContainerDidCompleteTransaction:transaction];
    }
}


/**
 FIXME: 实现只执行最新的 Transaction ,对于当前正在执行的 Transaction 进行cancel操作
 并且生成一个新的 Transaction ,并且将 currentTransaction 指向它.
 */
- (DXFlatTransaction *)transactionInstance{
    
    DXFlatTransaction *transaction = self.currentTransaction;
    
    if(transaction != nil){
        if(transaction.state == DXFlatTransactionStateRunning){
            [transaction cancel];
        }
        return transaction;
    }else{
        if(self.transactions == nil){
            self.transactions = [NSHashTable hashTableWithOptions:NSPointerFunctionsObjectPointerPersonality];
        }
        
        __weak __typeof(self) weakSelf = self;
        transaction = [[DXFlatTransaction alloc] initWithCallbackQueue:dispatch_get_main_queue()
                                                                          completionBlock:^(DXFlatTransaction *transaction, BOOL isCancel) {
                                                                              __strong __typeof(self) strongSelf = weakSelf;
                                                                              strongSelf.currentTransaction = nil;
                                                                              [strongSelf.transactions removeAllObjects];
                                                                              [strongSelf transactionContainerDidCompleteTransaction:transaction];
                                                                          }];
        // 保存最新的事件 在迭代中只执行最新的事件
        self.currentTransaction = transaction;
        [self transactionContainerWillBeginTransaction:transaction];
        [self.transactions addObject:transaction];
        
        // 因为使用NSHashTable 所以对于重复添加的layer也只会保留一份引用
        [[DXFlatTransactionGroup shared] addLayersContainers:self];
        return transaction;
    }
}

@end
