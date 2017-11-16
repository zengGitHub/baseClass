
//
//  ScrollVC.m
//  ChargerManager
//
//  Created by 朗驰－曾家淇 on 2017/3/15.
//  Copyright © 2017年 zengjiaqi. All rights reserved.
//

#import "ScrollVC.h"

@interface ScrollVC ()



/**
 *  上一次scrollview滑动的X轴
 */
@property (nonatomic,assign) CGFloat lastContentX;

/**
 *  装已经加载过的index的数组，如果数组中含有index就不加载数据，否则加载数据
 */
@property (nonatomic,strong) NSMutableArray * loadedArray;

@end

@implementation ScrollVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //self.index = 0;
    self.pageNo = 1;
    self.pageSize = 10;
    self.lastContentX = 0;
    self.sourceArray = [[NSMutableArray alloc]init];
    self.loadedArray = [[NSMutableArray alloc]init];
    [self.loadedArray addObject:@(self.index)];
    [self initSubView];
    [self initScrollView];
    [self.pamaras setValue:@(self.pageNo) forKey:@"pageNo"];
    [self.pamaras setValue:@(self.pageSize) forKey:@"pageSize"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLoadData:) name:@"doneLoadNetData" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requstFailure:) name:@"requstFailure" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"doneLoadNetData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"requstFailure" object:nil];

}

- (void)initScrollView
{
    NSArray * titleArray = self.topArray;
    self.view.backgroundColor = [UIColor blackColor];
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(10, 64, ScreenWidth-20, 40)];
    self.topView.backgroundColor = ZBlackColor;
    [ZJQUtil makeCorner:5 view:self.topView];
    [self.view addSubview:self.topView];
    

    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 104, ScreenWidth, ScreenHeight-104)];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth*titleArray.count, ScreenHeight-104);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];

    CGFloat width = ScreenWidth/titleArray.count;
    for (int i = 0; i<titleArray.count; i++) {
        NSMutableArray * dataArray = [[NSMutableArray alloc]init];
        [self.sourceArray addObject:dataArray];

        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(width*i, 0, width, 40)];
        button.tag = 10+i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:titleArray[i] forState:0];
        [button setTitleColor:[UIColor lightGrayColor] forState:0];
        [button setTitleColor:ZBaseColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:button];

        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(width*(i+1), 10, 0.5, 20)];
        lineView.backgroundColor = [UIColor blackColor];
        [self.topView addSubview:lineView];

        if (i==self.index) {
            button.selected = YES;
        }

        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, ViewHEIGHT(self.scrollView)) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor blackColor];
        collectionView.tag = 60+i;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        ZRegisterStringCell(collectionView, self.cellArray[i]);
        if (!ZArrayIsEmpty(self.headerViewArray)) {
            ZRegStringHeaderView(collectionView, self.headerViewArray[i]);
        }

        if (!ZArrayIsEmpty(self.footerViewArray)) {
            ZRegStringFooterView(collectionView, self.footerViewArray[i]);
        }
        MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(startHeaderRefresh)];
        collectionView.mj_header = header;
        collectionView.mj_header.backgroundColor = [UIColor clearColor];

        MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(startFooterRefresh)];
        footer.automaticallyHidden = YES;
        collectionView.mj_footer = footer;
        [self.scrollView addSubview:collectionView];
        
    }
    //这句活不能少
    self.scrollView.contentOffset = CGPointMake(ScreenWidth*self.index, 0);
}


- (UICollectionView *)currentColletionView
{
    UICollectionView * collectionView = (UICollectionView *)[self.scrollView viewWithTag:60+self.index];
    return collectionView;
}

- (NSMutableArray *)currentSourceArray
{
    NSMutableArray * array = self.sourceArray[self.index];
    return array;
}

- (void)indexDidChangeNeedLoadData:(BOOL)loadData
{
    //这个方法子类中如果需要当index改变时需要做特殊操作时需要重写，否则可以不重写
}

- (UICollectionView *)currentCollectionView
{
//    ZLog(@"self.index = %ld",self.index);
    UICollectionView * collectionView = [self.scrollView viewWithTag:60+self.index];
    return collectionView;
}

- (void)startHeaderRefresh
{
    //先调HeaderRefresh的目的是先清空数组源，再去掉loadNetData，直接掉loadNetData则达不到清空数组源的目的
//    NSMutableArray * array = self.sourceArray[self.index];
//    [array removeAllObjects];
    [self.currentSourceArray removeAllObjects];
    self.pageNo = 1;
    [self.pamaras setValue:@(self.pageNo) forKey:@"pageNo"];
    [self loadNetDataAnimated:NO];
}
- (void)startFooterRefresh
{
    self.pageNo++;
    [self.pamaras setValue:@(self.pageNo) forKey:@"pageNo"];
    [self loadNetDataAnimated:NO];
}
//不移除通知的话这个方法会多次调用
- (void)finishLoadData:(NSNotificationCenter *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{

        //[[self currentCollectionView].mj_header endRefreshing];
        UICollectionView * colletionView = [self.scrollView viewWithTag:60+ self.index];
        [colletionView.mj_header endRefreshing];

        NSInteger totalCount = [[noti valueForKey:@"object"] integerValue];
        NSArray * dataArray = self.sourceArray[self.index];
        ZLog(@"数据加载完毕，停止刷新");
        if (dataArray.count>=totalCount) {
            [colletionView.mj_footer endRefreshingWithNoMoreData];
        }else
        {
            [colletionView.mj_footer endRefreshing];
        }

        if (dataArray.count==0) {

            [self hideNullImageViewFromView:colletionView];
            [self showNullImageViewInView:colletionView];

        }else
        {
             [self hideNullImageViewFromView:colletionView];
             [colletionView.mj_header endRefreshing];
            return;
        }


    });

}

- (void)requstFailure:(NSNotificationCenter *)notify
{
    [[self currentCollectionView].mj_header endRefreshing];
    [[self currentCollectionView].mj_footer endRefreshing];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isMemberOfClass:[UIScrollView class]]) {
        NSInteger index = (NSInteger)scrollView.contentOffset.x/ScreenWidth;
        self.index = index;
        for (UIButton * sender in [self.topView subviews]) {
            if ([sender isKindOfClass:[UIButton class]]) {
                sender.selected = NO;
            }
        }
        UIButton * button = [self.topView viewWithTag:10+index];
        button.selected = YES;

        if (scrollView.contentOffset.x != self.lastContentX && ![self.loadedArray containsObject:@(index)]) {
            [self indexDidChangeNeedLoadData:NO];
            [self.currentSourceArray removeAllObjects];
            [self loadNetDataAnimated:YES];

        }
        if (scrollView.contentOffset.x != self.lastContentX && [self.loadedArray containsObject:@(index)]) {

            [self indexDidChangeNeedLoadData:YES];
        }

        [self.loadedArray addObject:@(index)];
        self.lastContentX = scrollView.contentOffset.x;
    }
}

- (void)buttonAction:(UIButton *)sender
{
    if (self.index == sender.tag - 10) {
        return;
    }

    self.index = sender.tag - 10;
    self.scrollView.contentOffset = CGPointMake(ScreenWidth*(sender.tag-10), 0);
    for (UIButton * sender in [self.topView subviews]) {
        if ([sender isKindOfClass:[UIButton class]]) {
            sender.selected = NO;
        }
    }
    sender.selected = YES;

    if (![self.loadedArray containsObject:@(self.index)]){
        [self indexDidChangeNeedLoadData:NO];
        [self.currentSourceArray removeAllObjects];
        [self loadNetDataAnimated:YES];
    }else
    {
        [self indexDidChangeNeedLoadData:YES];
    }
    [self.loadedArray addObject:@(self.index)];

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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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
