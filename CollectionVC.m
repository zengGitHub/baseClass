//
//  CollectionVC.m
//  ChargerManager
//
//  Created by 朗驰－曾家淇 on 2017/2/17.
//  Copyright © 2017年 zengjiaqi. All rights reserved.
//

#import "CollectionVC.h"
#import "ZLPhotoPickerViewController.h"//图片选择Controller

@interface CollectionVC ()

@end

@implementation CollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initColletionView];
    self.sourceArray = [[NSMutableArray alloc]init];
    self.cellHeightArray = [[NSMutableArray alloc]init];
}

- (void)initColletionView
{
    self.automaticallyAdjustsScrollViewInsets = NO;


    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.itemSize = _layout.estimatedItemSize;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) collectionViewLayout:_layout];
    _collectionView.backgroundColor = ZColorRGBA(1, 1, 1, 1);//ZCollectionViewColor
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
}

- (NSArray *)photoArray
{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 选择图片的最小数，默认是9张图片最大也是9张
    pickerVc.maxCount = 9;
    // 默认显示相册里面的内容SavePhotos
    //    pickerVc.status = PickerViewShowStatusSavePhotos;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // Filter: PickerPhotoStatusAllVideoAndPhotos, PickerPhotoStatusVideos, PickerPhotoStatusPhotos.
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    pickerVc.selectPickers = self.sourceArray;
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.isShowCamera = YES;
    [pickerVc showPickerVc:self];
    //block回调
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> * assets){

        [self.sourceArray removeAllObjects];
        self.sourceArray = assets.mutableCopy;
        if (self.sourceArray.count == 0) {
            [self.sourceArray addObject:[UIImage imageNamed:@"icon_add"]];
        }

    };

    return self.sourceArray;
}

- (void)selectPhoto{

    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 选择图片的最小数，默认是9张图片最大也是9张
    pickerVc.maxCount = 9;
    // 默认显示相册里面的内容SavePhotos
    //    pickerVc.status = PickerViewShowStatusSavePhotos;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // Filter: PickerPhotoStatusAllVideoAndPhotos, PickerPhotoStatusVideos, PickerPhotoStatusPhotos.
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    pickerVc.selectPickers = self.sourceArray;
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.isShowCamera = YES;
    [pickerVc showPickerVc:self];
     //block回调
        pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> * assets){

            [self.sourceArray removeAllObjects];
            self.sourceArray = assets.mutableCopy;
            if (self.sourceArray.count == 0) {
                [self.sourceArray addObject:[UIImage imageNamed:@"icon_add"]];
            }
            [self.collectionView reloadData];
        };
}

- (CGFloat)setCellHeightWithCellData:(NSString *)cellData cellWidth:(CGFloat)cellWidth fontSize:(NSInteger)fontSize
{
    CGFloat cellHeight = CGFLOAT_MIN;
    if (ZNULLString(cellData)) {
        cellHeight = 20;
        return cellHeight;
    }
    NSDictionary *attributeDic =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGRect rect = [cellData boundingRectWithSize:CGSizeMake(cellWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil];
    cellHeight = ceilf(CGRectGetHeight(rect));
    return cellHeight;
};


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 15, 0);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
