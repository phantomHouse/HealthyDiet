//
//  WKWebViewController.m
//  JS_OC_WebViewJavascriptBridge
//
//  Created by Harvey on 16/8/4.
//  Copyright © 2016年 Haley. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <AVFoundation/AVFoundation.h>

#import "DLHomeViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import "DLTabBarViewController.h"

@interface DLHomeViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (strong, nonatomic)   WKWebView                   *webView;
@property (strong, nonatomic)   UIProgressView              *progressView;

@property WKWebViewJavascriptBridge *webViewBridge;

@property(copy,nonatomic)NSString *urlSring;

@end

@implementation DLHomeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.urlSring=[NSString stringWithFormat:@"%@%@",REQUEHTML5STURL,webHomeUrl];
    // Do any additional setup after loading the view.
    //    self.title = @"WKWebView--WebViewJavascriptBridge";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(rightClick)];
    //    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self initWKWebView];
    
    
    [self initProgressView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
//    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)initWKWebView
{
//    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
//    
//    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
//    [wkUController addUserScript:wkUScript];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
//    configuration.userContentController =wkUController;
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 30.0;
    configuration.preferences = preferences;
    
    self.webView = [[WKWebView alloc] initWithFrame:ViewRect configuration:configuration];
    [self.webView setAllowsBackForwardNavigationGestures:YES];
    [_webView setMultipleTouchEnabled:YES];
    [_webView setAutoresizesSubviews:YES];
    [self.webView sizeToFit];
    _webViewBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [_webViewBridge setWebViewDelegate:self];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlSring]]];
    //    [self.webView loadHTMLString:localHtml baseURL:fileURL];
    
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
}

- (void)initProgressView
{
    CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
    progressView.tintColor = [UIColor redColor];
    progressView.trackTintColor = [UIColor lightGrayColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
}

//- (void)rightClick
//{
//    //    // 如果不需要参数，不需要回调，使用这个
//    //    [_webViewBridge callHandler:@"testJSFunction"];
//    //    // 如果需要参数，不需要回调，使用这个
//    //    [_webViewBridge callHandler:@"testJSFunction" data:@"一个字符串"];
//    // 如果既需要参数，又需要回调，使用这个
//    [_webViewBridge callHandler:@"testJSFunction" data:@"一个字符串" responseCallback:^(id responseData) {
//        NSLog(@"调用完JS后的回调：%@",responseData);
//    }];
//}

- (void)dealloc
{
    MyLog(@"%s",__FUNCTION__);
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
//    [self.webView removeObserver:self forKeyPath:@"title"];
}
#pragma mark - KVO
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1.0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });
            
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
//    else if ([keyPath isEqualToString:@"title"])
//    {
//        if (object == self.webView) {
//            self.title = self.webView.title;
//            
//        }
//        else
//        {
//            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//            
//        }
//    }
//    else {
//        
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (self.webView.canGoBack) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.webView.frame=CGRectMake(0, 0, kScreenW, kScreenH+64);
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        self.webView.frame=ViewRect;
    }
    MyLog(@"%@",self.navigationController.parentViewController);
    self.tabBarController.tabBar.hidden=self.webView.canGoBack;
}

#pragma mark - WKUIDelegate



- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
