//
//  TableViewRefreshVC.m
//  MoreShopProject
//
//  Created by 朗驰－曾家淇 on 2017/8/17.
//  Copyright © 2017年 朗驰－曾家淇. All rights reserved.
//

#import "TableViewRefreshVC.h"

@interface TableViewRefreshVC ()

@end

@implementation TableViewRefreshVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sourceArray = [[NSMutableArray alloc]init];
    [self initTableView];
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



- (void)initTableView
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView * headerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, -ScreenHeight, ScreenWidth, ScreenHeight)];
    headerBackView.backgroundColor = [UIColor blackColor];
    [self.tableView addSubview:headerBackView];//为了避免下拉刷新时出现断层的现象

    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(startHeaderRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.backgroundColor = [UIColor blackColor];
    header.stateLabel.textColor = [UIColor whiteColor];
    NSMutableArray * imageArry = [[NSMutableArray alloc]init];
    for (int i = 1; i<8;i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"monk%d.png",i]];
        [imageArry addObject:image];
    }

    [header setImages:imageArry duration:0.8 forState:MJRefreshStatePulling];
    [header setImages:imageArry duration:0.8 forState:MJRefreshStateIdle];
    self.tableView.mj_header = header;


    MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(startFooterRefresh)];
    footer.automaticallyHidden = YES;
    self.tableView.mj_footer = footer;

    self.tableView.backgroundColor = ZCollectionViewColor;
    [self.tableView insertSubview:header aboveSubview:headerBackView];

}
- (void)initNullImageView
{
    [self.nullImageView removeFromSuperview];
    self.nullImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-40, 0, 80,80)];
    self.nullImageView.alpha = 0;

    self.nullImageView.image = [UIImage imageNamed:@"none"];
    self.nullImageView.center = self.tableView.center;
    [self.tableView addSubview:self.nullImageView];
}

- (void)removeNullImageView
{
    [self.nullImageView removeFromSuperview];

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
                self.nullImageView.frame = CGRectMake(ScreenWidth/2-40, self.tableView.frame.size.height-250, 80, 80);
            }];
        }
        //ZLog(@"停止刷新");
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (self.sourceArray.count>=totalCount) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else
        {
            [self.tableView.mj_footer endRefreshing];
        }

    });
}
//网络请求失败或者网络请求超时
- (void)requstFailure:(NSNotificationCenter *)notify
{
    //[ZJQUtil showTipViewWithMessage:@"获取数据失败"];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    //取消所有网络请求
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.operationQueue cancelAllOperations];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
