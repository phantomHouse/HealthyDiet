//
//  ZFChooseTimeCollectionViewCell.m
//  slyjg
//
//  Created by 王小腊 on 16/3/9.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#define CYBColorGreen [UIColor colorWithRed:78/255.0 green:147/255.0 blue:232/255.0 alpha:1]
#define YJCorl(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height

#import "ZFChooseTimeCollectionViewCell.h"

@interface ZFChooseTimeCollectionViewCell ()
@property (nonatomic, strong) NSDateComponents *comps;
@property (nonatomic, strong) NSCalendar *calender;

@property (nonatomic, strong) NSDateFormatter *formatter;


@end

@implementation ZFChooseTimeCollectionViewCell

- (NSDateFormatter*)formatter
{
    
    if (_formatter == nil) {
        
        _formatter =[[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}
- (NSCalendar*)calender
{
    
    if (_calender == nil) {
        
        _calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    
    return _calender;
}
- (NSDateComponents*)comps
{
    
    if (_comps == nil) {
        
        _comps = [[NSDateComponents alloc] init];
        
    }
    
    return _comps;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)updateDay:(NSArray*)number withSelectArray:(NSArray *)selectArray;
{

//    for (int i=0; i<selectArray.count; i++) {
//        if ([[number componentsJoinedByString:@"-"] isEqualToString:selectArray[i]]||[[number componentsJoinedByString:@"-"] isEqualToString:selectArray[i]]) {
//            if (i==0) {
//                self.number.backgroundColor=[UIColor orangeColor];
//            }
//            else{
//                self.number.backgroundColor=[UIColor purpleColor];
//            }
//        }
//        else
//            self.number.backgroundColor=[UIColor whiteColor];
//    
//    }
    NSDate *date=[self.formatter dateFromString:[@[number[0],number[1],@"01"] componentsJoinedByString:@"-"]];
    NSInteger currentnum=[self getNumberOfDays:[self getPriousorLaterDateFromDate:date withMonth:0]];
    if ([number[2] integerValue]-currentnum>0) {
        self.number.textColor=[UIColor lightGrayColor];
        self.number.userInteractionEnabled=NO;
        self.number.backgroundColor=[UIColor whiteColor];
        NSInteger Day=[number[2] integerValue]-currentnum;
        
        NSString*str =[NSString stringWithFormat:@"%lu",Day];
        self.number.text =str;
    }
    else if([number[2] integerValue]<=0){
        self.number.textColor=[UIColor lightGrayColor];
        self.number.backgroundColor=[UIColor whiteColor];
        self.number.userInteractionEnabled=NO;
        NSDate *date=[self.formatter dateFromString:[@[number[0],number[1],@"01"] componentsJoinedByString:@"-"]];
        NSInteger lastnum=[self getNumberOfDays:[self getPriousorLaterDateFromDate:date withMonth:-1]];
        NSInteger lastDay=[number[2] integerValue]+lastnum;
        
        NSString*str =[NSString stringWithFormat:@"%lu",lastDay];
        self.number.text =str;
    }
    else
    {
        //设置选中是颜色
        if ([selectArray containsObject:[number componentsJoinedByString:@"-"]]) {
            NSInteger index=[selectArray indexOfObject:[number componentsJoinedByString:@"-"]];
            if (index) {
                self.number.backgroundColor=[UIColor purpleColor];
            }
            else
                self.number.backgroundColor=[UIColor orangeColor];
            self.number.textColor=[UIColor whiteColor];
        }
        else
        {
            self.number.backgroundColor=[UIColor whiteColor];
            self.number.textColor=[UIColor blackColor];
        }
        

        self.number.userInteractionEnabled=YES;
        NSString*str =[NSString stringWithFormat:@"%@",number[2]];
        if ([number[2] integerValue]<10) {
            self.number.text = [str stringByReplacingOccurrencesOfString:@"0" withString:@""];
        }
        else
            self.number.text=str;

    }
    self.currentArray = number;
    //设置当天样式
    if ([[number componentsJoinedByString:@"-"] isEqualToString:[self.formatter stringFromDate:[NSDate date]]]) {
        self.number.layer.borderWidth=1;
        self.number.layer.borderColor=THEMECOLOR.CGColor;
    }
    else
    {
        self.number.layer.borderWidth=0;
    }
    
    
}

- (void)updateDay:(NSArray*)number andSelectDate:(NSDate *)selectDate{
    //设置当天样式
    if ([[number componentsJoinedByString:@"-"] isEqualToString:[self.formatter stringFromDate:[NSDate date]]]) {
        self.number.layer.borderWidth=1;
        self.number.layer.borderColor=THEMECOLOR.CGColor;
    }
    else
    {
        self.number.layer.borderWidth=0;
    }
    NSDate *date=[self.formatter dateFromString:[@[number[0],number[1],@"01"] componentsJoinedByString:@"-"]];
    NSInteger currentnum=[self getNumberOfDays:[self getPriousorLaterDateFromDate:date withMonth:0]];
    if ([number[2] integerValue]-currentnum>0) {
        self.number.textColor=[UIColor lightGrayColor];
        self.userInteractionEnabled=NO;
        self.number.backgroundColor=[UIColor whiteColor];
        NSInteger Day=[number[2] integerValue]-currentnum;
        
        NSString*str =[NSString stringWithFormat:@"%lu",Day];
        self.number.text =str;
    }
    else if([number[2] integerValue]<=0){
        self.number.textColor=[UIColor lightGrayColor];
        self.number.backgroundColor=[UIColor whiteColor];
        self.userInteractionEnabled=NO;
        NSDate *date=[self.formatter dateFromString:[@[number[0],number[1],@"01"] componentsJoinedByString:@"-"]];
        NSInteger lastnum=[self getNumberOfDays:[self getPriousorLaterDateFromDate:date withMonth:-1]];
        NSInteger lastDay=[number[2] integerValue]+lastnum;
        
        NSString*str =[NSString stringWithFormat:@"%lu",lastDay];
        self.number.text =str;
    }
    else if ([[self.formatter dateFromString:[number componentsJoinedByString:@"-"]] compare:[NSDate date]]==NSOrderedDescending){
        self.userInteractionEnabled=NO;
        self.number.textColor=[UIColor lightGrayColor];
        self.number.backgroundColor=[UIColor whiteColor];
        NSString*str =[NSString stringWithFormat:@"%@",number[2]];
        if ([number[2] integerValue]<10) {
            self.number.text = [str stringByReplacingOccurrencesOfString:@"0" withString:@""];
        }
        else
            self.number.text=str;

    }
    else
    {

        if ([[number componentsJoinedByString:@"-"] isEqualToString:[self.formatter stringFromDate:selectDate]]) {
            self.number.backgroundColor=[UIColor orangeColor];
            self.number.textColor=[UIColor whiteColor];
        }
        else
        {
            self.number.backgroundColor=[UIColor whiteColor];
            self.number.textColor=[UIColor blackColor];
        }
        self.userInteractionEnabled=YES;
        NSString*str =[NSString stringWithFormat:@"%@",number[2]];
        if ([number[2] integerValue]<10) {
            self.number.text = [str stringByReplacingOccurrencesOfString:@"0" withString:@""];
        }
        else
            self.number.text=str;


    }
}

- (void)updateDay:(NSArray*)number andSelectDate:(NSDate *)selectDate andCanselectArray:(NSArray *)canselectArray{
    //设置当天样式
    if ([[number componentsJoinedByString:@"-"] isEqualToString:[self.formatter stringFromDate:[NSDate date]]]) {
        self.number.layer.borderWidth=1;
        self.number.layer.borderColor=THEMECOLOR.CGColor;
    }
    else
    {
        self.number.layer.borderWidth=0;
    }
    NSDate *date=[self.formatter dateFromString:[@[number[0],number[1],@"01"] componentsJoinedByString:@"-"]];
    NSInteger currentnum=[self getNumberOfDays:[self getPriousorLaterDateFromDate:date withMonth:0]];
    if ([number[2] integerValue]-currentnum>0) {
        self.number.textColor=[UIColor lightGrayColor];
        self.userInteractionEnabled=NO;
        self.number.backgroundColor=[UIColor whiteColor];
        NSInteger Day=[number[2] integerValue]-currentnum;
        
        NSString*str =[NSString stringWithFormat:@"%lu",Day];
        self.number.text =str;
    }
    else if([number[2] integerValue]<=0){
        self.number.textColor=[UIColor lightGrayColor];
        self.number.backgroundColor=[UIColor whiteColor];
        self.userInteractionEnabled=NO;
        NSDate *date=[self.formatter dateFromString:[@[number[0],number[1],@"01"] componentsJoinedByString:@"-"]];
        NSInteger lastnum=[self getNumberOfDays:[self getPriousorLaterDateFromDate:date withMonth:-1]];
        NSInteger lastDay=[number[2] integerValue]+lastnum;
        
        NSString*str =[NSString stringWithFormat:@"%lu",lastDay];
        self.number.text =str;
    }
    else
    {
        if ([[number componentsJoinedByString:@"-"] isEqualToString:[self.formatter stringFromDate:selectDate]]) {
            self.number.backgroundColor=[UIColor orangeColor];
            self.number.textColor=[UIColor whiteColor];
            if ([canselectArray containsObject:[self.formatter stringFromDate:selectDate]]) {
                self.userInteractionEnabled=YES;
            }
            else
                self.userInteractionEnabled=NO;
        }
        else if ([canselectArray containsObject:[number componentsJoinedByString:@"-"]]) {
            self.number.textColor=[UIColor blackColor];
            self.number.backgroundColor=[UIColor whiteColor];
            self.userInteractionEnabled=YES;
        }
        else
        {
            self.number.textColor=[UIColor lightGrayColor];
            self.number.backgroundColor=[UIColor whiteColor];
            self.userInteractionEnabled=NO;
        }
        NSString*str =[NSString stringWithFormat:@"%@",number[2]];
        if ([number[2] integerValue]<10) {
            self.number.text = [str stringByReplacingOccurrencesOfString:@"0" withString:@""];
        }
        else
            self.number.text=str;

    }

}
/**
 *  根据当前月获取有多少天
 *
 *  @param dayDate 但前时间
 *
 *  @return 天数
 */
- (NSInteger)getNumberOfDays:(NSDate *)dayDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dayDate];
    
    return range.length;
    
}
/**
 *  根据前几月获取时间
 *
 *  @param date  当前时间
 *  @param month 第几个月 正数为前  负数为后
 *
 *  @return 获得时间
 */
- (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(NSInteger)month

{
    [self.comps setMonth:month];
    
    NSDate *mDate = [self.calender dateByAddingComponents:self.comps toDate:date options:0];
    return mDate;
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}
@end
