//
//  DLAddFoodDetailViewController.m
//  DiLiRestaurant
//
//  Created by 地利 on 2017/4/1.
//  Copyright © 2017年 地利. All rights reserved.
//

#import "DLAddStoreFoodListViewController.h"

#import "DLStoreFoodsTableViewCell.h"
#import "TableViewHeaderView.h"
#import "DLFoodDetailViewController.h"
#import "DLSearchFoodsViewController.h"
@interface DLAddStoreFoodListViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}

@property (nonatomic, weak) UITableView *leftTableView;
@property (nonatomic, weak) UITableView *rightTableView;
@property(strong,nonatomic)NSMutableArray <DLAllergyDetailInfo *>*selectInfoArray;
@end

@implementation DLAddStoreFoodListViewController

- (NSMutableArray<DLAllergyDetailInfo *> *)selectInfoArray
{
    if (!_selectInfoArray) {
        _selectInfoArray=[NSMutableArray array];
    }
    return _selectInfoArray;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectIndex = 0;
    _isScrollDown = YES;
    self.view.backgroundColor=BackGroundColor;
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    headView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:headView];
    UITextField *textfield=[[UITextField alloc]initWithFrame:CGRectMake(20, 5, kScreenW-40, 40)];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageView.image=[UIImage imageNamed:@"search_icon"];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    textfield.leftView=imageView;

    textfield.leftViewMode=UITextFieldViewModeAlways;
    textfield.borderStyle=UITextBorderStyleRoundedRect;
    textfield.placeholder=self.eatType==StoreType?@"请输入门店食物类型":@"请输入食物类型";
    textfield.delegate=self;
    [headView addSubview:textfield];
    
    
//    UIView *footView=[[UIView alloc]init];
//    [self.view addSubview:footView];
//    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
//        (void)make.left;
//        (void)make.bottom;
//        (void)make.right;
//        make.height.mas_equalTo(@60);
//    }];
//    UIButton *finishButton=[[UIButton alloc]initWithFrame:CGRectMake((kScreenW-200)/2, 8, 200, 44)];
//    finishButton.layer.cornerRadius=22;
//    finishButton.layer.masksToBounds=YES;
//    finishButton.backgroundColor=THEMECOLOR;
//    [finishButton setImage:[UIImage imageNamed:@"foodsfinish"] forState:UIControlStateNormal];
//    [finishButton setTitle:@"完成添加" forState:UIControlStateNormal];
//    [footView addSubview:finishButton];
    
    UITableView *lefttableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    lefttableView.delegate=self;
    lefttableView.dataSource=self;
    lefttableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:lefttableView];
    self.leftTableView=lefttableView;
    [lefttableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom).mas_offset(10);
        (void)make.left;
        (void)make.bottom;
        make.width.mas_equalTo(@100);
    }];
    UITableView *rightTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    rightTableView.delegate=self;
    rightTableView.dataSource=self;
    rightTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:rightTableView];
    self.rightTableView=rightTableView;
    [rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom).mas_offset(10);
        (void)make.right;
        (void)make.bottom;
        make.left.mas_equalTo(lefttableView.mas_right);
    }];
    
    [lefttableView registerNib:[UINib nibWithNibName:NSStringFromClass([DLAllergyCategaryTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"left"];
    [rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DLStoreFoodsTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"foods"];
    
    [self getData];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_leftTableView == tableView)
    {
        return 1;
    }
    else
    {
        return self.dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_leftTableView == tableView)
    {
        return self.dataArray.count;
    }
    else
    {
        DLStoreCategaryInfo *Info=self.dataArray[section];
        return Info.dishesSupplyDtlList.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.leftTableView) {
        return 80;
    }
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.leftTableView) {
        DLAllergyCategaryTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"left" forIndexPath:indexPath];
        cell.categaryInfo=self.dataArray[indexPath.row];
        return cell;
    }
    else
    {
        DLStoreFoodsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"foods" forIndexPath:indexPath];
        DLStoreCategaryInfo *info=self.dataArray[indexPath.section];
        cell.eatType=StoreType;
        cell.foodsInfo=info.dishesSupplyDtlList[indexPath.row];
//        __weak typeof(self) unself=self;
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_rightTableView == tableView)
    {
        return 20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_rightTableView == tableView)
    {
        TableViewHeaderView *view = [[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
        DLStoreCategaryInfo *model = self.dataArray[section];
        view.name.text = model.dishesTypeName;
        return view;
    }
    return nil;
}

// TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向上，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView) && !_isScrollDown && _rightTableView.dragging)
    {
        [self selectRowAtIndexPath:section];
    }
}


// TableView分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向下，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView) && _isScrollDown && _rightTableView.dragging)
    {
        [self selectRowAtIndexPath:section + 1];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        _selectIndex = indexPath.row;
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else
    {
        DLStoreCategaryInfo *info=self.dataArray[indexPath.section];
        DLFoodDetailViewController *detailVC=[[DLFoodDetailViewController alloc]init];
        detailVC.foodsCode=info.dishesSupplyDtlList[indexPath.row].dishesCode;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

// 当拖动右边TableView的时候，处理左边TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - UISrcollViewDelegate
// 标记一下RightTableView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastOffsetY = 0;
    
    UITableView *tableView = (UITableView *) scrollView;
    if (_rightTableView == tableView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

- (void)getData{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic.transCode=@"C0112";
    dic.type=@"findAll";
    if (self.eatType==StoreType) {
        [dic setObject:[DLUserInfo getUserStore].storeId forKey:@"storeId"];
    }
    [dic setObject:@(self.Eatingtime+20000) forKey:@"mealTypeCode"];
    [dic setObject:self.currentDate forKey:@"templateDate"];
    [dic setObject:@1 forKey:@"status"];
    [dic setObject:[DLUserInfo getUser].userId forKey:@"userId"];
    [[GLNetWorkManager shareManager]requestType:POST andURL:REQUESTURL andServers:GET_WORK_TYPE andParmas:dic andComplition:^(id response, BOOL isuccess) {
        if (isuccess&&[response[@"code"] isEqualToString:SUCCESSCODE]) {
            [DLStoreCategaryInfo mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"dishesSupplyDtlList":@"DLStorefoodsInfo"};
            }];
            
            [DLStorefoodsInfo mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"accessoriesList":@"DLStorefoodsDetailInfo"};
            }];
            [self.dataArray addObjectsFromArray:[DLStoreCategaryInfo mj_objectArrayWithKeyValuesArray:response[@"json"][@"dishesSupplyList"]]];
            
            if (self.dataArray.count) {
                [self.leftTableView reloadData];
                [self.rightTableView reloadData];
                [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            }
            else
                [self NoDateView];

        }
        
        MyLog(@"%@",response);
    }];
}
- (void)NoDateView{
    UILabel *label=[[UILabel alloc]init];
    label.text=[NSString stringWithFormat:@"抱歉,门店今天无餐饮服务!"];
    label.textColor=[UIColor lightGrayColor];
    label.textAlignment=NSTextAlignmentCenter;
    [label sizeToFit];
    label.center=self.view.center;
    [self.view addSubview:label];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    DLSearchFoodsViewController *searchVC=[[DLSearchFoodsViewController alloc]init];
    searchVC.eatType=StoreType;
    searchVC.curentdate=self.currentDate;
    searchVC.timeType=self.Eatingtime;
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}

@end
