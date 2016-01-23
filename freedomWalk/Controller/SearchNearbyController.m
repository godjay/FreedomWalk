//
//  SearchNearbyController.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/12.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "SearchNearbyController.h"
#import "BMKPoiInfos.h"
#import "TestViewController.h"
#import "titles.h"
#import "YCCollectionCell.h"
#import "MBProgressHUD+MJ.h"

static NSString *identifier = @"CollectionCell";


#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height
@interface SearchNearbyController () <UITextFieldDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,TestViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,weak)UITextField *textField;
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)NSMutableArray *titlesData;
@end

@implementation SearchNearbyController

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
    
    _titles = @[@"酒吧",@"网吧",@"美食",@"景点",@"银行",@"加油站",@"洗浴",@"超市",@"地铁",@"公交",@"药店",@"加油站"];
    _titlesData = [NSMutableArray array];
    
    for (NSString *titleName in _titles) {
        titles *title = [[titles alloc] init];
        title.title = titleName;
        [_titlesData addObject:title];
    }
    
    [self setupNav];
//    [self.textField becomeFirstResponder];
    
    [self setupSearchMainView];
    
}

- (void)setupSearchMainView{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(10, 74, KWidth - 20, KHeight * 0.2);
    [self.view addSubview:view];
    
    //创建布局视图
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionHeadersPinToVisibleBounds = NO;
    //设置布局属性
    flowLayout.itemSize = CGSizeMake((KWidth - 20)/4, KHeight * 0.2/3);
    //创建collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, -65, KWidth - 20, KHeight * 0.4) collectionViewLayout:flowLayout];
    
    //    collectionView.backgroundColor = [UIColor greenColor];
    //设置代理
    collectionView.dataSource =self;
    collectionView.delegate = self;
    //设置属性
    collectionView.backgroundColor = [UIColor clearColor];
    //    collectionView.scrollEnabled = NO;
    
    //注册单元格
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    
    [view addSubview:collectionView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(view.frame) + 10, KWidth - 20, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIButton *history = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:history];
    history.frame = CGRectMake(0,16,120,18);
    [history setImage:[UIImage imageNamed:@"历史记录"] forState:UIControlStateNormal];
    history.imageView.frame = CGRectMake(0, 0, 6, 6);
    history.imageView.contentMode = UIViewContentModeScaleAspectFit;
    history.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [history setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [history setTitle:@"历史记录" forState:UIControlStateNormal];
    
}

#pragma mark - UICollectionViewDataSource
//返回个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _titlesData.count;
}

//返回单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:inden forIndexPath:indexPath];
    //    if (cell == nil) {
    ////        cell = [UICollectionViewCell alloc]
    //    }
    titles *title = _titlesData[indexPath.item];
    UILabel *cellLable = [[UILabel alloc] init];
    cellLable.frame = cell.contentView.frame;
    [cell.contentView addSubview:cellLable];
    cellLable.text = title.title;
    if (indexPath.section == 0 && indexPath.row == 1) {
        cellLable.textColor = [UIColor redColor];
    }else if (indexPath.section == 0 && indexPath.row == 0){
        cellLable.textColor = [UIColor greenColor];
    }else if (indexPath.section == 0 && indexPath.row == 2){
        cellLable.textColor = [UIColor purpleColor];
    }else if (indexPath.section == 0 && indexPath.row == 3){
        cellLable.textColor = [UIColor blueColor];
    }else if (indexPath.section == 0 && indexPath.row == 11){
        cellLable.textColor = [UIColor magentaColor];
    }
    
    return cell;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(10,10,10,20);
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    titles *title = _titlesData[indexPath.item];
    self.mySearch = title.title;
    self.infoDatas = nil;//重置搜索
    self.curPage = 0;
    
    [MBProgressHUD showMessage:@"杰哥帮你加载中.."];
    [self searchNearby];
    
    NSLog(@"%@",title.title);
}

- (void)setupNav{
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 11, 19);
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_pic"] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    [backBtn addTarget:self action:@selector(backBuTTClick) forControlEvents:UIControlEventTouchUpInside];

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 230, 28)];
    self.textField = textField;
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = @"搜索";
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageView.image = [UIImage imageNamed:@"02"];
    textField.leftView = imageView;
    textField.leftViewMode = UITextFieldViewModeUnlessEditing;
    self.navigationItem.titleView = textField;
    textField.delegate = self;
    
    UIButton *tureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *la = [UIImage imageNamed:@"离线导航包按钮"];
    //    UIImage *newImage = [la resizableImageWithCapInsets:UIEdgeInsetsMake(34, 50, 34, 50) resizingMode:UIImageResizingModeStretch];
    [tureBtn setBackgroundImage:la forState:UIControlStateNormal];
    [tureBtn setTitle:@"确定" forState:UIControlStateNormal];
    tureBtn.bounds = CGRectMake(0, 0, 60, 28);
    UIBarButtonItem *tureItem = [[UIBarButtonItem alloc] initWithCustomView:tureBtn];
    self.navigationItem.rightBarButtonItem = tureItem;
    [tureBtn addTarget:self action:@selector(tureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

//确定搜索
- (void)tureBtnClick{

    [self.textField resignFirstResponder];
    self.mySearch = self.textField.text;

    self.infoDatas = nil;//重置搜索
    self.curPage = 0;
    [MBProgressHUD showMessage:@"杰哥帮你加载中.."];

    //城市内检索
    [self searchNearby];
    
}

- (void)loadMoreData{
    self.curPage++;
    [self searchNearby];
}

//- (void)loadMoreWithSearch:(NSString *)search{
//    self.mySearch = search;
//    [self searchNearby];
//}


/*
- (void)searchNearbyBegan{
    //反地理编码
    self.mySearch = self.textField.text;
    BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc] init];
    search.delegate = self;
    CLLocationCoordinate2D pt = self.userLocation.location.coordinate;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [search reverseGeoCode:reverseGeoCodeSearchOption];
    if (flag) {
        NSLog(@"ok");
    }else{
        NSLog(@"sad");
    }
}

//获得反地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR ) {
        //获得城市名
        self.myLoc = result.addressDetail.city;
        NSLog(@"%@",result.addressDetail.city);
        
        [self searchNearby];
        
    }else{
        NSLog(@"检索失败");
    }
}
*/
//附近搜索
- (void)searchNearby{

    _poisearch = [[BMKPoiSearch alloc] init];
    _poisearch.delegate = self;
    
    BMKNearbySearchOption *nearbySearchOption = [[BMKNearbySearchOption alloc] init];
    nearbySearchOption.pageIndex = self.curPage;
    nearbySearchOption.pageCapacity = 20;
    nearbySearchOption.location = self.userLocation.location.coordinate;
    nearbySearchOption.keyword = self.mySearch;
    
    //        NSLog(@"%@",self.myLoc);
    NSLog(@"%@",self.mySearch);
    
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
            BMKPoiInfo* poi = [poiResult.poiInfoList objectAtIndex:i];
            
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
        TestViewController *test = [[TestViewController alloc] init];
        test.userLocation = self.userLocation;
        if (self.curPage != 0) {
            test.infoData = self.infoDatas;
            return;
        }
        
        test.delegate = self;
        test.title = self.mySearch;
        test.infoData = self.infoDatas;
        
        [MBProgressHUD hideHUD];
        [self.navigationController pushViewController:test animated:YES];
 
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        [MBProgressHUD hideHUD];

        [MBProgressHUD showError:@"没有更多！"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
    } else {
        NSLog(@"检索失败");
        [MBProgressHUD hideHUD];

        [MBProgressHUD showError:@"没有更多！"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });    }
}



//退出键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//返回按钮点击
- (void)backBuTTClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
