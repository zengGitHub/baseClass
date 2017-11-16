//
//  RefreshVC.h
//  ChargerManager
//
//  Created by 朗驰－曾家淇 on 2017/3/15.
//  Copyright © 2017年 zengjiaqi. All rights reserved.
//

#import "CollectionVC.h"

@interface RefreshVC : CollectionVC
//@property (nonatomic,strong) NSMutableArray * sourceArray;
@property (nonatomic,assign) NSInteger  pageSize;
@property (nonatomic,assign) NSInteger pageNo;
/**
 *  占位imageview，当数组为空时显示
 */
@property (nonatomic,strong) UIImageView * nullImageView;
- (void)initNullImageView;
- (void)removeNullImageView;
- (void)showCellAnimation;

@property (nonatomic,strong) UIView * headerBackView;
@property (nonatomic,strong) UILabel * headerBackLabel;


@end
