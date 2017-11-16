//
//  TabBarShowVC.m
//  ChargerManager
//
//  Created by 朗驰－曾家淇 on 2017/3/3.
//  Copyright © 2017年 zengjiaqi. All rights reserved.
//

#import "TabBarShowVC.h"
#import "TabBarView.h"
@interface TabBarShowVC ()

@property (nonatomic,strong) TabBarView * tabBarView;

@end

@implementation TabBarShowVC


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:[TabBarView defalutTabBarView]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-50);
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
