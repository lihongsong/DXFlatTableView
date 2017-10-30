//
//  DXFlatTextAttributed.m
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import "DXFlatTextAttributed.h"

@implementation DXFlatTextAttributed

- (id)copyWithZone:(NSZone *)zone{
    DXFlatTextAttributed *temp = [super copyWithZone:zone];
    temp.attributeString = self.attributeString;
    return temp;
}

- (DXFlatAttributedDrawer *)drawer{
    return [DXFlatTextAttributedDrawer new];
}

@end
