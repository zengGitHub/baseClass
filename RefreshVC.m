//
//  RefreshVC.m
//  ChargerManager
//
//  Created by 朗驰－曾家淇 on 2017/3/15.
//  Copyright © 2017年 zengjiaqi. All rights reserved.
//

#import "RefreshVC.h"
#import <MJRefresh/MJRefresh.h>
#import <AFNetworking/AFNetworking.h>
@interface RefreshVC ()

@end


@implementation RefreshVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNo = 1;
    self.pageSize = 10;
    [self.pamaras setValue:@(self.pageNo) forKey:@"pageNo"];
    [self.pamaras setValue:@(self.pageSize) forKey:@"pageSize"];
    //self.sourceArray = [[NSMutableArray alloc]init];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self initMJRefreshView];
    //[self initNullImageView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLoadData:) name:@"doneLoadNetData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requstFailure:) name:@"requstFailure" object:nil];

}

-  (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"doneLoadNetData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"requstFailure" object:nil];
}


- (void)removeNullImageView
{
    [self.nullImageView removeFromSuperview];
    
}

- (void)initMJRefreshView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
    self.headerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, -ScreenHeight, ScreenWidth, ScreenHeight)];
    [self.collectionView addSubview:self.headerBackView];//为了避免下拉刷新时出现断层的现象

//    UIImageView * backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-75, ViewHEIGHT(self.headerBackView)-80-40, 35, 35)];
//    backImageView.image = [UIImage imageNamed:@"loading02"];
//    backImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.headerBackView addSubview:backImageView];
//
//
//    self.headerBackLabel = [[UILabel alloc]initWithFrame:CGRectMake(MaxX(backImageView), Y(backImageView)+8, 100, 20)];
//    self.headerBackLabel.textAlignment = NSTextAlignmentCenter;
//    self.headerBackLabel.text = @"松开即可刷新";
//    self.headerBackLabel.textColor = [UIColor whiteColor];
//    self.headerBackLabel.font = [UIFont boldSystemFontOfSize:13];
//    [self.headerBackView addSubview:self.headerBackLabel];

    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(startHeaderRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.backgroundColor = self.headerBackView.backgroundColor = [UIColor blackColor];//ZColorRGBA(54, 44, 43, 1);
    header.stateLabel.textColor = [UIColor whiteColor];
    NSMutableArray * imageArry = [[NSMutableArray alloc]init];
    for (int i = 1; i<8;i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"monk%d.png",i]];
        //[imageArry addObject:image];
    }

    [header setImages:imageArry duration:0.8 forState:MJRefreshStatePulling];
    [header setImages:imageArry duration:0.8 forState:MJRefreshStateIdle];
    self.collectionView.mj_header = header;


    MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(startFooterRefresh)];
    footer.automaticallyHidden = YES;
    self.collectionView.mj_footer = footer;

    [self.collectionView insertSubview:header aboveSubview:self.headerBackView];
}


- (void)initNullImageView
{
    [self.nullImageView removeFromSuperview];
    self.nullImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-40, 0, 80,80)];
    self.nullImageView.alpha = 0;
    
    self.nullImageView.image = [UIImage imageNamed:@"empty_order"];
    self.nullImageView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2-100);
    //self.nullImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.nullImageView];
}

- (void)startHeaderRefresh
{
    //先调HeaderRefresh的目的是先清空数组源，再去掉loadNetData，直接掉loadNetData则达不到清空数组源的目的
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        self.pageNo = 1;
        [self.pamaras setValue:@(self.pageNo) forKey:@"pageNo"];
        [self.sourceArray removeAllObjects];
        [self loadNetDataAnimated:NO];
    });

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
    /*
     *  NSNotificationCenter消息的接受线程是基于发送消息的线程的。也就是同步的，因此，有时候，发送的消息可能不在主线程，而操作UI必须在主线程，不然会出现不响应的情况。所以，在收到消息通知的时候，注意选择你要执行的线程
    */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{


    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger totalCount = [[noti valueForKey:@"object"] integerValue];

        if (self.sourceArray.count>0) {
            [self removeNullImageView];
        }else
        {
            [self removeNullImageView];
            [self initNullImageView];
            [UIView animateWithDuration:0.7 animations:^{
                self.nullImageView.alpha = 1.0;
                self.nullImageView.frame = CGRectMake(ScreenWidth/2-40, ScreenHeight/2-40, 80, 80);//self.collectionView.frame.size.height-250
            }];
        }
        //ZLog(@"停止刷新");
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        if (self.sourceArray.count>=totalCount) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else
        {
            [self.collectionView.mj_footer endRefreshing];
        }

    });
}
//网络请求失败或者网络请求超时
- (void)requstFailure:(NSNotificationCenter *)notify
{
    //[ZJQUtil showTipViewWithMessage:@"获取数据失败"];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
    //取消所有网络请求
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.operationQueue cancelAllOperations];
}

- (void)showCellAnimation
{
    NSArray *cells = self.collectionView.visibleCells;
    for (int i = 0; i < cells.count; i++) {
        CGFloat totalTime = 0.4;
        UICollectionViewCell *cell = [self.collectionView.visibleCells objectAtIndex:i];
        cell.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
        [UIView animateWithDuration:0.4 delay:i*(totalTime/cells.count) usingSpringWithDamping:0.7 initialSpringVelocity:1/0.7 options:UIViewAnimationOptionCurveEaseIn animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {

        }];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (ZArrayIsEmpty(self.sourceArray)) {
        return nil;
    }else
    {
        return nil;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
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
