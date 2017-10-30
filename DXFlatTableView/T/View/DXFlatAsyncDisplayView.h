//
//  DXFlatAsyncDisplayView.h
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXFlatAttributed;

@interface DXFlatAsyncDisplayView : UIView

/**
 添加绘制模型

 @param attribute 绘制模型
 @param rect 模型所在的区域
 */
- (void)addAttribute:(DXFlatAttributed *)attribute inRect:(CGRect)rect;

- (void)addAttributes:(NSArray <DXFlatAttributed *> *)attributes inRect:(CGRect)rect;

- (void)clearAttribute;

@end
