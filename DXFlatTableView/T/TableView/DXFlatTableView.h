//
//  DXFlatTableView.h
//  DXFlatTableView
//
//  Created by yoser on 2017/10/11.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXFlatTableView;
@class DXFlatTableViewCell;
@class DXFlatTableViewHeaderFooterView;

@protocol DXFlatTableViewDataSource <NSObject>

@required

NS_ASSUME_NONNULL_BEGIN
- (NSInteger)flatTableView:(DXFlatTableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (DXFlatTableViewCell *)flatTableView:(DXFlatTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(DXFlatTableView *)tableView;

NS_ASSUME_NONNULL_END

@end

@protocol DXFlatTableViewDelegate <NSObject>

@optional
NS_ASSUME_NONNULL_BEGIN
- (void)flatTableView:(DXFlatTableView *)tableView didSelectSectionHeader:(NSInteger)sectionIndex;

- (void)flatTableView:(DXFlatTableView *)tableView didSelectSectionFooter:(NSInteger)sectionIndex;

// Called after the user changes the selection.
- (void)flatTableView:(DXFlatTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

// custom view for header. will be adjusted to default or specified header height
- (nullable DXFlatTableViewHeaderFooterView *)flatTableView:(DXFlatTableView *)tableView viewForHeaderInSection:(NSInteger)section;

// custom view for footer. will be adjusted to default or specified footer height
- (nullable DXFlatTableViewHeaderFooterView *)flatTableView:(DXFlatTableView *)tableView viewForFooterInSection:(NSInteger)section;

- (CGFloat)flatTableView:(DXFlatTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)flatTableView:(DXFlatTableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)flatTableView:(DXFlatTableView *)tableView heightForFooterInSection:(NSInteger)section;

NS_ASSUME_NONNULL_END

@end

@interface DXFlatTableView : UIView

@property (weak, nonatomic) _Nullable id<DXFlatTableViewDataSource> dataSource;

@property (weak, nonatomic) _Nullable id<DXFlatTableViewDelegate> delegate;

- (void)reloadData;

- (CGRect)flatTableViewFrameForCellInIndexPath:(nonnull NSIndexPath *)indexPath;

@end
