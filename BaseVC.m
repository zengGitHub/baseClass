//
//  BaseVC.m
//  ChargerManager
//
//  Created by apple on 17/2/16.
//  Copyright © 2017年 zengjiaqi. All rights reserved.
//

#import "BaseVC.h"
#import "WebViewVC.h"
#import "ZLPhotoPickerBrowserViewController.h"//查看图片Controller

@interface BaseVC ()<ZLPhotoPickerBrowserViewControllerDelegate>
{
    UIImageView *navBarHairlineImageView;//再定义一个imageview来等同于这个黑线
}

@end

@implementation BaseVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBarHairlineImageView.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"requstFailure" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   // navBarHairlineImageView.hidden = NO;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.pamaras = [[NSMutableDictionary alloc]init];
    
    //这样修改的话，所有的back都是返回
    [self customNavBar];

}

- (void)initSubView{
    //子类中重写
}


- (void)loadNetData{
    //子类中重写
    
}

- (void)loadNetDataAnimated:(BOOL)animated
{
    //子类中重写
}

- (void)showbgImageView
{
    UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"order_bg"];
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
}

- (void)showNullImageViewInView:(UIView *)view
{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenHeight, 80, 80)];
    imageView.image = [UIImage imageNamed:@"none"];
    imageView.tag = 8765;//特殊值处理
    [view addSubview:imageView];

    [UIView animateWithDuration:1 animations:^{

        imageView.frame = CGRectMake(ScreenWidth/2-40, ScreenHeight/2-40, 80, 80);
    }];
}

- (void)hideNullImageViewFromView:(UIView *)view
{
    UIImageView * imageView = [view viewWithTag:8765];
    [imageView removeFromSuperview];
}

- (void)customNavBar
{
    //是否隐藏navigationBar
    self.navigationController.navigationBarHidden = NO;
    //设置状态栏字体颜色，UIBarStyleBlack，状态栏字体颜色为白色，UIBarStyleDefault系统默认，状态栏为黑色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    //影响返回按钮字体颜色
    self.navigationController.navigationBar.tintColor = ZBaseColor;//[UIColor whiteColor];
    //navigationBar的背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];//ZColorRGBA(39, 42, 50, 0.6);//ZColorRGBA(54, 44, 43, 1);
    //设置标题属性，比如颜色字体等等
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:ZBaseColor};
    //设置navigationbar的透明性,iOS 7 之后，setTranslucent=yes 默认的则状态栏及导航栏底部为透明的，界面上的组件应该从屏幕顶部开始显示，因为是半透明的，可以看到，所以为了不和状态栏及导航栏重叠，第一个组件的y应该从44+20的位置算起
    //设置Translucen为NO的时候，界面的所有控件的坐标都往下移了64
    [self.navigationController.navigationBar setTranslucent:NO];
    //为了解决Translucen = NO控件的坐标都往下移了64单位的问题，可以设置extendedLayoutIncludesOpaqueBars为YES，这样当设置Translucen = NO，控件的坐标就不会下移64了
    self.extendedLayoutIncludesOpaqueBars = YES;

    [self preferredStatusBarStyle];
    self.automaticallyAdjustsScrollViewInsets = NO;
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    UIColor * color1 = ZColorRGBA(123, 182, 64, 1);
    UIColor * color2 = ZColorRGBA(29, 173, 34, 1);
    gradientLayer.colors = @[(__bridge id)color1.CGColor,(__bridge id)color2.CGColor];
    gradientLayer.frame = CGRectMake(0, 0, ScreenWidth, 64);
    gradientLayer.locations = @[@0,@1];//必须是递增
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    //[self.navigationController.navigationBar.layer addSublayer:gradientLayer];
}

//方法2:找出黑线,再做处理:
//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)pushWebControllerWithTitle:(NSString *)title url:(NSString *)url{

    WebViewVC * ctl = [[WebViewVC alloc]init];
    ctl.webUrl = url;
    ctl.title = title;
    [self pushViewController:ctl];
}

- (void)readPhotoWithArray:(NSArray *)sourceArray andIndex:(NSInteger)index
{
    ZLPhotoPickerBrowserViewController * browserVC = [[ZLPhotoPickerBrowserViewController alloc]init];
    browserVC.status = UIViewAnimationAnimationStatusZoom;
    browserVC.editing = YES;
    NSMutableArray * photoArray = [[NSMutableArray alloc]init];
    for (NSString * url in sourceArray) {
        ZLPhotoPickerBrowserPhoto * photo = [[ZLPhotoPickerBrowserPhoto alloc]init];
        photo.photoURL = [NSURL URLWithString:ZImageUrl(url)];
        [photoArray addObject:photo];
    }
    browserVC.photos = photoArray;
    browserVC.currentIndex = index;
    [browserVC showPickerVc:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    ZLog(@"收到内存警告");
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
