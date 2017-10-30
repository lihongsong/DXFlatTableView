//
//  DXFlatImageAttributedDrawer.m
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import "DXFlatImageAttributedDrawer.h"

#import "DXFlatImageAttributed.h"

#import "DXFlatTool.h"

@implementation DXFlatImageAttributedDrawer

- (void)draw:(DXFlatImageAttributed *)attribute context:(CGContextRef)contenxt rect:(CGRect)rect{
    
    [super draw:attribute context:contenxt rect:rect];
    
    CGRect absoluteRect = [DXFlatTool absoluteRect:rect withRect:attribute.frame];
    
    // 保存图形上下文栈
    CGContextSaveGState(contenxt);
    
    // 绘制图像
    //    CGContextDrawImage(contenxt, absoluteRect, attribute.image.CGImage);
    [attribute.image drawInRect:absoluteRect blendMode:kCGBlendModeNormal alpha:1];
    
    // 释放图形上下文
    CGContextRestoreGState(contenxt);
}

@end
