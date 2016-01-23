//
//  RouteController.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/23.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "RouteController.h"
#import "MBProgressHUD+MJ.h"
#import "BMKPoiInfos.h"
#import "TestViewController.h"

@interface RouteController () <BMKPoiSearchDelegate,TestViewControllerDelegate>
- (IBAction)toilet:(id)sender;
- (IBAction)gas:(id)sender;
- (IBAction)parkBtn:(id)sender;
- (IBAction)searchRoute:(id)sender;
@property (nonatomic,strong)UIView *itemView;
@property (nonatomic,weak)BMKMapView *_mapView;
//@property (nonatomic,weak)BMKPoiSearch *_poisearch;
@end

@implementation RouteController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = YES;
}

- (NSMutableArray *)infoDatas{
    if (_infoDatas == nil) {
        _infoDatas = [NSMutableArray array];
    }
    return _infoDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
}

- (IBAction)toilet:(id)sender {
    self.infoDatas = nil;//重置搜索
    self.curPage = 0;
    [MBProgressHUD showMessage:@"杰哥正在帮你加载.."];
    [self searchNearbyWithTitle:@"厕所"];
}

- (IBAction)gas:(id)sender {
    self.infoDatas = nil;//重置搜索
    self.curPage = 0;
    [MBProgressHUD showMessage:@"杰哥正在帮你加载.."];
    [self searchNearbyWithTitle:@"加油站"];
}

- (IBAction)parkBtn:(id)sender {
    self.infoDatas = nil;//重置搜索
    self.curPage = 0;
    [MBProgressHUD showMessage:@"杰哥正在帮你加载.."];
    [self searchNearbyWithTitle:@"停车场"];
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


- (IBAction)searchRoute:(id)sender {
    NSNumber *typeNum = [NSNumber numberWithInteger:_routeType];
    NSDictionary *dic = @{
                          @"text1":self.start.text,
                          @"text2":self.end.text,
                          @"type":typeNum
                          };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Search_Info" object:self userInfo:dic];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UIView *)itemView{
    if (_itemView == nil) {
        _itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 44)];
    }
    return _itemView;
}

- (void)setupNav{
    
    CGFloat itemBtnW = 36;
    CGFloat itemBtnH = 30;
    CGFloat itemBtnY = 10;
    for (int i = 0; i < 4; i++) {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *imageName = [NSString stringWithFormat:@"方式%d",i+1];
        UIImage *itemImage = [UIImage imageNamed:imageName];
        //        itemImage.size = CGSizeMake(30, 30);
        //        [itemBtn setImage:itemImage forState:UIControlStateNormal];
        [itemBtn setBackgroundImage:itemImage forState:UIControlStateNormal];
        CGFloat itemBtnX = (i * itemBtnW) *1.5;
        itemBtn.frame = CGRectMake(itemBtnX, itemBtnY, itemBtnW, itemBtnH);
        itemBtn.tag = i + 10;
        [itemBtn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemView addSubview:itemBtn];
    }
    self.navigationItem.titleView = self.itemView;
    
}

//方式选择
- (void)itemBtnClick:(UIButton *)itemBtn{
    if (itemBtn.tag == 10) {
        NSLog(@"公交路线");
        _routeType = 0;
    } else if (itemBtn.tag == 11){
        NSLog(@"驾车路线");
        _routeType = 1;
    }else if (itemBtn.tag == 12){
        NSLog(@"步行路线");
        _routeType = 2;
    }else{
        NSLog(@"自行车路线");
        _routeType = 3;
    }
}

- (IBAction)change {
    NSString *mid = self.start.text;
    self.start.text = self.end.text;
    self.end.text = mid;
}


@end
