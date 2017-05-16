//
//  DLAllergyChioceViewController.m
//  DiLiRestaurant
//
//  Created by 地利 on 2017/3/15.
//  Copyright © 2017年 地利. All rights reserved.
//

#import "DLAllergyChioceViewController.h"
#import "DLAllergyCategaryTableViewCell.h"
#import "DLAllergyDetailTableViewCell.h"
#import "TableViewHeaderView.h"
@interface DLAllergyChioceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}
@property(weak,nonatomic)UIView *headView;
@property(weak,nonatomic)UIView *mainView;
@property (nonatomic, weak) UITableView *leftTableView;
@property (nonatomic, weak) UITableView *rightTableView;
@property(strong,nonatomic)NSMutableArray <DLAllergyDetailInfo *>*selectInfoArray;
@end

@implementation DLAllergyChioceViewController

- (NSMutableArray<DLAllergyDetailInfo *> *)selectInfoArray
{
    if (!_selectInfoArray) {
        _selectInfoArray=[NSMutableArray array];
    }
    return _selectInfoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectIndex = 0;
    _isScrollDown = YES;
    self.baseValue=[DLUserInfo getUserDetail].allergyName;
    [self getData];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(test)];
    UIView *headview=[[UIView alloc]init];
    headview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:headview];
    self.headView=headview;
    [headview mas_makeConstraints:^(MASConstraintMaker *make) {
        (void)make.top;
        (void)make.left;
        (void)make.right;
        make.height.mas_equalTo(@0);
    }];
    
    UIView *mainview=[[UIView alloc]init];
    mainview.backgroundColor=[UIColor redColor];
    [self.view addSubview:mainview];
    self.mainView=mainview;

    
    UIView *footView=[[UIView alloc]init];
    footView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:footView];
    self.doneButton.frame=CGRectMake(50, 8, kScreenW-100, 44);
    [footView addSubview:self.doneButton];
    CGFloat bottomH=60;
//    if (self.type==FirstType) {
//        bottomH=120;
//        CGRect rect=self.doneButton.frame;
//        rect.origin.y+=60;
//        self.skipButton.frame=rect;
//        [footView addSubview:self.skipButton];
//
//    }
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        (void)make.bottom;
        (void)make.left;
        (void)make.right;
        make.height.mas_equalTo(@(bottomH));
    }];
    
    [mainview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headview.mas_bottom);
        make.bottom.mas_equalTo(footView.mas_top);
        (void)make.left;
        (void)make.right;
    }];
    UITableView *lefttableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    lefttableView.delegate=self;
    lefttableView.dataSource=self;
    [mainview addSubview:lefttableView];
    self.leftTableView=lefttableView;
    [lefttableView mas_makeConstraints:^(MASConstraintMaker *make) {
        (void)make.top;
        (void)make.left;
        (void)make.bottom;
        make.width.mas_equalTo(@100);
    }];
    UITableView *rightTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    rightTableView.delegate=self;
    rightTableView.dataSource=self;
    [mainview addSubview:rightTableView];
    self.rightTableView=rightTableView;
    [rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        (void)make.top;
        (void)make.right;
        (void)make.bottom;
        make.left.mas_equalTo(lefttableView.mas_right);
    }];
    
    [lefttableView registerNib:[UINib nibWithNibName:NSStringFromClass([DLAllergyCategaryTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"left"];
    [rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DLAllergyDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"right"];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeHeadView{
    for (UILabel *obj in self.headView.subviews) {
        [obj removeFromSuperview];
    }
    NSInteger num=5;
    CGFloat height=40*(self.selectInfoArray.count%num==0?self.selectInfoArray.count/num:self.selectInfoArray.count/num+1);
    CGFloat margin=10;
    for (int i=0; i<self.selectInfoArray.count; i++) {
        CGFloat lableW=[Globel getSizeOfString:self.selectInfoArray[i].allergyName maxWidth:CGFLOAT_MAX maxHeight:20 withFontSize:12].width;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(margin+(i%num)*((kScreenW-(num+1)*10)/num+10), i/num*40+8, lableW+20, 24)];
        label.textAlignment=NSTextAlignmentCenter;
        label.userInteractionEnabled=YES;
        label.text=self.selectInfoArray[i].allergyName;
        label.font=font12;
        label.tag=i;
        label.layer.cornerRadius=12;
        label.layer.borderColor=RGBColor(236, 77, 0).CGColor;
        label.textColor=RGBColor(236, 77, 0);
        label.layer.borderWidth=1.0;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleSelect:)];
        [label addGestureRecognizer:tap];
        [self.headView addSubview:label];
    }
    
    [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(height));
    }];
    // 通知需要更新约束，但是不立即执行
    [self.view setNeedsUpdateConstraints];
    // 立即更新约束，以执行动态变换
    // update constraints now so we can animate the change
    [self.view updateConstraintsIfNeeded];
    // 执行动画效果, 设置动画时间
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)cancleSelect:(UITapGestureRecognizer *)sender{
    DLAllergyDetailInfo *info=self.selectInfoArray[sender.view.tag];
    info.isSelect=NO;
    [self.selectInfoArray removeObject:info];
    [self changeHeadView];
    [self.rightTableView reloadData];
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
        DLAllergyInfo *allergyInfo=self.dataArray[section];
        return allergyInfo.list.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.leftTableView) {
        return 80;
    }
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.leftTableView) {
        DLAllergyCategaryTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"left" forIndexPath:indexPath];
        cell.allergyInfo=self.dataArray[indexPath.row];
        return cell;
    }
    else
    {
        DLAllergyDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"right" forIndexPath:indexPath];
        DLAllergyInfo *allergyinfo=self.dataArray[indexPath.section];
        cell.detailInfo=allergyinfo.list[indexPath.row];
        __weak typeof(self) unself=self;
        cell.selectClick=^(DLAllergyDetailInfo *info,BOOL isselect){
            if (isselect) {
                [unself.selectInfoArray addObject:info];
            }
            else
                [unself.selectInfoArray removeObject:info];
            [unself changeHeadView];
        };
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
        DLAllergyInfo *model = self.dataArray[section];
        view.name.text = model.allergyType1;
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
    dic.transCode=@"M0064";
    dic.type=@"findAllAllergy";
    [dic setObject:@1 forKey:@"status"];
    [[GLNetWorkManager shareManager]requestType:POST andURL:REQUESTURL andServers:GET_WORK_TYPE andParmas:dic andComplition:^(id response, BOOL isuccess) {
        if (isuccess&&[response[@"code"] isEqualToString:SUCCESSCODE]) {
            [DLAllergyDetailInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            [DLAllergyInfo mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"list":@"DLAllergyDetailInfo"};
            }];
            [self.dataArray addObjectsFromArray:[DLAllergyInfo mj_objectArrayWithKeyValuesArray:response[@"list"]]];
            if (!strIsEmpty(self.baseValue)) {
                NSArray *selectCode=[self.baseValue componentsSeparatedByString:@","];
                [selectCode enumerateObjectsUsingBlock:^(NSString *code, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.dataArray enumerateObjectsUsingBlock:^(DLAllergyInfo   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [obj.list enumerateObjectsUsingBlock:^(DLAllergyDetailInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([code isEqualToString:obj.allergyName]) {
                                obj.isSelect=YES;
                                [self.selectInfoArray addObject:obj];
                            }
                        }];

                    }];
                }];
            }
            if (self.selectInfoArray.count) {
                [self changeHeadView];
            }
            [self.leftTableView reloadData];
            [self.rightTableView reloadData];
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        
        MyLog(@"%@",response);
    }];
}
- (void)done
{
    [super done];
    NSMutableArray *AllName=[NSMutableArray array];
    for (DLAllergyDetailInfo *info in self.selectInfoArray) {
        [AllName addObject:info.allergyName];
    }
    if (self.type==FirstType) {
        [DLUser share].allergyName=[AllName componentsJoinedByString:@","];
        DLMineBaseViewController *baseVC=[[NSClassFromString(@"DLNativePlaceChioceViewController")alloc]init];
        baseVC.type=FirstType;
        [self.navigationController pushViewController:baseVC animated:YES];
        
    }
    else
    {
        [self updateInfofromKey:@"allergyName" andValue:[AllName componentsJoinedByString:@","]];
    }
}
@end
