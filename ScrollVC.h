//
//  ScrollVC.h
//  ChargerManager
//
//  Created by 朗驰－曾家淇 on 2017/3/15.
//  Copyright © 2017年 zengjiaqi. All rights reserved.
//

#import "BaseVC.h"

@interface ScrollVC : BaseVC<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>



//************************************************************
#pragma mark 注释:继承自ScrollVC的子Controller,必须传入以下参数,topArray（装载着顶部的title）和cellArray（装载着cell）
//************************************************************



/**
 *  顶部button的Array,不能为空
 */
@property (nonatomic,strong) NSArray * topArray;
/**
 *  cell的Array，不能为空
 */
@property (nonatomic,strong) NSArray * cellArray;
/**
 *  装headerView的Array，可为空
 */
@property (nonatomic,strong) NSArray * headerViewArray;
/**
 *  装footerView的Array，可为空
 */
@property (nonatomic,strong) NSArray * footerViewArray;

/**
 *  滚动的下标
 */
@property (nonatomic,assign) NSInteger index;

@property (nonatomic,assign) NSInteger seleteIndex;

/**
 *  pageNo
 */
@property (nonatomic,assign) NSInteger pageNo;
/**
 *  pageSize
 */
@property (nonatomic,assign) NSInteger pageSize;
/**
 *  数据源,内容是各个VC数据的可变数组
 */
@property (nonatomic,strong) NSMutableArray * sourceArray;

/**
 *  显示顶部标题的topView
 */
@property (nonatomic,strong) UIView * topView;

@property (nonatomic,strong) UIScrollView * scrollView;
/**
 *  当前显示的CollectionView
 */
@property (nonatomic,strong) UICollectionView * currentColletionView;
/**
 *  当前数据源
 */
@property (nonatomic,strong) NSMutableArray * currentSourceArray;


/**
 *  当下标改变时调用此方法
 *
 *  @param loadData 是否要刷新或者加载数据
 */
- (void)indexDidChangeNeedLoadData:(BOOL)loadData;


@end
