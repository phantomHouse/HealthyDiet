//
//  DLNativePlaceChioceViewController.m
//  DiLiRestaurant
//
//  Created by 地利 on 2017/3/15.
//  Copyright © 2017年 地利. All rights reserved.
//

#import "DLNativePlaceChioceViewController.h"
#import "DLProvinceInfo.h"
#import "DLPickAddressView.h"
@interface DLNativePlaceChioceViewController ()

@property(weak,nonatomic)DLPickAddressView *PickView;

@end

@implementation DLNativePlaceChioceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"籍贯";
    self.titleLabel.text=@"请选择您的籍贯";
    DLPickAddressView *pickView=[[DLPickAddressView alloc]initWithFrame:CGRectMake(10, 60, kScreenW-20, 200)];
    [self.ContentView addSubview:pickView];
    if (self.type==OtherType&&!strIsEmpty([DLUserInfo getUser].homeProvinceCode)) {
        pickView.defaultArray=@[[DLUserInfo getUser].homeProvinceCode,[DLUserInfo getUser].homeCityCode,[DLUserInfo getUser].homeDistrictId];
    }
    else
    {
        pickView.defaultArray=@[@"110000",@"110100",@"110101"];
    }
    self.PickView=pickView;
    self.doneButton.frame=CGRectMake(50, CGRectGetMaxY(pickView.frame)+30, kScreenW-100, 44);
    [self.ContentView addSubview:self.doneButton];
    if (self.type==FirstType) {
        CGRect rect=self.doneButton.frame;
        rect.origin.y+=60;
        self.skipButton.frame=rect;
        [self.ContentView addSubview:self.skipButton];

    }
    // Do any additional setup after loading the view.
}

- (void)done
{
    [super done];
    if (self.type==FirstType) {
        NSArray *codeArray=self.PickView.finishArray;
        [DLUser share].homeProvinceCode=((DLProvinceInfo *)codeArray[0]).sortCode;
        [DLUser share].homeCityCode=((DLCityInfo *)codeArray[1]).sortCode;
        [DLUser share].homeDistrictId=((DLAreaInfo *)codeArray[2]).sortCode;
        DLMineBaseViewController *baseVC=[[NSClassFromString(@"DLLiveChioceViewController")alloc]init];
        baseVC.type=FirstType;
        [self.navigationController pushViewController:baseVC animated:YES];
        
    }
    else
    {
        [self updateInfo];
    }
}


- (void)updateInfo
{
    NSArray *codeArray=self.PickView.finishArray;
    NSMutableDictionary *updatedic=[NSMutableDictionary dictionary];
    [updatedic setObject:@"C0100" forKey:@"transCode"];
    [updatedic setObject:@"update" forKey:@"type"];
    [updatedic setObject:[DLUserInfo getUser].userId forKey:@"userId"];
    [updatedic setObject:((DLProvinceInfo *)codeArray[0]).sortCode forKey:@"homeProvinceCode"];
    [updatedic setObject:((DLCityInfo *)codeArray[1]).sortCode  forKey:@"homeCityCode"];
    [updatedic setObject:((DLAreaInfo *)codeArray[2]).sortCode  forKey:@"homeDistrictId"];
    [[GLNetWorkManager shareManager]requestType:POST andURL:REQUESTURL andServers:GET_WORK_TYPE andParmas:updatedic andComplition:^(id response, BOOL isuccess) {
        if (isuccess&&[response[@"code"] isEqualToString:SUCCESSCODE]) {
            self.returnValue=((DLProvinceInfo *)codeArray[0]).name;
            [self getuserinfo];
        }
    }];
    
}

@end
