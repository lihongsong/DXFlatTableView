//
//  DXFlatImageAttributed.m
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import "DXFlatImageAttributed.h"

#import "DXFlatImageAttributedDrawer.h"

@implementation DXFlatImageAttributed

- (id)copyWithZone:(NSZone *)zone{
    DXFlatImageAttributed *attribute = [super copyWithZone:zone];
    attribute.image = self.image;
    return attribute;
}

- (DXFlatAttributedDrawer *)drawer{
    return [DXFlatImageAttributedDrawer new];
}

@end
