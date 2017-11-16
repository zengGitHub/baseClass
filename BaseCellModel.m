//
//  BaseCellModel.m
//  ChargerManager
//
//  Created by 朗驰－曾家淇 on 2017/5/18.
//  Copyright © 2017年 zengjiaqi. All rights reserved.
//

#import "BaseCellModel.h"

@implementation BaseCellModel

+(instancetype)modelFromCellClass:(Class)cellClass cellHeight:(CGFloat)cellHeight cellData:(id)cellData
{
    BaseCellModel * cellModel = [[self alloc] init];
    cellModel.cellClass = cellClass;
    cellModel.cellHeight = cellHeight;
    cellModel.cellData = cellData;
    return cellModel;
}

-(instancetype)initWithCellClass:(Class)cellClass cellHeight:(CGFloat)cellHeight cellData:(id)cellData
{
    return [BaseCellModel modelFromCellClass:cellClass cellHeight:cellHeight cellData:cellData];
}

@end
