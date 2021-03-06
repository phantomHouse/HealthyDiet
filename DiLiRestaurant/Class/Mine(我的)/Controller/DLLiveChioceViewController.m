//
//  DLLiveChioceViewController.m
//  DiLiRestaurant
//
//  Created by 地利 on 2017/3/15.
//  Copyright © 2017年 地利. All rights reserved.
//

#import "DLLiveChioceViewController.h"
#import "DLPickAddressView.h"
#import "DLProvinceInfo.h"
@interface DLLiveChioceViewController ()

@property(weak,nonatomic)DLPickAddressView *PickView;

@end

@implementation DLLiveChioceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"常住地";
    self.titleLabel.text=@"请选择您的常住地";
    DLPickAddressView *pickView=[[DLPickAddressView alloc]initWithFrame:CGRectMake(10, 60, kScreenW-20, 200)];
    [self.ContentView addSubview:pickView];
    if (self.type==OtherType&&!strIsEmpty([DLUserInfo getUserDetail].currentProvinceCode)) {
        pickView.defaultArray=@[[DLUserInfo getUserDetail].currentProvinceCode,[DLUserInfo getUserDetail].currentCityCode,[DLUserInfo getUserDetail].currentDistrictId];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)done
{
    [super done];
    if (self.type==FirstType) {
        NSArray *codeArray=self.PickView.finishArray;
        [DLUser share].currentProvinceCode=((DLProvinceInfo *)codeArray[0]).sortCode;
        [DLUser share].currentCityCode=((DLCityInfo *)codeArray[1]).sortCode;
        [DLUser share].currentDistrictId=((DLAreaInfo *)codeArray[2]).sortCode;
        DLMineBaseViewController *baseVC=[[NSClassFromString(@"DLFlavorViewController")alloc]init];
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
    [updatedic setObject:((DLProvinceInfo *)codeArray[0]).sortCode forKey:@"currentProvinceCode"];
    [updatedic setObject:((DLCityInfo *)codeArray[1]).sortCode  forKey:@"currentCityCode"];
    [updatedic setObject:((DLAreaInfo *)codeArray[2]).sortCode  forKey:@"currentDistrictId"];
    [[GLNetWorkManager shareManager]requestType:POST andURL:REQUESTURL andServers:GET_WORK_TYPE andParmas:updatedic andComplition:^(id response, BOOL isuccess) {
        if (isuccess&&[response[@"code"] isEqualToString:SUCCESSCODE]) {
            self.returnValue=((DLProvinceInfo *)codeArray[0]).name;
            [self getuserinfo];
        }
    }];
    
}

@end
