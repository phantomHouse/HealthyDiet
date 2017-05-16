//
//  DLMineBaseViewController.h
//  DiLiRestaurant
//
//  Created by 地利 on 2017/3/15.
//  Copyright © 2017年 地利. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
@interface DLMineBaseViewController : UIViewController

@property(weak,nonatomic)TPKeyboardAvoidingScrollView *ContentView;

@property(weak,nonatomic)UILabel *titleLabel;

@property(strong,nonatomic)UIButton *doneButton;

@property(strong,nonatomic)UIButton *skipButton;

@property(strong,nonatomic)NSMutableArray *dataArray;


@property(assign,nonatomic)ChioceType type;

@property(copy,nonatomic)NSString *baseValue;//初始值

@property(copy,nonatomic)NSString *returnValue;//返回值

@property(copy,nonatomic)void (^selectFinish)(NSString *result);



-(void)updateInfofromKey:(NSString *)key andValue:(NSString *)value;

- (void)done;

- (void)skipMain;

- (void)getuserinfo;
@end
