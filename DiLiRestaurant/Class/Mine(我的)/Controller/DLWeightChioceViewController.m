//
//  DLWeightChioceViewController.m
//  DiLiRestaurant
//
//  Created by 地利 on 2017/3/15.
//  Copyright © 2017年 地利. All rights reserved.
//

#import "DLWeightChioceViewController.h"
#import "DLAlonePickView.h"
@interface DLWeightChioceViewController ()
@property(weak,nonatomic)DLAlonePickView *pickView;
@end

@implementation DLWeightChioceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseValue=[DLUserInfo getUserDetail].weight;
    self.titleLabel.text=@"您的体重?";
    NSMutableArray *dateArray=[NSMutableArray array];
    for (int i=30; i<=200; i++) {
        [dateArray addObject:[NSString stringWithFormat:@"%i",i]];
    }
    DLAlonePickView *heightView=[[DLAlonePickView alloc]initWithFrame:CGRectMake(0, 60, kScreenW, 270)];
    heightView.dataArray=dateArray;
    heightView.themeColor=[UIColor orangeColor];
    if (self.type==FirstType&&[DLUser share].sex.boolValue) {
        heightView.defaultValue=@"70";
    }
    else if (self.type==FirstType){
        heightView.defaultValue=@"50";
    }
    else if(!strIsEmpty([DLUserInfo getUserDetail].weight))
        heightView.defaultValue=self.baseValue;
    heightView.lastString=@"kg";
    [self.ContentView addSubview:heightView];
    self.pickView=heightView;
    [self.ContentView addSubview:self.doneButton];

    self.doneButton.frame=CGRectMake(50, CGRectGetMaxY(heightView.frame)+20, kScreenW-100, 44);
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    MyLog(@".....");
}
- (void)done
{
    [super done];
    if (self.type==FirstType) {
        [DLUser share].weight=self.pickView.resultValue;
        DLMineBaseViewController *baseVC=[[NSClassFromString(@"DLTabooChioceViewController")alloc]init];
        baseVC.type=FirstType;
        [self.navigationController pushViewController:baseVC animated:YES];
        
    }
    else
    {
        [self updateInfofromKey:@"weight" andValue:self.pickView.resultValue];
    }
    
}

@end
