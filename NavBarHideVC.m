//
//  NavBarHideVC.m
//  ChargerManager
//
//  Created by 朗驰－曾家淇 on 2017/2/17.
//  Copyright © 2017年 zengjiaqi. All rights reserved.
//

#import "NavBarHideVC.h"

@interface NavBarHideVC ()

@end

@implementation NavBarHideVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注意下面两个写法的区别，注意，animated设为YES，仍是会有一个瞬间的过渡效果。只有设置为animated才能真正实现。
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //[self.view addSubview:[TabBarView defalutView]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.stateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    self.stateView.backgroundColor = ZColorRGBA(54, 44, 43, 1);
    [self.view addSubview:self.stateView];

    self.collectionView.frame = CGRectMake(0, 20, ScreenWidth, ScreenHeight-20-50);
}

- (void)dealloc
{
    ZLog(@"NavBarHideVC is dealloc = %@",self);
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
