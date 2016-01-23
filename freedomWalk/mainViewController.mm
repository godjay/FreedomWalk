//
//  mainViewController.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/2.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "mainViewController.h"
#import "NearbyViewController.h"
#import "NaviViewController.h"
#import "MineViewController.h"
#import "CustomTextField.h"
#import "YCNavController.h"
#import "SearchViewController.h"
#import "PanoramaViewController.h"
#import "UIImage+Rotate.h"
#import "RouteController.h"

#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height


#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@implementation mainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geoCodeSearch.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _routeSearch.delegate = nil;
    _geoCodeSearch.delegate = nil;
    
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    _panorama.selected = NO;
    _panoBGView.hidden = YES;
    
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航节点数组
    _nodesArray = [NSMutableArray arrayWithCapacity:2];
    
    //初始化地图
    [self setupMap];
    
    //设置导航栏内容
    [self setupNav];
    
    //设置搜索框
    [self setupSearch];
    
    //设置6个按钮
    [self setup6Btn];
    
    //设置底部按钮
    [self setupBottom];

    //全景
    [self _createPanoView];
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(naviNotification:) name:@"Navigation_End" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchNotification:) name:@"Search_Info" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoInfosTwice:) name:@"goto_Infos_twice" object:nil];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    self.userLocation = userLocation;
    _mapView.showsUserLocation = YES;
    [_mapView updateLocationData:userLocation];
    
    //导航起点
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = userLocation.location.coordinate.longitude;
    startNode.pos.y = userLocation.location.coordinate.latitude;
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    if (_nodesArray.count < 1) {
        [_nodesArray addObject:startNode];
    }
}

#pragma mark - 路线相关
- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil;
}

#pragma mark - 创建
- (void)setupMap{
    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    self.mapView = mapView;
    mapView.delegate = self;
    
    mapView.mapType = BMKMapTypeStandard;
    mapView.zoomLevel = 15.0;
    
    [self.view addSubview:mapView];
    
    //定位
    _locService = [[BMKLocationService alloc] init];
    //导航
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    
}

- (void)setupBottom{
    CGFloat bottomViewW = KWidth;
    CGFloat bottomViewH = 50;
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = KHeight - bottomViewH;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    //添加内部四个按钮
    CGFloat bottomBtnW = bottomViewW / 4;
    CGFloat bottomBtnH = bottomViewH / 3;
    CGFloat bottomBtnY = (bottomViewH - bottomBtnH) / 2;
    
    CGFloat nearbyX = 0;
    UIButton *nearby = [UIButton buttonWithType:UIButtonTypeCustom];
    nearby.frame = CGRectMake(nearbyX, bottomBtnY, bottomBtnW, bottomBtnH);
    [nearby setImage:[UIImage imageNamed:@"main_near"] forState:UIControlStateNormal];
    [nearby setTitle:@"附近" forState:UIControlStateNormal];
    nearby.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 10);
    [nearby setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nearby addTarget:self action:@selector(nearbyClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat routeX = bottomBtnW;
    UIButton *route = [UIButton buttonWithType:UIButtonTypeCustom];
    route.frame = CGRectMake(routeX, bottomBtnY, bottomBtnW, bottomBtnH);
    [route setImage:[UIImage imageNamed:@"main_route"] forState:UIControlStateNormal];
    [route setTitle:@"路线" forState:UIControlStateNormal];
    route.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 10);
    [route setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [route addTarget:self action:@selector(routeClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat navigationX = bottomBtnW * 2;
    UIButton *navigation = [UIButton buttonWithType:UIButtonTypeCustom];
    navigation.frame = CGRectMake(navigationX, bottomBtnY, bottomBtnW, bottomBtnH);
    [navigation setImage:[UIImage imageNamed:@"main_daohang"] forState:UIControlStateNormal];
    [navigation setTitle:@"导航" forState:UIControlStateNormal];
    navigation.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 10);
    [navigation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navigation addTarget:self action:@selector(navigationClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat mineX = bottomBtnW * 3;
    UIButton *mine = [UIButton buttonWithType:UIButtonTypeCustom];
    mine.frame = CGRectMake(mineX, bottomBtnY, bottomBtnW, bottomBtnH);
    [mine setImage:[UIImage imageNamed:@"main_mine"] forState:UIControlStateNormal];
    [mine setTitle:@"我的" forState:UIControlStateNormal];
    mine.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 10);
    [mine setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mine addTarget:self action:@selector(mineClick) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:mine];
    [bottomView addSubview:navigation];
    [bottomView addSubview:nearby];
    [bottomView addSubview:route];
    
    //   分割线
    CGFloat divY = bottomViewH / 3;
    CGFloat divW = 1;
    CGFloat divH = bottomViewH / 4;
    
    CGFloat div1X = routeX - 6;
    UIView *div1 = [[UIView alloc] initWithFrame:CGRectMake(div1X, divY, divW, divH)];
    div1.backgroundColor = [UIColor grayColor];
    div1.alpha = 0.8;
    
    CGFloat div2X = navigationX - 2;
    UIView *div2 = [[UIView alloc] initWithFrame:CGRectMake(div2X, divY, divW, divH)];
    div2.backgroundColor = [UIColor grayColor];
    div2.alpha = 0.8;
    
    CGFloat div3X = mineX - 6;
    UIView *div3 = [[UIView alloc] initWithFrame:CGRectMake(div3X, divY, divW, divH)];
    div3.backgroundColor = [UIColor grayColor];
    div3.alpha = 0.8;
    
    [bottomView addSubview:div3];
    [bottomView addSubview:div2];
    [bottomView addSubview:div1];
}

- (void)setup6Btn{
    CGFloat Dis = 10;
    CGFloat btnW = 45;
    CGFloat btnH = btnW;
    CGFloat btnX = KWidth - Dis - btnW;
    
    CGFloat roadConY = KHeight * 0.25;
    UIButton *roadCon = [[UIButton alloc] initWithFrame:CGRectMake(btnX, roadConY, btnW, btnH)];
    [roadCon setBackgroundImage:[UIImage imageNamed:@"main_lukuang"] forState:UIControlStateNormal];
    [roadCon setBackgroundImage:[UIImage imageNamed:@"main_lukuang_changed"] forState:UIControlStateSelected];
    [roadCon addTarget:self action:@selector(roadConBtnClick:) forControlEvents:UIControlEventTouchDown];
    
    CGFloat panoramaY = roadConY + btnH + Dis;
    _panorama = [[UIButton alloc] initWithFrame:CGRectMake(btnX, panoramaY, btnW, btnH)];
    [_panorama setBackgroundImage:[UIImage imageNamed:@"main_quanjing"] forState:UIControlStateNormal];
    [_panorama setBackgroundImage:[UIImage imageNamed:@"main_quanjing_changed"] forState:UIControlStateSelected];
    [_panorama addTarget:self action:@selector(panoramaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat historyY = panoramaY + btnH + Dis;
    UIButton *history = [[UIButton alloc] initWithFrame:CGRectMake(btnX, historyY, btnW, btnH)];
    [history setBackgroundImage:[UIImage imageNamed:@"main_lishi"] forState:UIControlStateNormal];
    
    CGFloat wayY = historyY + btnH + Dis;
    UIButton *way = [[UIButton alloc] initWithFrame:CGRectMake(btnX, wayY, btnW, btnH)];
    [way setBackgroundImage:[UIImage imageNamed:@"main_yantu"] forState:UIControlStateNormal];
    
    CGFloat sBtnW = 38;
    CGFloat sBtnH = sBtnW;
    CGFloat sBtnX = KWidth - Dis - sBtnW;
    
    CGFloat maxY = KHeight * 0.7;
    UIButton *max =[[UIButton alloc] initWithFrame:CGRectMake(sBtnX, maxY, sBtnW, sBtnH)];
    [max setBackgroundImage:[UIImage imageNamed:@"main_outzoom"] forState:UIControlStateNormal];
    [max addTarget:self action:@selector(maxClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat minY = maxY + sBtnH +Dis;
    UIButton *min =[[UIButton alloc] initWithFrame:CGRectMake(sBtnX, minY, sBtnW, sBtnH)];
    [min setBackgroundImage:[UIImage imageNamed:@"main_inzoom"] forState:UIControlStateNormal];
    [min addTarget:self action:@selector(minClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:roadCon];
    [self.view addSubview:_panorama];
    [self.view addSubview:history];
    [self.view addSubview:way];
    [self.view addSubview:max];
    [self.view addSubview:min];
    
}

- (void)setupSearch{
    UIView *search = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KWidth, 64)];
    search.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:search];
    CGFloat searchBarX = 30;
    CGFloat searchBarY = 15;
    CGFloat searchBarW = KWidth - 2 * searchBarX;
    CGFloat searchBarH = 64 - 2 * searchBarY;
    
    UIImageView *searchView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    CustomTextField *searchBar = [[CustomTextField alloc] initWithFrame:CGRectMake(searchBarX, searchBarY, searchBarW, searchBarH) withPlaceholder:@"搜地点、查路线" withLeftView:searchView];
    searchBar.borderStyle = UITextBorderStyleLine;
    searchBar.layer.borderWidth = 1.0;
    searchBar.layer.borderColor = [UIColor colorWithRed:142/255.0 green:199/255.0 blue:182/255.0 alpha:1.0].CGColor;
    searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchBar.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchView.image = [UIImage imageNamed:@"02"];
    searchBar.leftView = searchView;
    searchBar.leftViewMode = UITextFieldViewModeUnlessEditing;
    searchBar.delegate = self;
    [search addSubview:searchBar];
}

- (void)setupNav{
    self.title = @"自由行";
    
    UIButton *left = [[UIButton alloc] init];
    left.bounds = CGRectMake(0, 0, 25, 31);
    [left setBackgroundImage:[UIImage imageNamed:@"01"] forState:UIControlStateNormal];
    
    [left addTarget:self action:@selector(locClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

#pragma mark - 全景
- (void)_createPanoView
{
    CGFloat x = self.view.center.x - (KWidth * 0.3) / 2;
    CGFloat y = self.view.center.y - KHeight * 0.17;
    _panoBGView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, KWidth * 0.3, KHeight * 0.17)];
    _panoBGView.image = [UIImage imageNamed:@"背景"];
    _panoBGView.userInteractionEnabled = YES;
    _panoBGView.hidden = YES;
    [self.view addSubview:_panoBGView];
    
    UIImageView *slimageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, _panoBGView.bounds.size.width - 10, _panoBGView.bounds.size.height * 0.6)];
    slimageView.backgroundColor = [UIColor greenColor];
    [_panoBGView addSubview:slimageView];
    
    UIButton *panoButt = [UIButton buttonWithType:UIButtonTypeCustom];
    panoButt.frame = CGRectMake(5, slimageView.bounds.size.height, slimageView.bounds.size.width, _panoBGView.bounds.size.height * 0.4);
    [panoButt setTitle:@"查看全景 >" forState:UIControlStateNormal];
    panoButt.titleLabel.font = [UIFont systemFontOfSize:15];
    [panoButt addTarget:self action:@selector(openPanoView:) forControlEvents:UIControlEventTouchUpInside];
    [_panoBGView addSubview:panoButt];
}

#pragma mark - 监听通知
//监听路线搜索通知
- (void)searchNotification:(NSNotification *)notifi
{
    NSDictionary *dic = notifi.userInfo;
    self.text1 = dic[@"text1"];
    self.text2 = dic[@"text2"];
    _typeNum = [dic[@"type"] integerValue];
    
    //检索路线
    [self routeSearchMethod];
}

//导航通知
- (void)naviNotification:(NSNotification *)notifi
{
    //地理编码
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city= @"全国";
    geocodeSearchOption.address = notifi.object;
    //    NSLog(@"---%@",notifi.object);
    BOOL flag = [_geoCodeSearch geoCode:geocodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}

- (void)gotoInfosTwice:(NSNotification *)notifi
{
    NSDictionary *dic = notifi.userInfo;
    self.text1 = dic[@"star"];
    self.text2 = dic[@"end"];
    _typeNum = 1;
    NSLog(@"star:%@,end:%@",self.text1,self.text2);
    [self routeSearchMethod];
}

#pragma mark - 地理编码
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //导航终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = result.location.longitude;
    endNode.pos.y = result.location.latitude;
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [_nodesArray addObject:endNode];
    
    //测试节点个数与坐标
    int index = 0;
    for (BNRoutePlanNode *node in _nodesArray) {
        index ++;
        NSLog(@"%d:x:%f,y:%f",index,node.pos.x,node.pos.y);
    }
    //发起算路
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:_nodesArray time:nil delegete:self userInfo:nil];
}
#pragma mark - 导航算路
- (void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功 %@",userInfo);
    
    //播报模式
    [[BNCoreServices StrategyService] setSpeakMode:BN_Speak_Mode_High];
    
    //路径规划成功，开始导航
    [BNCoreServices_UI showNaviUI: BN_NaviTypeReal delegete:self isNeedLandscape:YES];
    
    //移除数组中元素
    [_nodesArray removeAllObjects];
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"算路失败 %ld",(long)error.code);
    if ([error code] == BNRoutePlanError_LocationFailed) {
        NSLog(@"获取地理位置失败");
    }
    else if ([error code] == BNRoutePlanError_RoutePlanFailed)
    {
        NSLog(@"定位服务未开启");
    } else if ([error code] == BNRoutePlanError_NodesTooNear)
    {
        NSLog(@"节点之间距离太近");
    }
}

//算路取消
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    NSLog(@"算路取消");
}

#pragma mark - MapView Delegate
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    return nil;
}

#pragma mark - 检索路线
- (void)routeSearchMethod
{
    _routeSearch = [[BMKRouteSearch alloc] init];
    _routeSearch.delegate = self;
    switch (_typeNum) {
        case 0:
        {
            BMKPlanNode* start = [[BMKPlanNode alloc]init];
            start.name = self.text1;
            BMKPlanNode* end = [[BMKPlanNode alloc]init];
            end.name = self.text2;
            
            BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
            transitRouteSearchOption.city = @"全国";
            transitRouteSearchOption.from = start;
            transitRouteSearchOption.to = end;
            BOOL flag = [_routeSearch transitSearch:transitRouteSearchOption];
            if(flag)
            {
                NSLog(@"bus检索发送成功");
            }
            else
            {
                NSLog(@"bus检索发送失败");
            }
        }
            break;
        case 1:
        {
            BMKPlanNode* start = [[BMKPlanNode alloc]init];
            start.name = self.text1;
            start.cityName = @"全国";
            BMKPlanNode* end = [[BMKPlanNode alloc]init];
            end.name = self.text2;
            end.cityName = @"全国";
            
            BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
            drivingRouteSearchOption.from = start;
            drivingRouteSearchOption.to = end;
            BOOL flag = [_routeSearch drivingSearch:drivingRouteSearchOption];
            if(flag)
            {
                NSLog(@"car检索发送成功");
            }
            else
            {
                NSLog(@"car检索发送失败");
            }
        }
            break;
        case 2:
        {
            //设置地点
            BMKPlanNode *start = [[BMKPlanNode alloc] init];
            start.name = self.text1;
            start.cityName = @"全国";
            BMKPlanNode *end = [[BMKPlanNode alloc] init];
            end.name = self.text2;
            end.cityName = @"全国";
            BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc] init];
            walkingRouteSearchOption.from = start;
            walkingRouteSearchOption.to = end;
            
            BOOL flag = [_routeSearch walkingSearch:walkingRouteSearchOption];
            if (flag) {
                NSLog(@"walk 检索成功");
            } else
            {
                NSLog(@"检索失败");
            }
        }
            break;
        case 3:
        {
            BMKPlanNode *start = [[BMKPlanNode alloc] init];
            start.name = self.text1;
            start.cityName = @"全国";
            BMKPlanNode *end = [[BMKPlanNode alloc] init];
            end.name = self.text2;
            end.cityName = @"全国";
            BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc] init];
            walkingRouteSearchOption.from = start;
            walkingRouteSearchOption.to = end;
            
            BOOL flag = [_routeSearch walkingSearch:walkingRouteSearchOption];
            if (flag) {
                NSLog(@"walk 检索成功");
            } else
            {
                NSLog(@"检索失败");
            }
        }
            break;
        default:
            break;
    }
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch *)searcher result:(BMKWalkingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //        NSLog(@"%@",result.routes);
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
        if (error == BMK_SEARCH_NO_ERROR) {
            BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
            NSInteger size = [plan.steps count];
            int planPointCounts = 0;
            for (int i = 0; i < size; i++) {
                BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
                if(i==0){
                    RouteAnnotation* item = [[RouteAnnotation alloc]init];
                    
                    item.coordinate = plan.starting.location;
                    item.title = @"起点";
                    item.type = 0;
                    [_mapView addAnnotation:item]; // 添加起点标注
                    
                }else if(i==size-1){
                    RouteAnnotation* item = [[RouteAnnotation alloc]init];
                    item.coordinate = plan.terminal.location;
                    item.title = @"终点";
                    item.type = 1;
                    [_mapView addAnnotation:item]; // 添加起点标注
                }
                //添加annotation节点
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = transitStep.entrace.location;
                item.title = transitStep.entraceInstruction;
                item.degree = transitStep.direction * 30;
                item.type = 4;
                [_mapView addAnnotation:item];
                
                //轨迹点总数累计
                planPointCounts += transitStep.pointsCount;
            }
            //轨迹点
            BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
            int i = 0;
            for (int j = 0; j < size; j++) {
                BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
                int k=0;
                for(k=0;k<transitStep.pointsCount;k++) {
                    temppoints[i].x = transitStep.points[k].x;
                    temppoints[i].y = transitStep.points[k].y;
                    i++;
                }
            }
            // 通过points构建BMKPolyline
            BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
            [_mapView addOverlay:polyLine]; // 添加路线overlay
            delete []temppoints;
            [self mapViewFitPolyLine:polyLine];
        }
    } else if (error == BMK_SEARCH_ST_EN_TOO_NEAR)
    {
        NSLog(@"检索点有歧义");
    } else
    {
        NSLog(@"抱歉,未找到结果!");
    }
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }else if (error == BMK_SEARCH_ST_EN_TOO_NEAR)
    {
        NSLog(@"检索点有歧义");
    }else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR)
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"警告" message:@"检索地址有岐义" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:nil];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
    } else
    {
        NSLog(@"抱歉,未找到结果! %d",error);
    }
}

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        //		delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }else if (error == BMK_SEARCH_ST_EN_TOO_NEAR)
    {
        NSLog(@"检索点有歧义");
    } else
    {
        NSLog(@"抱歉,未找到结果!");
    }
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

#pragma mark - textField 代理方法
//退出键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//进入搜索界面 并传递位置信息
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.view.backgroundColor = [UIColor whiteColor];
    if (self.userLocation != nil) {
        searchView.userLocation = self.userLocation;
    }else{
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有定位哦" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [aler addAction:cancel];
        [aler addAction:ok];
        [self presentViewController:aler animated:YES completion:nil];
    }
//    YCNavController *searchNav = [[YCNavController alloc] initWithRootViewController:searchView];
    
    [self.navigationController pushViewController:searchView animated:YES];
//    [self.navigationController presentViewController:searchNav animated:YES completion:^{
//        [self.view endEditing:YES];
//    }];
}

/*
>>>监听各种按钮点击<<<
 */
#pragma mark - 点击事件
//这里定位
- (void)locClick{

    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [_locService startUserLocationService];
    
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    NSLog(@"定位..");
}

//放大地图
- (void)maxClick{
    _mapView.zoomLevel++;
}

//缩小地图
- (void)minClick{
    _mapView.zoomLevel--;
}

//附近
- (void)nearbyClick{
    NearbyViewController *nearby = [[NearbyViewController alloc] init];
    if (self.userLocation != nil) {
        nearby.userLocation = self.userLocation;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }else{
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有定位哦" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [aler addAction:cancel];
        [aler addAction:ok];
        [self presentViewController:aler animated:YES completion:nil];
    }
    
    [self.navigationController pushViewController:nearby animated:YES];
}

//路线
- (void)routeClick{
    if (self.userLocation == nil) {
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有定位哦" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [aler addAction:cancel];
        [aler addAction:ok];
        [self presentViewController:aler animated:YES completion:nil];
    }
    RouteController *route = [[RouteController alloc] init];
    route.userLocation = self.userLocation;
    [self.navigationController pushViewController:route animated:YES];
}

//导航
- (void)navigationClick{
    if (self.userLocation == nil) {
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有定位哦" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [aler addAction:cancel];
        [aler addAction:ok];
        [self presentViewController:aler animated:YES completion:nil];
    }
    NaviViewController *navi = [[NaviViewController alloc] init];
    navi.userLocation = self.userLocation;
    navi.title = @"导航";
    [self.navigationController pushViewController:navi animated:YES];
}

//我的
- (void)mineClick{
    MineViewController *mine = [[MineViewController alloc] init];
    if (_userLocation != nil) {
        mine.userLocation = _userLocation;
    } else
    {
        NSLog(@"没传值");
    }
    [self.navigationController pushViewController:mine animated:YES];
}

//路况
- (void)roadConBtnClick:(UIButton *)roadCon
{
    roadCon.selected = !roadCon.selected;
    if (roadCon.selected) {
        [_mapView setTrafficEnabled:YES];
    } else
    {
        [_mapView setTrafficEnabled:NO];
    }
}

//全景
- (void)panoramaBtnClick:(UIButton *)butt
{
    _panorama.selected = !_panorama.selected;
    if (_panorama.selected) {
        _panoBGView.hidden = NO;
    } else
    {
        _panoBGView.hidden= YES;
    }
}

- (void)openPanoView:(UIButton *)butt
{
    NSLog(@"进入全景!");
    CLLocationCoordinate2D panoLC = [_mapView convertPoint:self.view.center toCoordinateFromView:self.view];
    NSLog(@"lon:%f,lat:%f",panoLC.longitude,panoLC.latitude);
    
    PanoramaViewController *panoVC = [[PanoramaViewController alloc] init];
    panoVC.panoLC = panoLC;
    
//    [self presentViewController:panoVC animated:YES completion:nil];
    [self.navigationController pushViewController:panoVC animated:YES];
    
}

@end


