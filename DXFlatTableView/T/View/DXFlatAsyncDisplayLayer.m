//
//  DXFlatAsyncDisplayLayer.m
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import "DXFlatAsyncDisplayLayer.h"
#import "DXFlatAsyncDisplayTransaction.h"

#import "DXFlatTransaction.h"
#import "CALayer+DXFlatTransaction.h"

#import "DXFlatFlag.h"

#import <UIKit/UIKit.h>

static const char * KAsyncDisplayQueue = "KAsyncDisplayQueue";

@interface DXFlatAsyncDisplayLayer()

@property (strong, nonatomic) dispatch_queue_t displayQueue;

@property (strong, nonatomic) DXFlatFlag *flag;

@end

@implementation DXFlatAsyncDisplayLayer

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        self.opaque = YES;
        self.asynchronously = YES;
        self.flag = [DXFlatFlag new];
        [self displayQueue];
    }
    return self;
}

- (instancetype)init{
    if(self = [super init]){
        self.opaque = YES;
        self.asynchronously = YES;
        self.flag = [DXFlatFlag new];
        [self displayQueue];
    }
    return self;
}

- (void)setNeedsDisplay{
    [self cancelAsyncDisplay];
    [self display:self.asynchronously];
}

- (void)cancelAsyncDisplay{
    [self.flag raiseValue];
}

- (void)displayImmediately{
    [self.flag raiseValue];
    [self display:self.asynchronously];
}

/**
 清理画板
 */
- (void)drawClear{
    CGImageRef imageRef = (__bridge_retained CGImageRef)(self.contents);
    id contents = self.contents;
    self.contents = nil;
    if (imageRef) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [contents class];
            CFRelease(imageRef);
        });
    }
}

/**
 绘制背景颜色
 */
- (void)drawBackgroundColor:(CGContextRef)context{
    
    CGSize size = self.bounds.size;
    BOOL opaque = self.opaque;
    CGFloat scale = self.contentsScale;
    CGColorRef backgroundColor = (opaque && self.backgroundColor) ?
    CGColorRetain(self.backgroundColor) : NULL;
    
    if (opaque) {
        CGContextSaveGState(context);
        {
            if (!backgroundColor || CGColorGetAlpha(backgroundColor) < 1) {
                CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                CGContextFillPath(context);
            }
            if (backgroundColor) {
                CGContextSetFillColorWithColor(context, backgroundColor);
                CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                CGContextFillPath(context);
            }
        }
        CGContextRestoreGState(context);
        CGColorRelease(backgroundColor);
    }
}

- (void)setOpaque:(BOOL)opaque{
    [super setOpaque:opaque];
}

/**
 绘制
 */
- (void)display:(BOOL)asynchronously{
    
    id<DXFlatAsyncDisplayTransactionCreater> transactionCrreater = (id) self.delegate;
    DXFlatAsyncDisplayTransaction *displayTransaction = [transactionCrreater asyncDisplayTransaction];
    
    if(displayTransaction.willDisplayBlock){
        displayTransaction.willDisplayBlock(self);
    }
    
    CGSize size = self.bounds.size;
    BOOL opaque = self.opaque;
    CGFloat scale = self.contentsScale;
    
    // 绘制之前清除之前的内容
    [self drawClear];
    
    // 对于无法显示在屏幕上的情况 采取不绘制的操作
    if((size.width < 1 || size.height < 1)){
        displayTransaction.didDisplayBlock(self, YES);
        return;
    }
    
    // 是否有绘制过程
    if (!displayTransaction.displayBlock){
        displayTransaction.didDisplayBlock(self, YES);
    }else{
        
        uint32_t value = _flag.currentValue;
        
        DXAsyncDisplayIsCanclledBlock cancelBlock = ^BOOL(){
            return (value != _flag.currentValue);
        };
        
        // 同步绘制
        if (!asynchronously){
            
            // 绘制准备工作
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
            __block CGContextRef context = UIGraphicsGetCurrentContext();
            
            // 绘制背景颜色
            [self drawBackgroundColor:context];
            
            // 绘制内容
            displayTransaction.displayBlock(context, size, cancelBlock());
            
            // 结束绘制
            if (displayTransaction.didDisplayBlock) {
                displayTransaction.didDisplayBlock(self, NO);
            }
            
            UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            // 直接在主线程渲染
            self.contents = (__bridge id _Nullable)(image.CGImage);
            
            return;
        }
        
        // 异步绘制
        dispatch_async(_displayQueue, ^{
            
            // 绘制准备工作
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
            __block CGContextRef context = UIGraphicsGetCurrentContext();
            
            void (^complete)(void) = ^{
                UIGraphicsEndImageContext();
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (displayTransaction.didDisplayBlock) {
                        displayTransaction.didDisplayBlock(self, NO);
                    }
                });
            };
            
            // 检测绘制是否被取消
            if([self checkCancel:cancelBlock complete:complete]) { return; }
            
            // 绘制背景颜色
            [self drawBackgroundColor:context];
            
            // 绘制内容
            displayTransaction.displayBlock(context, size, cancelBlock());
            
            // 检测绘制是否被取消
            if([self checkCancel:cancelBlock complete:complete]) { return; }
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __weak typeof(self) weakSelf = self;
                DXFlatTransaction *layerAsyncTransaction = self.transactionInstance;
                [layerAsyncTransaction addOperationWithTarget:self
                                                     selector:@selector(setContents:)
                                                       object:(__bridge id)(image.CGImage)
                                                     complete:^(BOOL isCancel) {
                                                         __strong typeof(weakSelf) strongSelf = weakSelf;
                                                         if (displayTransaction.didDisplayBlock) {
                                                             displayTransaction.didDisplayBlock(strongSelf, !cancelBlock());
                                                         }
                                                     }];
            });
        });
    }
}

- (BOOL)checkCancel:(DXAsyncDisplayIsCanclledBlock)cancelBlock
           complete:(void(^)(void))complete{
    if (cancelBlock()) {
        UIGraphicsEndImageContext();
        !complete?:complete();
    }
    return cancelBlock();
}

#pragma mark - GET & SET 
- (dispatch_queue_t)displayQueue{
    if(_displayQueue == nil){
        _displayQueue = dispatch_queue_create(KAsyncDisplayQueue, DISPATCH_QUEUE_CONCURRENT);
    }
    return _displayQueue;
}

@end
