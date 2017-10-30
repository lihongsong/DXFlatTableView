//
//  DXFlatTableViewLayout.h
//  DXFlatTableView
//
//  Created by yoser on 2017/10/12.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXFlatAttributed;

@protocol DXFlatTableViewLayout <NSObject>

@required
- (NSArray <DXFlatAttributed *> *)layout:(CGRect)frame;

@end

