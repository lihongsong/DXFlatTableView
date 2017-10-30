//
//  DXFlatTableView.m
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import "DXFlatTableView.h"

#import "DXFlatAttributed.h"

#import "DXFlatAsyncDisplayView.h"

#import "DXFlatTableViewCell.h"

#import "DXFlatTableViewHeaderFooterView.h"

#define FLATHEADERROW -1

#define FLATFOOTERROW -2

@interface DXFlatTableView()

@property (strong, nonatomic) DXFlatAsyncDisplayView *displayView;

/**
 用于标记当前的 DXFlatAttributed 所处在的位置 便于实现点击事件的回调
 如果是section 的header indexPath.row = -NSIntegerMax
 如果是section 的footer indexPath.row = NSIntegerMax
 */
@property (strong, nonatomic) NSMutableDictionary <DXFlatAttributed *,NSIndexPath *> *indexPathDic;

@property (strong, nonatomic) NSMutableDictionary <NSIndexPath *,NSValue *> *frameDic;

@end

@implementation DXFlatTableView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.displayView = [DXFlatAsyncDisplayView new];
        [self addSubview:self.displayView];
        [self addDisplayViewConstraint];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        self.displayView = [DXFlatAsyncDisplayView new];
        [self addSubview:self.displayView];
        [self addDisplayViewConstraint];
    }
    return self;
}

/**
 添加displayView的约束
 */
- (void)addDisplayViewConstraint{
    
    // 禁止将 AutoresizingMask 转换为 Constraints
    self.displayView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 添加 left 约束
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:_displayView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self addConstraint:leftConstraint];
    // 添加 top 约束
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_displayView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self addConstraint:topConstraint];
    // 添加 right 约束
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_displayView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraint:widthConstraint];
    // 添加 bottom 约束
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_displayView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:heightConstraint];
}

- (void)reloadData{
    
    [self.displayView clearAttribute];
    
    // 默认的 section 为1
    NSInteger section = 1;
    
    if([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]){
        section = [self.dataSource numberOfSectionsInTableView:self];
    }
    
    CGFloat currentTopFlag = 0;
    
    for (int i = 0 ; i < section; i++ ){
        
        // 设置 section 的头部
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForRow:FLATHEADERROW inSection:i];
        DXFlatTableViewHeaderFooterView *header;
        if([self.delegate respondsToSelector:@selector(flatTableView:viewForHeaderInSection:)]){
            header = [self.delegate flatTableView:self viewForHeaderInSection:i];
        }
        
        CGFloat headerHeight = 40;
        if([self.delegate respondsToSelector:@selector(flatTableView:heightForHeaderInSection:)]){
            headerHeight = [self.delegate flatTableView:self heightForHeaderInSection:i];
        }
        currentTopFlag = [self setUp:header height:headerHeight topFlag:currentTopFlag indexPath:headerIndexPath];
        
        // 设置每一个 section 中的 cell
        NSInteger rowCount = [self.dataSource flatTableView:self numberOfRowsInSection:i];
        for (int j = 0 ; j < rowCount; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            DXFlatTableViewCell *cell = [self.dataSource flatTableView:self cellForRowAtIndexPath:indexPath];
            CGFloat cellHeight = 40;
            if([self.delegate respondsToSelector:@selector(flatTableView:heightForRowAtIndexPath:)]){
                cellHeight = [self.delegate flatTableView:self heightForRowAtIndexPath:indexPath];
            }
            currentTopFlag = [self setUp:cell height:cellHeight topFlag:currentTopFlag indexPath:indexPath];
        }
        
        // 设置 section 的尾部
        NSIndexPath *footerIndexPath = [NSIndexPath indexPathForRow:FLATFOOTERROW inSection:i];
        DXFlatTableViewHeaderFooterView *footer;
        if([self.delegate respondsToSelector:@selector(flatTableView:viewForFooterInSection:)]) {
            footer = [self.delegate flatTableView:self viewForFooterInSection:i];
        }
        CGFloat footerHeight = 40;
        if([self.delegate respondsToSelector:@selector(flatTableView:heightForFooterInSection:)]){
            footerHeight = [self.delegate flatTableView:self heightForFooterInSection:i];
        }
        currentTopFlag = [self setUp:footer height:footerHeight topFlag:currentTopFlag indexPath:footerIndexPath];
    }
    
    [self.displayView setNeedsDisplay];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.displayView setNeedsDisplay];
}

- (NSInteger)setUp:(id<DXFlatTableViewLayout>)layoutView
            height:(CGFloat)layoutHeight
           topFlag:(CGFloat)topFlag
         indexPath:(NSIndexPath *)indexPath
{
    
    if (layoutView){
        
        __weak __typeof(self) weakSelf = self;
        DXFlatAttributeTouchCallBack touchCallBack = ^(DXFlatAttributed *attribute){
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf touchAttribute:attribute];
        };
        
        CGFloat x = 0;
        CGFloat y = topFlag;
        CGFloat height = layoutHeight;
        CGFloat width = self.frame.size.width;
        
        CGRect layerRect = CGRectMake(x, y, width, height);
        CGRect layerBounds = CGRectMake(0, 0, width, height);
        
        NSArray *layouts = [layoutView layout:layerBounds];
        
        [layouts enumerateObjectsUsingBlock:^(DXFlatAttributed *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.indexPathDic[obj] = indexPath;
            strongSelf.frameDic[indexPath] = [NSValue valueWithCGRect:layerRect];
            obj.touchCallBack = touchCallBack;
        }];
        
        [self.displayView addAttributes:layouts inRect:layerRect];
        return topFlag + height;
    }
    return topFlag;
}

- (CGRect)flatTableViewFrameForCellInIndexPath:(NSIndexPath *)indexPath{
    return [self.frameDic[indexPath] CGRectValue];
}

- (void)touchAttribute:(DXFlatAttributed *)attribute{
    
    NSIndexPath *indexPath = self.indexPathDic[attribute];
    
    if (indexPath.row == FLATFOOTERROW &&
        [self.delegate respondsToSelector:@selector(flatTableView:didSelectSectionFooter:)]){
        [self.delegate flatTableView:self didSelectSectionFooter:indexPath.section];
        return;
    }
    
    if (indexPath.row == FLATHEADERROW &&
        [self.delegate respondsToSelector:@selector(flatTableView:didSelectSectionHeader:)]){
        [self.delegate flatTableView:self didSelectSectionHeader:indexPath.section];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(flatTableView:didSelectRowAtIndexPath:)]){
        [self.delegate flatTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - GET & SET 
- (NSMutableDictionary<DXFlatAttributed *,NSIndexPath *> *)indexPathDic{
    if(_indexPathDic == nil){
        _indexPathDic = [NSMutableDictionary dictionary];
    }
    return _indexPathDic;
}

- (NSMutableDictionary<NSIndexPath *,NSValue *> *)frameDic{
    if(_frameDic == nil){
        _frameDic = [NSMutableDictionary dictionary];
    }
    return _frameDic;
}

@end
