//
//  DXFlatAsyncDisplayLayer.h
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DXFlat-define.h"

@interface DXFlatAsyncDisplayLayer : CALayer

@property (assign, nonatomic) BOOL asynchronously;

/**
 *  立即绘制
 */
- (void)displayImmediately;

/**
 *  取消异步绘制
 */
- (void)cancelAsyncDisplay;

@end
