//
//  DXFlatAsyncDisplayView.m
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import "DXFlatAsyncDisplayView.h"

#import "DXFlatAsyncDisplayLayer.h"

#import "DXFlatAsyncDisplayTransaction.h"

#import "DXFlatAttributed.h"

#import "DXFlatTool.h"

@interface DXFlatAsyncDisplayView()<DXFlatAsyncDisplayTransactionCreater>

@property (strong, nonatomic) DXFlatAsyncDisplayTransaction *displayTransaction;

@property (strong, nonatomic) NSMutableArray <DXFlatAttributed *> *attributes;

@property (strong, nonatomic) NSMutableDictionary <DXFlatAttributed *,NSValue *> *attributesFrame;

@property (assign, nonatomic) BOOL isDisplayed;

@end

@implementation DXFlatAsyncDisplayView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.layer.delegate = self;
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        self.opaque = YES;
        [self addTapGes];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        self.layer.delegate = self;
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        self.opaque = YES;
        [self addTapGes];
    }
    return self;
}

- (void)addTapGes{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tapGes];
}

- (void)clearAttribute{
    [self.attributes removeAllObjects];
    [self.attributesFrame removeAllObjects];
}

#pragma mark - Touches Event
- (void)tapClick:(UITapGestureRecognizer *)tapGes{

    if (!_isDisplayed){
        return;
    }
    
    CGPoint clickPoint = [tapGes locationInView:self];
    
    for(NSInteger i = self.attributes.count - 1 ; i > 0 ; i--){
        DXFlatAttributed *attribute = self.attributes[i];
        
        // 因为attribute使用的是相对位置所以需要转换为绝对位置
        CGRect tempRect = [self.attributesFrame[attribute] CGRectValue];
        CGRect absoluteRect = [DXFlatTool absoluteRect:tempRect withRect:attribute.frame];
        
        if(CGRectContainsPoint(absoluteRect, clickPoint) && attribute.userInteractionEnabled){
            // 响应手势回调
            attribute.touchCallBack(attribute);
            break;
        }
    }
}

- (void)setNeedsDisplay{
    [super setNeedsDisplay];
    [self.layer setNeedsDisplay];
}

#pragma mark - DXFlatAsyncDisplayTransactionCreater
- (DXFlatAsyncDisplayTransaction *)asyncDisplayTransaction{
    return self.displayTransaction;
}

#pragma mark - GET & SET
+ (Class)layerClass {
    return [DXFlatAsyncDisplayLayer class];
}

- (NSMutableArray<DXFlatAttributed *> *)attributes{
    if(_attributes == nil){
        _attributes = [NSMutableArray array];
    }
    return _attributes;
}

- (NSMutableDictionary *)attributesFrame{
    if(_attributesFrame == nil){
        _attributesFrame = [NSMutableDictionary dictionary];
    }
    return _attributesFrame;
}

- (DXFlatAsyncDisplayTransaction *)displayTransaction{
    
    if(_displayTransaction == nil){
        _displayTransaction = [DXFlatAsyncDisplayTransaction new];
        
        __weak __typeof(self) weakSelf = self;
        _displayTransaction.displayBlock = ^(CGContextRef context, CGSize size, BOOL isCancel) {
            __weak __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.attributes
             enumerateObjectsUsingBlock:^(DXFlatAttributed * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 CGRect tempRect = [strongSelf.attributesFrame[obj] CGRectValue];
                 // 绘制各种attribute                 
                 [[obj drawer] draw:obj context:context rect:tempRect];
            }];
        };
        
        _displayTransaction.willDisplayBlock = ^(CALayer *layer) {
            __weak __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.isDisplayed = NO;
        };
        
        _displayTransaction.didDisplayBlock = ^(CALayer *layer, BOOL finished) {
            __weak __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.isDisplayed = YES;
        };
    }
    return _displayTransaction;
}

- (void)addAttribute:(DXFlatAttributed *)attribute inRect:(CGRect)rect{
    [self.attributes addObject:attribute];
    [self.attributesFrame setObject:[NSValue valueWithCGRect:rect] forKey:attribute];
}

- (void)addAttributes:(NSArray<DXFlatAttributed *> *)attributes inRect:(CGRect)rect{
    [self.attributes addObjectsFromArray:attributes];
    
    for(DXFlatAttributed *attribute in attributes){
        [self.attributesFrame setObject:[NSValue valueWithCGRect:rect] forKey:attribute];
    }
}

@end
