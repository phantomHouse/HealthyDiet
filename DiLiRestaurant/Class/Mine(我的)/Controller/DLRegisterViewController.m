//
//  DLRegisterViewController.m
//  DiLiRestaurant
//
//  Created by 地利 on 2017/3/9.
//  Copyright © 2017年 地利. All rights reserved.
//

#import "DLRegisterViewController.h"

@interface DLRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *TelephoneField;
@property (weak, nonatomic) IBOutlet UIButton *sendNumButton;
@property (weak, nonatomic) IBOutlet UITextField *sendNumField;

@property (weak, nonatomic) IBOutlet UITextField *passworkField;

@property(copy,nonatomic)NSString *recString;
@property (weak, nonatomic) IBOutlet UIButton *registButton;

@end

@implementation DLRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.waytype==RegisterType) {
        self.title=@"注册";
        self.passworkField.placeholder=@"请输入密码";
    }
    else
    {
        self.title=@"忘记密码";
        [self.registButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)registerClick:(UIButton *)sender {
    if (strIsEmpty(self.TelephoneField.text)) {
        [MBProgressHUD showMessage:@"手机号不能为空"];
        return;
    }
    if (![Globel valiMobile:self.TelephoneField.text]) {
        [MBProgressHUD showMessage:@"手机号格式不正确"];
        return;
    }
    if (strIsEmpty(self.sendNumField.text)||![self.sendNumField.text isEqualToString:self.recString]) {
        [MBProgressHUD showMessage:@"验证码错误"];
        return;
    }
    if (self.passworkField.text.length<6) {
        [MBProgressHUD showMessage:@"密码不能小于六位"];
        return;
    }
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:self.TelephoneField.text forKey:@"mobileNum"];
    if (self.waytype==RegisterType) {
        [dic setObject:[self.passworkField.text md5String] forKey:@"password"];
    }
    else
        [dic setObject:[self.passworkField.text md5String] forKey:@"newPassword"];
    [dic setObject:@"C0100" forKey:@"transCode"];
    if (self.waytype==FGPasswordType) {
        dic.type=@"app_uPassword";
    }
    else
        [dic setObject:@"add" forKey:@"type"];
    [[GLNetWorkManager shareManager]requestType:POST andURL:REQUESTURL andServers:REGISTER andParmas:dic andComplition:^(id response, BOOL isuccess) {
        MyLog(@"%@",response);
        if (isuccess) {
            if ([response[@"code"] isEqualToString:@"000000"]) {
                if (self.registerSuccess) {
                    self.registerSuccess(self.TelephoneField.text,self.passworkField.text);
                    [MBProgressHUD showMessage:@"注册成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }
            else
                [MBProgressHUD showMessage:response[@"message"]];
        }
    }];
}

- (IBAction)eyeClick:(UIButton *)sender {
    sender.selected=!sender.selected;
    self.passworkField.secureTextEntry=sender.isSelected;
}
- (IBAction)sendNumClick:(UIButton *)sender {
    if ([Globel valiMobile:self.TelephoneField.text]) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setObject:@1 forKey:@"bizType"];
        [dic setObject:self.TelephoneField.text forKey:@"mobileNum"];
        [dic setObject:@"M0053" forKey:@"transCode"];
        [dic setObject:@"sendPhoneMes" forKey:@"type"];
        [[GLNetWorkManager shareManager]requestType:POST andURL:REQUESTURL andServers:SMSCODE andParmas:dic andComplition:^(id response, BOOL isuccess) {
            if (isuccess) {
                if ([response[@"code"] isEqualToString:@"000000"]) {
                    [self startTime:sender];
                    self.recString=response[@"sendResponse"][@"smsCode"];
                    MyLog(@"%@",self.recString);
                }
            }
        }];
    }
    else
        [MBProgressHUD showMessage:@"手机号格式不正确"];
}
//倒计时
-(void)startTime:(UIButton *)sender{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                sender.userInteractionEnabled = YES;
                sender.backgroundColor = THEMECOLOR;
            });
        }else{

            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [UIView animateWithDuration:1.0 animations:^{
                    [sender setTitle:[NSString stringWithFormat:@"%iS",timeout] forState:UIControlStateNormal];
                }];
                sender.backgroundColor = shouldgraycolor;
                sender.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *toBestring=textField.text;
    NSCharacterSet *cs;
    
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
    NSString *filtered =[[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL basic = [string isEqualToString:filtered];
    if (basic) {
        if (toBestring.length>=26) {
            textField.text=[toBestring substringToIndex:25];
            [MBProgressHUD showMessage:@"密码不能超出26位"];
            return NO;
        }
        else
            return YES;
    }
    return basic;

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.passworkField) {
        if (textField.text.length<6) {
            [MBProgressHUD showMessage:@"密码不能小于6位"];
        }
    }
}
@end
