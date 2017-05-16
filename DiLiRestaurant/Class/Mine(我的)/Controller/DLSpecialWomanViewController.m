//
//  DLFlavorViewController.m
//  DiLiRestaurant
//
//  Created by 地利 on 2017/3/15.
//  Copyright © 2017年 地利. All rights reserved.
//

#import "DLSpecialWomanViewController.h"
#import "DLTabooTableViewCell.h"

@interface DLSpecialWomanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(weak,nonatomic)UITableView *tableView;

@property(weak,nonatomic)UIButton *selectBotton;

@end

@implementation DLSpecialWomanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"特殊人群";
    self.baseValue=[DLUserInfo getUserDetail].specialCrowdCode;
    self.titleLabel.text=@"请选择您当前所在的状态";
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

- (void)getData{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic.transCode=@"M0038";
    dic.type=@"findAll";
    [dic setObject:@20 forKey:@"dictType"];
    //    [dic setObject:@1 forKey:@"isShow"];
    //    [dic setObject:@1 forKey:@"status"];
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
    DLTabooInfo *tabooinfo=self.dataArray[indexPath.row];
    cell.tabooInfo=tabooinfo;
    __weak typeof(self) unself=self;
    if (tabooinfo.isSelect) {
        self.selectBotton=cell.CheckButton;
        self.selectBotton.tag=indexPath.row;
    }
    cell.RadioBlock=^(UIButton *sender){
        if (unself.selectBotton!=sender&&self.selectBotton) {
           unself.selectBotton.selected=NO;
            DLTabooInfo *info=self.dataArray[unself.selectBotton.tag];
            info.isSelect=NO;
        }
        unself.selectBotton=sender;
        unself.selectBotton.tag=indexPath.row;
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]init];
    //    view.backgroundColor=[UIColor whiteColor];
    self.doneButton.frame=CGRectMake(50, 20, kScreenW-100, 40);
    [view addSubview:self.doneButton];
    if (self.type==FirstType) {
        CGRect rect=self.doneButton.frame;
        rect.origin.y+=60;
        self.skipButton.frame=rect;
        [view addSubview:self.skipButton];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.type==OtherType) {
        return 60;
    }
    return 100;
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
        [self updateInfofromKey:@"specialCrowdCode" andValue:[selectArray componentsJoinedByString:@","]];
        
    }
    else
    {
        [DLUser share].specialCrowdCode=[selectArray componentsJoinedByString:@","];
        DLMineBaseViewController *baseVC=HasSelect==YES?[[NSClassFromString(@"DLOtherDemandViewController")alloc]init]:[[NSClassFromString(@"DLPhysiologyChioceViewController")alloc]init];
        baseVC.type=FirstType;
        [self.navigationController pushViewController:baseVC animated:YES];
    }
    

}

@end
