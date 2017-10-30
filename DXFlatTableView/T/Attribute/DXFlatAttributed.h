//
//  DXFlatAttributed.h
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DXFlatTextAttributedDrawer.h"

typedef void (^DXFlatAttributeTouchCallBack)(DXFlatAttributed *attribute);

@interface DXFlatAttributed : NSObject<NSCopying>

@property (strong, nonatomic) UIColor *tinkColor;

@property (strong, nonatomic) UIColor *backgroundColor;

// 这里使用的都是相对 frame
@property (assign, nonatomic) CGRect frame;

// 暂时先不添加这些花里胡哨
//@property (assign, nonatomic) CGFloat cornerRaiuds;
////
//@property (strong, nonatomic) UIColor *borderColor;
////
//@property (assign, nonatomic) CGFloat borderWidth;

@property (strong, nonatomic) DXFlatAttributeTouchCallBack touchCallBack;

- (BOOL)userInteractionEnabled;

- (DXFlatAttributedDrawer *)drawer;

@end
