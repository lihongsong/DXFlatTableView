//
//  DXFlatAttributedDrawer.h
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXFlatAttributed;

@protocol DXFlatAttributedDrawerDelegate <NSObject>

- (void)draw:(DXFlatAttributed *)attribute
     context:(CGContextRef)contenxt
        rect:(CGRect)rect;

@end

@interface DXFlatAttributedDrawer : NSObject<DXFlatAttributedDrawerDelegate>

@end
