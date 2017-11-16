//
//  TableViewRefreshVC.h
//  MoreShopProject
//
//  Created by 朗驰－曾家淇 on 2017/8/17.
//  Copyright © 2017年 朗驰－曾家淇. All rights reserved.
//

#import "BaseVC.h"

@interface TableViewRefreshVC : BaseVC<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign) NSInteger  pageSize;
@property (nonatomic,assign) NSInteger pageNo;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * sourceArray;

/**
 *  占位imageview，当数组为空时显示
 */
@property (nonatomic,strong) UIImageView * nullImageView;
- (void)initNullImageView;
- (void)removeNullImageView;

@end
