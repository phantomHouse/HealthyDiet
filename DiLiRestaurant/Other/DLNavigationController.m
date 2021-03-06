//

//
//  Created by  on 15/10/13.
//  Copyright (c) 2015年 ZT. All rights reserved.
//

#import "DLNavigationController.h"

@interface DLNavigationController ()<UINavigationControllerDelegate>

@property(nonatomic,strong)id navideleagte;

@end

@implementation DLNavigationController

// 只初始化一次
+ (void)initialize
{
    // 设置项目中item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // Normal
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = RGBColor(123, 123, 123);
    disableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setTranslucent:NO];
    self.navigationBar.barTintColor=THEMECOLOR;
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    self.navigationBar.titleTextAttributes=textAttrs;
    
    self.navideleagte=self.interactivePopGestureRecognizer.delegate;
    self.interactivePopGestureRecognizer.delegate=nil;
    self.delegate=self;
    // Do any additional setup after loading the view.
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController==self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate=self.navideleagte;
    }
    else
        self.interactivePopGestureRecognizer.delegate=nil;
}
/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 此时push进来的viewController是第二个子控制器
        // 自动隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 定义leftBarButtonItem
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTargat:self action:@selector(back) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
        
        
        // 定义rightBarButtonItem
        //        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTargat:self action:@selector(more) image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
    }
    // 调用父类pushViewController，self.viewControllers数组添加对象viewController
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    // 这里要用self，不能用self.navigationViewController，因为self本身就是导航控制器对象，self.navigationViewController是nil
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}

@end
