//
//  CALayer+DXFlatTransaction.h
//  DXFlatTableView
//
//  Created by yoser on 2017/10/10.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DXFlatTransaction.h"

@protocol DXFlatTransactionLayerDelegate <NSObject>

- (void)transactionContainerWillBeginTransaction:(DXFlatTransaction *)transaction;

- (void)transactionContainerDidCompleteTransaction:(DXFlatTransaction *)transaction;

@end

@interface CALayer (DXFlatTransaction)<DXFlatTransactionLayerDelegate>

/**
 保存所有transaction事物对象
 */
@property (strong, nonatomic, readonly) NSHashTable *transactions;

/**
 当前的transaction事物对象
 */
@property (strong, nonatomic) DXFlatTransaction *currentTransaction;

/**
 创建一个transaction对象并添加到transactions中

 @return transaction实例
 */
- (DXFlatTransaction *)transactionInstance;

@end
