//
//  DLPickAddressView.m
//  DiLiRestaurant
//
//  Created by 地利 on 2017/3/27.
//  Copyright © 2017年 地利. All rights reserved.
//

#import "DLPickAddressView.h"
#import "DLProvinceInfo.h"
@interface DLPickAddressView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)NSMutableArray <DLProvinceInfo *>*dataArray;

@property(weak,nonatomic)UIPickerView *pickView;

@end

@implementation DLPickAddressView

- (void)setDefaultArray:(NSArray *)defaultArray
{
    _defaultArray=defaultArray;
    NSArray *indexArray;
    for (int i=0; i<self.dataArray.count; i++) {
        if ([defaultArray[0] isEqualToString:self.dataArray[i].sortCode]) {
            for (int j=0; j<self.dataArray[i].list.count; j++) {
                if ([defaultArray[1] isEqualToString:self.dataArray[i].list[j].sortCode]) {
                    for (int k=0; k<self.dataArray[i].list[j].list.count; k++) {
                        if ([defaultArray[2] isEqualToString:self.dataArray[i].list[j].list[k].sortCode]) {
                            indexArray=@[@(i),@(j),@(k)];
                            break;
                        }
                    }
                    break;
                }
            }
            break;
        }
    }
    for (int i=0; i<indexArray.count; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.pickView reloadComponent:i];
            [self.pickView selectRow:[indexArray[i] integerValue] inComponent:i animated:YES];
        });

    }
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self getData];
        [self creatUI];
    }
    return self;
}

- (void)getData{
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"]];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    [DLProvinceInfo mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"list":@"DLCityInfo"};
    }];
    [DLCityInfo mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"list":@"DLAreaInfo"};
    }];
    [self.dataArray addObjectsFromArray:[DLProvinceInfo mj_objectArrayWithKeyValuesArray:dic[@"districtList"]]];
}
- (void)creatUI{
    UIPickerView *pickview=[[UIPickerView alloc]initWithFrame:self.bounds];
    pickview.delegate=self;
    pickview.dataSource=self;
    [self addSubview:pickview];
    self.pickView=pickview;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return self.dataArray.count;
    }
    else if (component==1){
        return self.dataArray[[self.pickView selectedRowInComponent:0]].list.count;
    }
    else
    {
//        DLCityInfo *cityInfo=
        return self.dataArray[[self.pickView selectedRowInComponent:0]].list[[self.pickView selectedRowInComponent:1]].list.count;
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:17]];
    }
    NSString *title;
    if (component==0) {
        title=self.dataArray[row].name;
    }
    else if (component==1){
        title=self.dataArray[[self.pickView selectedRowInComponent:0]].list[row].name;
    }
    else
    {
        title=self.dataArray[[self.pickView selectedRowInComponent:0]].list[[self.pickView selectedRowInComponent:1]].list[row].name;
    }
    customLabel.text = title;
    customLabel.textColor = [UIColor blackColor];
    return customLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.pickView reloadAllComponents];
    DLProvinceInfo *province=self.dataArray[[pickerView selectedRowInComponent:0]];
    DLCityInfo *city=province.list[[self.pickView selectedRowInComponent:1]];
    DLAreaInfo *area=city.list[[pickerView selectedRowInComponent:2]];
    self.finishArray=@[province,city,area];
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
@end
