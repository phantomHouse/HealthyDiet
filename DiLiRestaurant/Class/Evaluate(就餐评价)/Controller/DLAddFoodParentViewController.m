//
//  DLAddFootParentViewController.m
//  DiLiRestaurant
//
//  Created by 地利 on 2017/4/1.
//  Copyright © 2017年 地利. All rights reserved.
//

#import "DLAddFoodParentViewController.h"
#import "ChoiceView.h"
#import "DLAddStoreFoodListViewController.h"
#import "DLCustomAddFoodsViewController.h"
@interface DLAddFoodParentViewController ()<UIScrollViewDelegate>
@property(weak,nonatomic)ChoiceView *choiceView;
@end

@implementation DLAddFoodParentViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BackGroundColor;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTargat:self action:@selector(back) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
    if (self.timeType==BreakFastType) {
        self.title=@"添加早餐";
    }
    else if (self.timeType==LunchType){
        self.title=@"添加午餐";
    }
    else
        self.title=@"添加晚餐";
    if (self.IsLookFoods) {
        self.title=@"菜品库";
    }
    if ([DLUserInfo GetVersionType]==TeamType) {
        [self creatTeamModel];
    }
    else
        [self creatPersonalModel];
    [self creatFootView];
    // Do any additional setup after loading the view.
}

- (void)creatFootView{
    UIView *footView=[[UIView alloc]init];
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        (void)make.left;
        (void)make.bottom;
        (void)make.right;
        make.height.mas_equalTo(@60);
    }];
    UIButton *finishButton=[[UIButton alloc]initWithFrame:CGRectMake((kScreenW-200)/2, 8, 200, 44)];
    finishButton.layer.cornerRadius=22;
    finishButton.layer.masksToBounds=YES;
    finishButton.backgroundColor=THEMECOLOR;
    [finishButton setImage:[UIImage imageNamed:@"foodsfinish"] forState:UIControlStateNormal];
    [finishButton setTitle:@"完成添加" forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(addFoods) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:finishButton];

}
-(void)creatTeamModel{
    ChoiceView *choiceView=[[ChoiceView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44) andtitleArray:@[@"门店供应",@"自定义"]];
    [self.view addSubview:choiceView];
    self.choiceView=choiceView;
    UIScrollView *scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(choiceView.frame), kScreenW, kScreenH-CGRectGetMaxY(choiceView.frame)-64-60)];
    scrollview.delegate=self;
    scrollview.contentSize=CGSizeMake(kScreenW*2, 0);
    scrollview.pagingEnabled=YES;
    [self.view addSubview:scrollview];
    choiceView.clickbuttonblock=^(NSInteger index){
        scrollview.contentOffset=CGPointMake(kScreenW*index, 0);
    };
    
    DLAddStoreFoodListViewController *storeVC=[[DLAddStoreFoodListViewController alloc]init];
    storeVC.eatType=StoreType;
    storeVC.currentDate=self.curentdate;
    storeVC.Eatingtime=self.timeType;
    [self addChildViewController:storeVC];
    storeVC.view.frame=scrollview.bounds;
    [scrollview addSubview:storeVC.view];
    
    DLCustomAddFoodsViewController *cusVC=[[DLCustomAddFoodsViewController alloc]init];
    cusVC.Eatingtime=self.timeType;
    cusVC.eatType=CustomType;
    cusVC.currentDate=self.curentdate;
    [self addChildViewController:cusVC];
    CGRect rect=scrollview.bounds;
    rect.origin.x=CGRectGetWidth(scrollview.bounds);
    cusVC.view.frame=rect;
    [scrollview addSubview:cusVC.view];
}

- (void)creatPersonalModel{
    DLCustomAddFoodsViewController *cusVC=[[DLCustomAddFoodsViewController alloc]init];
    cusVC.Eatingtime=self.timeType;
    cusVC.eatType=CustomType;
    cusVC.currentDate=self.curentdate;
    [self addChildViewController:cusVC];
    CGRect rect=ViewRect;
//    rect.size.height-=60;
    cusVC.view.frame=rect;
    [self.view addSubview:cusVC.view];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index=scrollView.contentOffset.x/kScreenW+0.5;
    [self.choiceView clickbuttonAtIndex:index];
}

- (void)addFoods{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic.transCode=@"C0116";
    dic.type=@"add";
    [dic setObject:[DLUserInfo getUser].userId forKey:@"userId"];
    [dic setObject:@(self.timeType) forKey:@"mealType"];
    [dic setObject:self.curentdate forKey:@"time"];
    NSMutableArray *listArray=[NSMutableArray array];
    if ([DLUserInfo GetVersionType]==TeamType) {
        DLAddStoreFoodListViewController *storeVC=self.childViewControllers.firstObject;
        [storeVC.dataArray enumerateObjectsUsingBlock:^(DLStoreCategaryInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.dishesSupplyDtlList enumerateObjectsUsingBlock:^(DLStorefoodsInfo * _Nonnull foodsobj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (foodsobj.selectNum) {
                    NSMutableDictionary *infoDic=[NSMutableDictionary dictionary];
                    [infoDic setObject:@(foodsobj.selectNum*foodsobj.weight) forKey:@"weight"];
                    [infoDic setObject:@2 forKey:@"wayType"];
                    [infoDic setObject:foodsobj.imagesURL forKey:@"imageUrl"];
                    [infoDic setObject:foodsobj.imagesURL1 forKey:@"imageUrl1"];
                    [infoDic setObject:foodsobj.dishesCode forKey:@"dishesCode"];
                    [infoDic setObject:foodsobj.dishesName forKey:@"dishesName"];
                    [listArray addObject:infoDic];
                }
            }];
        }];
 
    }
    
    DLCustomAddFoodsViewController *customVC=self.childViewControllers.lastObject;
    [customVC.DetaildataArray enumerateObjectsUsingBlock:^(DLStorefoodsInfo * _Nonnull foodsobj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (foodsobj.selectNum) {
            NSMutableDictionary *infoDic=[NSMutableDictionary dictionary];
            [infoDic setObject:@(foodsobj.selectNum*foodsobj.customWeight) forKey:@"weight"];
            [infoDic setObject:@1 forKey:@"wayType"];
            [infoDic setObject:foodsobj.imagesURL forKey:@"imageUrl"];
            [infoDic setObject:foodsobj.imagesURL1 forKey:@"imageUrl1"];
            [infoDic setObject:foodsobj.dishesCode forKey:@"dishesCode"];
            [infoDic setObject:foodsobj.dishesName forKey:@"dishesName"];
            [listArray addObject:infoDic];
        }

    }];
    if (!listArray.count) {
        [MBProgressHUD showMessage:@"您还没有选择菜"];
        return;
    }
//    NSString *str=[[self arrayToJsonString:listArray] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    [dic setObject:[self arrayToJsonString:listArray]  forKey:@"list"];
    [[GLNetWorkManager shareManager]requestType:POST andURL:REQUESTURL andServers:GET_WORK_TYPE andParmas:dic andComplition:^(id response, BOOL isuccess) {
        if (isuccess&&[response[@"code"] isEqualToString:SUCCESSCODE]) {
            if (self.finishAdd) {
                self.finishAdd();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (NSString *)arrayToJsonString:(NSArray *)arr{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
-(void)back{
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.view removeFromSuperview];
        [obj removeFromParentViewController];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
