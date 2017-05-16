//
//  DLTabooChioceViewController.m
//  DiLiRestaurant
//
//  Created by 地利 on 2017/3/15.
//  Copyright © 2017年 地利. All rights reserved.
//

#import "DLTabooChioceViewController.h"
#import "DLTabooTableViewCell.h"
@interface DLTabooChioceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(weak,nonatomic)UITableView *tableView;
@end

@implementation DLTabooChioceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseValue=[DLUserInfo getUserDetail].tabooCode;
    self.titleLabel.text=@"请选择您的饮食禁忌";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 60, kScreenW, kScreenH-64-60) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.ContentView addSubview:tableView];
    self.tableView=tableView;
    tableView.backgroundColor=[UIColor clearColor];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DLTabooTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"check"];
    [self getData];
    // Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLTabooTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"check" forIndexPath:indexPath];
    cell.tabooInfo=self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)getData{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic.transCode=@"M0038";
    dic.type=@"findAll";
    [dic setObject:@4 forKey:@"dictType"];
    [dic setObject:@1 forKey:@"isShow"];
    [dic setObject:@1 forKey:@"status"];
    [[GLNetWorkManager shareManager]requestType:POST andURL:REQUESTURL andServers:GET_WORK_TYPE andParmas:dic andComplition:^(id response, BOOL isuccess) {
        if (isuccess&&[response[@"code"] isEqualToString:SUCCESSCODE]) {
            [self.dataArray addObjectsFromArray:[DLTabooInfo mj_objectArrayWithKeyValuesArray:response[@"list"]]];
            if (!strIsEmpty(self.baseValue)) {
                NSArray *selectCode=[self.baseValue componentsSeparatedByString:@","];
                [selectCode enumerateObjectsUsingBlock:^(NSString *code, NSUInteger idx, BOOL * _Nonnull stop) {
                   [self.dataArray enumerateObjectsUsingBlock:^(DLTabooInfo   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                       if ([code isEqualToString:obj.code]) {
                           obj.isSelect=YES;
                       }
                   }];
                }];
            }
            [self.tableView reloadData];
        }
        
        MyLog(@"%@",response);
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]init];
//    view.backgroundColor=[UIColor whiteColor];
    self.doneButton.frame=CGRectMake(50, 20, kScreenW-100, 40);
    [view addSubview:self.doneButton];
//    if (self.type==FirstType) {
//        CGRect rect=self.doneButton.frame;
//        rect.origin.y+=60;
//        self.skipButton.frame=rect;
//        [view addSubview:self.skipButton];
//    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (self.type==OtherType) {
        return 60;
//    }
//    return 100;
}

- (void)done
{
    [super done];
    NSMutableArray *selectArray=[NSMutableArray array];
    BOOL HasSelect=NO;
    for (DLTabooInfo *obj in self.dataArray) {
        if (obj.isSelect) {
            HasSelect=YES;
            [selectArray addObject:obj.code];
        }
    }
    if (self.type==OtherType) {
        [self updateInfofromKey:@"tabooCode" andValue:[selectArray componentsJoinedByString:@","]];
    }
    else
    {
        [DLUser share].tabooCode=[selectArray componentsJoinedByString:@","];
        DLMineBaseViewController *baseVC=[[NSClassFromString(@"DLAllergyChioceViewController")alloc]init];
        baseVC.type=FirstType;
        [self.navigationController pushViewController:baseVC animated:YES];
    }
    
}
@end
