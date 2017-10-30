//
//  DXFlatAttributedDrawer.m
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import "DXFlatAttributedDrawer.h"

#import "DXFlatTool.h"

#import "DXFlatAttributed.h"

@implementation DXFlatAttributedDrawer

- (void)draw:(DXFlatAttributed *)attribute
     context:(CGContextRef)contenxt
        rect:(CGRect)rect{
    
    CGRect absoluteRect = [DXFlatTool absoluteRect:rect withRect:attribute.frame];
    
    // 保存图形上下文栈
    CGContextSaveGState(contenxt);
    
    // 绘制背景
    if (attribute.backgroundColor != nil){
        [attribute.backgroundColor set];
        CGContextAddRect(contenxt, absoluteRect);
        CGContextFillPath(contenxt);
    }
    
    // 释放图形上下文
    CGContextRestoreGState(contenxt);
}

@end
