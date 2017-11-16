//
//  WebViewVC.m
//  ChargerManager
//
//  Created by 朗驰－曾家淇 on 2017/2/21.
//  Copyright © 2017年 zengjiaqi. All rights reserved.
//

#import "WebViewVC.h"
#import "MMProgressHUD.h"
#import <WebKit/WebKit.h>//导入WebKit框架，IOS8.0之后

@interface WebViewVC ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong) WKWebView * webView;

@end

@implementation WebViewVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MMProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showLoadDataAnimation];
    [self initSubView];
    //[ZJQUtil postNotificationName:@"updateCrowdRecored" object:nil userInfo:nil];
}

- (void)initSubView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];

    [self addRightBarItems:@[@"关闭"]];

#if 0
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    self.webView.delegate = self;
    ZLog(@"webUrl = %@",self.webUrl);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
#endif
}

- (void)backAction:(UIButton *)sender
{
    [self popViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showLoadDataAnimation
{
    //    if ([self hideLoadDataAnimation]==YES) {
    //        return;
    //    }
    NSMutableArray * imageArry = [[NSMutableArray alloc]init];
    for (int i = 1; i<8;i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"monk%d.png",i]];
        [imageArry addObject:image];
    }
    [[MMProgressHUD sharedHUD] setOverlayMode:MMProgressHUDWindowOverlayModeGradient];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:@"加载中" status:nil images:imageArry];
}

//************************************************************
            #pragma mark 注释:WKNavigationDelegate
//************************************************************

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{

    [self showLoadDataAnimation];

}


// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{

}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    [MMProgressHUD dismiss];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [MMProgressHUD dismiss];
}

//************************************************************
            #pragma mark 注释:WKUIDelegate
//************************************************************

// 创建一个新的WebView
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures;

//剩下三个代理方法全都是与界面弹出提示框相关的，针对于web界面的三种提示框（警告框、确认框、输入框）分别对应三种代理方法。下面只举了警告框的例子。
//在WKWebview中，js的alert是不会出现任何内容的，你必须重写WKUIDelegate委托的runJavaScriptAlertPanelWithMessage message方法，自己处理

/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 警告框消失调用
 */
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(void (^)())completionHandler;

//************************************************************
        #pragma mark 注释:WKScriptMessageHandler
//************************************************************

//这个协议中包含一个必须实现的方法，这个方法是提高App与web端交互的关键，它可以直接将接收到的JS脚本转为OC或Swift对象。（当然，在UIWebView也可以通过“曲线救国”的方式与web进行交互，著名的Cordova框架就是这种机制）

// 从web界面中接收到一个脚本时调用
//- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;


#if 0

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoadDataAnimation];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MMProgressHUD dismiss];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MMProgressHUD dismissWithError:@"加载失败,请重试..." afterDelay:2];
}
#endif

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
