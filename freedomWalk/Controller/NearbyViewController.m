//
//  NearbyViewController.m
//  Nearby
//
//  Created by xwbb on 15/12/4.
//  Copyright © 2015年 Mr.Y. All rights reserved.
//

#import "NearbyViewController.h"
#import "ParkViewController.h"
#import "DetailViewController.h"

#import "IntroduceCell.h"
#import "CollectionCell.h"
#import "NearbyListModel.h"
#import "CustomTextField.h"

#import "SearchNearbyController.h"
#import "YCNavController.h"
#import "TestViewController.h"

#import "BMKPoiInfos.h"
#import "MBProgressHUD+MJ.h"
#import "UIViewExt.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kNavigationBarH 64

static NSString *identifier = @"CollectionCell";

@interface NearbyViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,BMKPoiSearchDelegate,TestViewControllerDelegate>
{
    UITableView *_tableView;
    NSArray *_imageNames;
    NSMutableArray *_dataArray;
}

@end

@implementation NearbyViewController

- (NSMutableArray *)infoDatas{
    if (_infoDatas == nil) {
        _infoDatas = [NSMutableArray array];
    }
    return _infoDatas;
}


- (void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor colorWithRed:234/255.0 green:240/255.0 blue:243/255.0 alpha:1.0]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _imageNames = @[@"美食",@"酒店",@"电影",@"银行",@"公交站",@"景点",@"KTV",@"停车场"];
    _dataArray = [NSMutableArray array];
 
    self.searchSome = 0;
    [self searchNearbyWithTitle:@"住宿"];
    
    //加载数据
    [self loadData];
    
    
    //创建表视图
    [self _createTableView];
    
    //导航栏
    [self _createNavigationBar];
}

- (void)loadData
{
    for (NSString *str in _imageNames) {
        NearbyListModel *model = [[NearbyListModel alloc] init];
        model.imageName = str;
        model.title = str;
        
        [_dataArray addObject:model];
    }
}

- (void)_createNavigationBar
{
    //搜索框
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
    CustomTextField *textField = [[CustomTextField alloc] initWithFrame:CGRectMake(-50, 0, kScreenWidth * 0.7, 28) withPlaceholder:@"我的附近搜索" withLeftView:imageView];
    
    textField.backgroundColor = [UIColor whiteColor];
    imageView.image = [UIImage imageNamed:@"02"];
    textField.leftView = imageView;
    textField.leftViewMode = UITextFieldViewModeUnlessEditing;
    self.navigationItem.titleView = textField;
    textField.delegate = self;
    
    /*
    //返回键
    UIButton *leftButt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 11, 19)];
    [leftButt setImage:[UIImage imageNamed:@"back_pic"] forState:UIControlStateNormal];
    [leftButt addTarget:self action:@selector(BackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButt];
    self.navigationItem.leftBarButtonItem = leftItem;
     */
}

//进入搜索界面 并传递位置信息
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    SearchNearbyController *searchView = [[SearchNearbyController alloc] init];
    searchView.view.backgroundColor = [UIColor whiteColor];
    searchView.userLocation = self.userLocation;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:searchView animated:YES];
    
//    YCNavController *searchNav = [[YCNavController alloc] initWithRootViewController:searchView];
//    [self.navigationController presentViewController:searchNav animated:YES completion:^{
//        [self.view endEditing:YES];
//    }];
}



#pragma mark - Button Action
- (void)BackAction:(UIButton *)butt
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建 TableView
- (void)_createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    //234 241 244
    _tableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:241/255.0 blue:244/255.0 alpha:1];
    
    //注册TableView单元格
    [_tableView registerNib:[UINib nibWithNibName:@"IntroduceCell" bundle:nil] forCellReuseIdentifier:@"Introduce_Cell"];
    
    [self.view addSubview:_tableView];
    [_tableView reloadData];

}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.infoDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    IntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Introduce_Cell" forIndexPath:indexPath];
    NSLog(@"%@",self.infoDatas);
    if(self.infoDatas.count != 0){
        BMKPoiInfos *infos = self.infoDatas[indexPath.row];
        cell.name.text = infos.name;
        cell.adresss.text = infos.address;
        cell.distance.text = [NSString stringWithFormat:@"%.1fm",infos.distance];
    }
    return cell;
}

#pragma mark - UITableView Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2.7)];
//    view.backgroundColor = [UIColor redColor];

#pragma mark UICollectionView
    //创建布局视图
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局属性
    flowLayout.itemSize = CGSizeMake((kScreenWidth - 50)/4, (view.bounds.size.height - 20) / 2);
    //创建collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2.5) collectionViewLayout:flowLayout];
    //设置代理
    collectionView.dataSource =self;
    collectionView.delegate = self;
    //设置属性
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.scrollEnabled = NO;
    
    //注册单元格
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    
    [view addSubview:collectionView];
    
#pragma mark UILabel
    UILabel *hearderL = [[UILabel alloc] initWithFrame:CGRectMake(0, collectionView.bottom, kScreenWidth, 30)];
    hearderL.text = @"  附近推荐";
    hearderL.font = [UIFont boldSystemFontOfSize:20];
    [view addSubview:hearderL];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 230;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DetailViewController *detailVC = [[DetailViewController alloc] init];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:detailVC];
//    
//    [self presentViewController:navi animated:YES completion:nil];
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BMKPoiInfos *infos = self.infoDatas[indexPath.row];
    BMKPoiDetailSearchOption *detail = [[BMKPoiDetailSearchOption alloc] init];
    detail.poiUid = infos.uid;
    
    BOOL falg = [_poisearch poiDetailSearch:detail];
    if(falg)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    
}

- (void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
    NSLog(@"%.1f",poiDetailResult.overallRating);
    UIWebView *web = [[UIWebView alloc] init];
    web.frame = CGRectMake(0, 64, self.view.frame.size.width,self.view.frame.size.height-64);
    
    NSURL *url = [NSURL URLWithString:poiDetailResult.detailUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];
}


#pragma mark - UICollectionViewDataSource
//返回个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _dataArray.count;
}

//返回单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.model = _dataArray[indexPath.item];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NearbyListModel *item = _dataArray[indexPath.item];
    self.infoDatas = nil;//重置搜索
    self.curPage = 0;
    
    [MBProgressHUD showMessage:@"杰哥正在帮你加载.."];
    [self searchNearbyWithTitle:item.title];
    NSLog(@"%@",item.title);
}

- (void)loadMoreData{
    self.curPage++;
    [self searchNearbyWithTitle:self.mySearch];
}

- (void)searchNearbyWithTitle:(NSString *)title{
    _poisearch = [[BMKPoiSearch alloc] init];
    _poisearch.delegate = self;
    self.mySearch = title;
    BMKNearbySearchOption *nearbySearchOption = [[BMKNearbySearchOption alloc] init];
    nearbySearchOption.pageIndex = self.curPage;
    nearbySearchOption.pageCapacity = 20;
    nearbySearchOption.location = self.userLocation.location.coordinate;
    nearbySearchOption.keyword = self.mySearch;
    
    //        NSLog(@"%@",self.myLoc);
    NSLog(@"%@",title);
    
    BOOL flag = [_poisearch poiSearchNearBy:nearbySearchOption];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    

}


//处理搜索结果
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        
        //在此处理正常结果
        for (int i = 0; i < poiResult.poiInfoList.count; i++) {
            BMKPoiInfo *poi = [poiResult.poiInfoList objectAtIndex:i];
            
            //传递数据给模型
            BMKPoiInfos *poiInfos = [[BMKPoiInfos alloc] init];
            poiInfos.name = poi.name;
            poiInfos.uid = poi.uid;
            poiInfos.address = poi.address;
            poiInfos.city = poi.city;
            poiInfos.epoitype = poi.epoitype;
            poiInfos.pt = poi.pt;
            
            //两点距离
            BMKMapPoint point1 = BMKMapPointForCoordinate(self.userLocation.location.coordinate);
            BMKMapPoint point2 = BMKMapPointForCoordinate(poi.pt);
            CLLocationDistance distance = BMKMetersBetweenMapPoints(point1, point2);
            poiInfos.distance = distance;
            
            [self.infoDatas addObject:poiInfos];
            
            NSLog(@"%@",poiInfos.uid);
        }
        
        if (self.searchSome == 0) {
            self.searchSome = 1;
            [_tableView reloadData];
            return;
        }
        
        TestViewController *test = [[TestViewController alloc] init];
        
        if (self.curPage != 0) {
            test.infoData = self.infoDatas;
            return;
        }
        
        test.delegate = self;
        test.title = self.mySearch;
        test.infoData = self.infoDatas;
        test.userLocation = _userLocation;
        
        [MBProgressHUD hideHUD];
        [self.navigationController pushViewController:test animated:YES];
        
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        [MBProgressHUD hideHUD];

        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
    } else {
        [MBProgressHUD hideHUD];

        NSLog(@"检索失败");
    }
}

@end
