//
//  BaseCellModel.h
//  ChargerManager
//
//  Created by 朗驰－曾家淇 on 2017/5/18.
//  Copyright © 2017年 zengjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCell.h"//为了兼容静态的cell


@interface BaseCellModel : NSObject
/**
 *  cell的数据
 */
@property (nonatomic,strong) id cellData;
/**
 *  cell的Class
 */
@property (nonatomic,assign) Class cellClass;
/**
 *  cell的高度,提前计算
 */
@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic, strong) BaseCell *staticCell; //兼容静态的cell

+ (instancetype)modelFromCellClass:(Class)cellClass cellHeight:(CGFloat)cellHeight cellData:(id)cellData;
- (instancetype)initWithCellClass:(Class)cellClass cellHeight:(CGFloat)cellHeight cellData:(id)cellData;


@end
