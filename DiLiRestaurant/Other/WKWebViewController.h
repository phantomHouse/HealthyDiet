//
//  WKWebViewController.h
//  JS_OC_WebViewJavascriptBridge
//
//  Created by Harvey on 16/8/4.
//  Copyright © 2016年 Haley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKWebViewController : UIViewController
@property(copy,nonatomic)NSString *urlSring;
@property(assign,nonatomic)BOOL isPush;

@end