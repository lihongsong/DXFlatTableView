//
//  YSTableViewCell.m
//  DXFlatTableView
//
//  Created by yoser on 2017/10/12.
//  Copyright © 2017年 yoser. All rights reserved.
//

#import "YSTableViewCell.h"

#import "DXFlatTextAttributed.h"

@implementation YSTableViewCell

- (NSArray<DXFlatAttributed *> *)layout:(CGRect)frame{
    
//    NSLog(@"%@",NSStringFromCGRect(frame));
    
    DXFlatTextAttributed *textAttribute = [DXFlatTextAttributed new];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    
    NSDictionary *dic1 = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                          NSForegroundColorAttributeName:[UIColor redColor]};
    
    NSDictionary *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                          NSForegroundColorAttributeName:[UIColor blueColor]};
    
    NSDictionary *dic3 = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                           NSForegroundColorAttributeName:[UIColor blackColor]};
    
    NSAttributedString *userA = [[NSAttributedString alloc] initWithString:@"李泓松" attributes:dic1];
    
    NSAttributedString *comment = [[NSAttributedString alloc] initWithString:@"回复:" attributes:dic2];
    
    NSAttributedString *userB = [[NSAttributedString alloc] initWithString:@"赵国庆" attributes:dic1];
    
    NSAttributedString *content = [[NSAttributedString alloc] initWithString:@"1239不得不服你们不发生" attributes:dic3];
    
    [string appendAttributedString:userA];
    [string appendAttributedString:comment];
    [string appendAttributedString:userB];
    [string appendAttributedString:content];
    
    textAttribute.attributeString = string;
    textAttribute.backgroundColor = [UIColor grayColor];
    textAttribute.frame = CGRectMake(0, 0, 375, 40);
    
    return @[textAttribute];
}

@end
