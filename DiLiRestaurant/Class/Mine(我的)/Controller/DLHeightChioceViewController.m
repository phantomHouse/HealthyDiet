//
//  DLHeightChioceViewController.m
//  DiLiRestaurant
//
//  Created by 地利 on 2017/3/15.
//  Copyright © 2017年 地利. All rights reserved.
//

#import "DLHeightChioceViewController.h"
#import "DLAlonePickView.h"
@interface DLHeightChioceViewController ()
@property(weak,nonatomic)DLAlonePickView *pickView;
@end

@implementation DLHeightChioceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseValue=[DLUserInfo getUser].height;
    self.titleLabel.text=@"您的身高";
    NSMutableArray *dateArray=[NSMutableArray array];
    for (int i=150; i<=200; i++) {
        [dateArray addObject:[NSString stringWithFormat:@"%i",i]];
    }
    DLAlonePickView *heightView=[[DLAlonePickView alloc]initWithFrame:CGRectMake(0, 60, kScreenW, 270)];
    heightView.dataArray=dateArray;
    heightView.themeColor=[UIColor orangeColor];
    if (self.type==FirstType&&[DLUser share].sex.boolValue) {
        heightView.defaultValue=@"175";
    }
    else if (self.type==FirstType){
        heightView.defaultValue=@"163";
    }
    else if(!strIsEmpty(self.baseValue))
        heightView.defaultValue=self.baseValue;
    heightView.lastString=@"cm";
    [self.ContentView addSubview:heightView];
    self.pickView=heightView;
    [self.ContentView addSubview:self.doneButton];
    self.doneButton.frame=CGRectMake(50, CGRectGetMaxY(heightView.frame)+20, kScreenW-100, 44);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)done
{
    [super done];
    if (self.type==FirstType) {
        [DLUser share].height=self.pickView.resultValue;
        DLMineBaseViewController *baseVC=[[NSClassFromString(@"DLWeightChioceViewController")alloc]init];
        baseVC.type=FirstType;
        [self.navigationController pushViewController:baseVC animated:YES];
        
    }
    else
    {
        [self updateInfofromKey:@"height" andValue:self.pickView.resultValue];
    }

}
@end
