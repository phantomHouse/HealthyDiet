//
//  DLStoreFoodsTableViewCell.m
//  DiLiRestaurant
//
//  Created by 地利 on 2017/4/1.
//  Copyright © 2017年 地利. All rights reserved.
//

#import "DLStoreFoodsTableViewCell.h"
#import "PPNumberButton.h"
#import "DLEatingButton.h"
@interface DLStoreFoodsTableViewCell ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fooddetaliLabel;

@property (weak, nonatomic) IBOutlet UITextField *customField;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet DLEatingButton *evaluateButton;

@property(weak,nonatomic)PPNumberButton *numButton;

@end
@implementation DLStoreFoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.evaluateButton.layer.borderColor=[UIColor redColor].CGColor;
    self.customField.delegate=self;
    PPNumberButton *button=[[PPNumberButton alloc]init];
    button.decreaseHide=YES;
    button.increaseImage = [UIImage imageNamed:@"add_dishes_normal"];
    button.decreaseImage = [UIImage imageNamed:@"reduce_pressed"];
    [self.contentView addSubview:button];
    self.numButton=button;
    __weak typeof(button) unbutton=button;
    __weak typeof(self) unself=self;
    button.resultBlock=^(NSInteger number, BOOL increaseStatus/* 是否为加状态*/){
        if (increaseStatus) {
            unbutton.increaseImage=[UIImage imageNamed:@"add_dish_pressed"];
        }
        else if (!number){
            unbutton.increaseImage = [UIImage imageNamed:@"add_dishes_normal"];
        }
        if (self.eatType==CustomType) {
            unself.customField.hidden=!number;
        }
        unself.foodsInfo.selectNum=number;
        
    };
    // Initialization code
}
- (void)setIsStore:(BOOL)isStore
{
    _isStore=isStore;
    self.evaluateButton.hidden=!isStore;
}
- (void)setFoodsInfo:(DLStorefoodsInfo *)foodsInfo
{
    _foodsInfo=foodsInfo;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:foodsInfo.imagesURL1] placeholderImage:[UIImage imageNamed:@"food_icon_default"]];
    self.nameLabel.text=foodsInfo.dishesName;
    NSString *str=foodsInfo.accessoriesList.count?[NSString stringWithFormat:@"%@+%@",foodsInfo.ingredients.foodName,foodsInfo.accessoriesList[0].foodName]:foodsInfo.ingredients.foodName;
    self.fooddetaliLabel.text=[NSString stringWithFormat:@"配料:%@",str];
    if (foodsInfo.customWeight) {
        self.customField.text=[NSString stringWithFormat:@"%lu",foodsInfo.customWeight];
    }else
        self.customField.text=@"";
    
    self.numButton.currentNumber=foodsInfo.selectNum;
    if (self.eatType==CustomType) {
       self.customField.hidden=!foodsInfo.selectNum;
    }
    if (!self.eatType) {
        self.numButton.hidden=YES;
    }
    if (foodsInfo.selectNum) {
        self.numButton.increaseImage=[UIImage imageNamed:@"add_dish_pressed"];
    }else
    {
        self.numButton.increaseImage = [UIImage imageNamed:@"add_dishes_normal"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.numButton.frame=CGRectMake(self.contentView.width-110, self.contentView.height-35, 100, 30);
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.foodsInfo.customWeight=[textField.text integerValue];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
- (IBAction)evaluateClick:(DLEatingButton *)sender {
    if (self.commitBlock) {
        self.commitBlock(self.foodsInfo);
    }
}

@end
