//
//  DXFlatTextAttributedDrawer.m
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import "DXFlatTextAttributedDrawer.h"

#import "DXFlatTextAttributed.h"

#import "DXFlatTool.h"

@implementation DXFlatTextAttributedDrawer

- (void)draw:(DXFlatTextAttributed *)attribute context:(CGContextRef)contenxt rect:(CGRect)rect{

    [super draw:attribute context:contenxt rect:rect];
    
    CGRect absoluteRect = [DXFlatTool absoluteRect:rect withRect:attribute.frame];
    
    // 保存图形上下文栈
    CGContextSaveGState(contenxt);
    
    // 绘制文本
    [attribute.attributeString drawInRect:absoluteRect];
    
    // 释放图形上下文
    CGContextRestoreGState(contenxt);
}

@end
