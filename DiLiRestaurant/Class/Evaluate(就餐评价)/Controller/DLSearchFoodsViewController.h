//
//  DLSearchFoodsViewController.h
//  DiLiRestaurant
//
//  Created by 地利 on 2017/4/7.
//  Copyright © 2017年 地利. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLSearchFoodsViewController : UIViewController
//菜品库专用
@property(assign,nonatomic)BOOL IsLookFoods;

@property(assign,nonatomic)EatChoiceType eatType;

@property(assign,nonatomic)EatTimeType timeType;

@property(copy,nonatomic)NSString *curentdate;
@end
