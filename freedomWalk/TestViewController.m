//
//  TestViewController.m
//  Nearby
//
//  Created by xwbb on 15/12/7.
//  Copyright © 2015年 Mr.Y. All rights reserved.
//

#import "TestViewController.h"
#import "PanoramaViewController.h"
#import "BMKPoiInfos.h"
#import "MJRefresh.h"
#import "ParkCell.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface TestViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@end

@implementation TestViewController

- (NSMutableArray *)infoData{
    if (_infoData == nil) {
        _infoData = [NSMutableArray array];
    }
    return _infoData;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor colorWithRed:234/255.0 green:240/255.0 blue:243/255.0 alpha:1.0]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _searcher.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    NSLog(@"%@",self.infoData);
    //创建 TableView
    [self _createTableView];
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoNavi:) name:@"goto_Navi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPanoNavi:) name:@"openPano_Navi" object:nil];
}

- (void)footerRereshing{
    //通知代理
    if ([self.delegate respondsToSelector:@selector(loadMoreData)]) {
        [self.delegate loadMoreData];
    }
    
    //刷新表格
    [_tableView reloadData];
    
    [_tableView.mj_footer endRefreshing];
}

//创建导航栏
- (void)setupNav {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 11, 19);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_pic"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn addTarget:self action:@selector(backBTNclick) forControlEvents:UIControlEventTouchUpInside];
}

//返回按钮点击
- (void)backBTNclick{
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 创建 TableView
- (void)_createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册单元格
    [_tableView registerNib:[UINib nibWithNibName:@"ParkCell" bundle:nil] forCellReuseIdentifier:@"Park_Cell"];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
    [self.view addSubview:_tableView];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.infoData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ParkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Park_Cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.infos = self.infoData[indexPath.section];
    cell.numLabel.text = [NSString stringWithFormat:@"%ld.",indexPath.section+1];
    
    return cell;
}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    } else
    {
        return 0.00001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

#pragma mark - 通知
- (void)gotoNavi:(NSNotification *)notifi
{
    _end = notifi.object;
    NSLog(@"end:%@",_end);
    
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    //    发起反向地理编码检索
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = _userLocation.location.coordinate;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

- (void)openPanoNavi:(NSNotification *)notifi
{
    CLLocationCoordinate2D pt;
    [notifi.object getValue:&pt];
    
    PanoramaViewController *panoVC = [[PanoramaViewController alloc] init];
    panoVC.panoLC = pt;
    
    [self.navigationController pushViewController:panoVC animated:YES];
}

#pragma mark - ReverseGeoCode Delegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableString *mStr = [NSMutableString stringWithFormat:@"%@",result.addressDetail.province];
        [mStr appendFormat:@"%@",result.addressDetail.city];
        [mStr appendFormat:@"%@",result.addressDetail.district];
        [mStr appendFormat:@"%@",result.addressDetail.streetName];
        [mStr appendFormat:@"%@",result.addressDetail.streetNumber];
        _star = [NSString stringWithString:mStr];
        
        NSDictionary *dic = @{
                              @"star":_star,
                              @"end":_end
                              };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goto_Infos_twice" object:self userInfo:dic];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

@end
