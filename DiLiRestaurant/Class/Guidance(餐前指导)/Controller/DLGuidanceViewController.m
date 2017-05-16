//
//  WebViewController.m
//  JS_OC_JavaScriptCore
//
//  Created by Harvey on 16/8/4.
//  Copyright © 2016年 Haley. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "DLGuidanceViewController.h"
#import "DLCustomAddFoodsViewController.h"
#import "DLFoodDetailViewController.h"
#import "PopView.h"

@interface DLGuidanceViewController ()<UIWebViewDelegate,JSObjcDelegate>

@property (strong, nonatomic) UIWebView *webView;

@property (nonatomic, strong) JSContext *jsContext;

@property(strong,nonatomic)MBProgressHUD *hud;
@end

@implementation DLGuidanceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.urlSring=[NSString stringWithFormat:@"%@%@userId=%@&random=%i",REQUEHTML5STURL,BeforeUrL,[DLUserInfo getUser].userId,arc4random_uniform(100000)];
    if ([DLUserInfo GetVersionType]==TeamType) {
        self.urlSring=[self.urlSring stringByAppendingFormat:@"&storeId=%@",[DLUserInfo getUserStore].storeId];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlSring]];

    [self.webView loadRequest:request];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"餐前指导";
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-49)];
    self.webView.delegate = self;
    //    NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
    //    NSURL *htmlURL = [NSURL URLWithString:@"http://www.baidu.com"];
    
    self.webView.backgroundColor = [UIColor clearColor];
    // UIWebView 滚动的比较慢，这里设置为正常速度
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.view addSubview:self.webView];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

#pragma mark - private method
- (void)addCustomActions
{
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"androidHandler"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        MyLog(@"异常信息：%@", exceptionValue);
    };
    
}

- (void)share
{
    MyLog(@"share");
    dispatch_async(dispatch_get_main_queue(), ^{
        [PopView configCustomPopViewWithFrame:CGRectMake(kScreenW-220, 100, 200, 44*4) imagesArr:@[@"share_wx",@"share_wx_circle",@"share_qq",@"share_space"] dataSourceArr:@[@"微信好友",@"分享到朋友圈",@"QQ好友",@"分享到QQ空间"] anchorPoint:CGPointMake(1, 0) seletedRowForIndex:^(NSInteger index) {
            switch (index) {
                case 0:
                    [[DLShareViewController shareManager] shareWebPageToPlatformType:UMSocialPlatformType_WechatSession WithTitle:@"快来看看上食上饮根据我的个人情况，为我定制的餐前指导吧。" descr:@"这里有根据我的个人情况提供的能量、营养素和饮食结构指导，快来看看吧。" thumImage:[UIImage imageNamed:@"shareicon"] andURL:self.urlSring andSuccess:nil];
                    break;
                case 1:
                    [[DLShareViewController shareManager]  shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine WithTitle:@"这里有根据我的情况提供的能量、营养素和饮食结构指导，快来看看吧。" descr:nil thumImage:[UIImage imageNamed:@"shareicon"] andURL:self.urlSring andSuccess:nil];
                    break;
                case 2:
                    [[DLShareViewController shareManager]  shareWebPageToPlatformType:UMSocialPlatformType_QQ WithTitle:@"快来看看我的餐前指导。" descr:@"这里有根据我的情况提供的能量、营养素和饮食结构指导，快来看看吧。" thumImage:[UIImage imageNamed:@"shareicon"] andURL:self.urlSring andSuccess:nil];
                    break;
                case 3:
                    [[DLShareViewController shareManager]  shareWebPageToPlatformType:UMSocialPlatformType_Qzone WithTitle:@"快来看看我的餐前指导。" descr:@"这里有根据我的情况提供的能量、营养素和饮食结构指导，快来看看吧。" thumImage:[UIImage imageNamed:@"shareicon"] andURL:self.urlSring andSuccess:nil];
                    break;
                default:
                    break;
            }
        } animation:YES timeForCome:0.3 timeForGo:0.3];
    });
}

- (void)dishBank
{
    MyLog(@"%@",[NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
        MyLog(@"%@",[NSThread currentThread]);
        DLCustomAddFoodsViewController *addfoot=[[DLCustomAddFoodsViewController alloc]init];
        addfoot.Eatingtime=[Globel getIndexFromCurrentDate]+1;
        addfoot.currentDate=[[Globel getDateFormatter] stringFromDate:[NSDate date]];
        addfoot.eatType=CustomType;
        addfoot.IsLookFoods=YES;
        [self.navigationController pushViewController:addfoot animated:YES];

    });
 
}

- (void)jumpFoodDetails:(NSString *)code
{
    MyLog(@"code%@",code);
    dispatch_async(dispatch_get_main_queue(), ^{
        DLFoodDetailViewController *foodDetailVC=[[DLFoodDetailViewController alloc]init];
        foodDetailVC.foodsCode=code;
        [self.navigationController pushViewController:foodDetailVC animated:YES];
    });

}



#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.hud hideAnimated:YES];
    [self addCustomActions];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.hud=[MBProgressHUD showProgress:@"loading..."];
}
@end
