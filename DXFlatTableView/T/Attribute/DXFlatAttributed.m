//
//  DXFlatAttributed.m
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import "DXFlatAttributed.h"
#import "DXFlatAttributedDrawer.h"

@implementation DXFlatAttributed

- (id)copyWithZone:(NSZone *)zone{
    return self;
//    DXFlatAttributed *temp = [[self class] new];
//    temp.tinkColor = self.tinkColor;
//    temp.backgroundColor = self.tinkColor;
//    temp.frame = self.frame;
//    temp.touchCallBack = self.touchCallBack;
//    return temp;
}

- (BOOL)userInteractionEnabled{
    return self.touchCallBack != nil;
}

- (DXFlatAttributedDrawer *)drawer{
    return [DXFlatAttributedDrawer new];
}

@end
