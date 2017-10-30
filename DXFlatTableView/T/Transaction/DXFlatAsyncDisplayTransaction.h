//
//  DXFlatAsyncDisplayTransaction.h
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DXFlat-define.h"

@class DXFlatAsyncDisplayTransaction;

@protocol DXFlatAsyncDisplayTransactionCreater <NSObject>

- (DXFlatAsyncDisplayTransaction *)asyncDisplayTransaction;

@end

@interface DXFlatAsyncDisplayTransaction : NSObject

@property (copy, nonatomic) DXAsyncDisplayDidDisplayBlock didDisplayBlock;

@property (copy, nonatomic) DXAsyncDisplayBlock displayBlock;

@property (copy, nonatomic) DXAsyncDisplayWillDisplayBlock willDisplayBlock;

@end
