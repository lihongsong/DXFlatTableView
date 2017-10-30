
//
//  DXFlatTool.m
//  DXFlatTableView
//
//  Created by yoser on 2017/10/12.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import "DXFlatTool.h"

@implementation DXFlatTool

+ (CGRect)absoluteRect:(CGRect)base withRect:(CGRect)rect{
    
    CGFloat x = rect.origin.x + base.origin.x;
    CGFloat y = rect.origin.y + base.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGRect absoluteRect = CGRectMake(x, y, width, height);
    
    return absoluteRect;
}

@end
