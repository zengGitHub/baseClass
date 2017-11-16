//
//  CollectionVC.h
//  ChargerManager
//
//  Created by 朗驰－曾家淇 on 2017/2/17.
//  Copyright © 2017年 zengjiaqi. All rights reserved.
//

#import "BaseVC.h"

@interface CollectionVC : BaseVC<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionViewFlowLayout * layout;
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) NSMutableArray * sourceArray;
@property (nonatomic,strong) NSMutableArray * cellHeightArray;

- (void)selectPhoto;
- (NSArray *)photoArray;

- (CGFloat)setCellHeightWithCellData:(NSString *)cellData cellWidth:(CGFloat)cellWidth fontSize:(NSInteger)fontSize;

@end
