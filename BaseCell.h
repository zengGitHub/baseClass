//
//  BaseCell.h
//  ChargerManager
//
//  Created by 朗驰－曾家淇 on 2017/2/17.
//  Copyright © 2017年 zengjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
/**
 *  cell的回调block
 *
 *  @param view 点击的View
 */
typedef void(^ReturnBlock)(id view);

@interface BaseCell : UICollectionViewCell

@property (nonatomic,weak) BaseVC * controller;
@property (nonatomic,copy) ReturnBlock clickBolck;

-(void)initCellWithModel:(id) model;//cell的init方法


@end
