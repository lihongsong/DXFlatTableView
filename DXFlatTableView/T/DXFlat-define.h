//
//  DXFlat-define.h
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#ifndef DXFlat_define_h
#define DXFlat_define_h

#import <UIKit/UIKit.h>

typedef BOOL (^DXAsyncDisplayIsCanclledBlock)(void);
typedef void (^DXAsyncDisplayWillDisplayBlock)(CALayer *layer);
typedef void (^DXAsyncDisplayBlock)(CGContextRef context, CGSize size, BOOL isCancel);
typedef void (^DXAsyncDisplayDidDisplayBlock)(CALayer *layer, BOOL finished);
typedef void (^DXAsyncCompleteBlock)(void);

#endif /* DXFlat_define_h */
