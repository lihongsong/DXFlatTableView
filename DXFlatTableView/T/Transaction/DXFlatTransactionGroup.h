//
//  DXFlatTransactionGroup.h
//  DXFlatTableView
//
//  Created by yoser on 2017/10/10.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXFlatTransactionGroup : NSObject

+ (instancetype)shared;

/**
 添加一个新的绘图layer
 */
- (void)addLayersContainers:(CALayer *)layer;

/**
 提交所有绘图事件
 */
- (void)commit;

@end
