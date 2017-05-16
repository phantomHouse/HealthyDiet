//
//  DLBrithdayChioceViewController.m
//  DiLiRestaurant
//
//  Created by 地利 on 2017/3/15.
//  Copyright © 2017年 地利. All rights reserved.
//

#import "DLBrithdayChioceViewController.h"
#import "DLDatePickView.h"
@interface DLBrithdayChioceViewController ()
@property(weak,nonatomic)DLDatePickView *dateView;
@end

@implementation DLBrithdayChioceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text=@"您的生日?";
    DLDatePickView *pickView=[[DLDatePickView alloc]initWithFrame:CGRectMake(0,60, kScreenW, 270)];
    pickView.backgroundColor=[UIColor whiteColor];
    pickView.themeColor=[UIColor orangeColor];
    pickView.datePickerStyle=DateStyleShowYearMonthDay;
    NSString *brithday=strIsEmpty([DLUserInfo getUser].birthday)==YES?@"1990-01-01":[DLUserInfo getUser].birthday;
    pickView.scrollToDate=[NSDate date:brithday WithFormat:@"yyyy-MM-dd"];
    [self.ContentView addSubview:pickView];
    self.dateView=pickView;
    [self.ContentView addSubview:self.doneButton];
    self.doneButton.frame=CGRectMake(50, CGRectGetMaxY(pickView.frame)+30, kScreenW-100, 44);
    
    // Do any additional setup after loading the view.
}

- (void)done
{
    [super done];
    if (self.type==FirstType) {
        [DLUser share].birthday=[self.dateView.scrollToDate stringWithFormat:@"yyyy-MM-dd"];
        DLMineBaseViewController *baseVC=[[NSClassFromString(@"DLWorkChioceViewController")alloc]init];
        baseVC.type=FirstType;
        [self.navigationController pushViewController:baseVC animated:YES];

    }
    else
    {
         [self updateInfofromKey:@"birthday" andValue:[self.dateView.scrollToDate stringWithFormat:@"yyyy-MM-dd"]]; 
    }
}
@end
