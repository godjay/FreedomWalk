//
//  FavoritesViewController.m
//  freedomWalk
//
//  Created by xwbb on 15/12/18.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _searcher.delegate = nil;
    _locService.delegate = nil;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
    tap.cancelsTouchesInView = NO;//添加自定义手势时，需设置，否则影响地图的操作
    tap.delaysTouchesEnded = NO;//添加自定义手势时，需设置，否则影响地图的操作
    [self.view addGestureRecognizer:tap];
    
    //返回键
    [self backButton];
    //初始化收藏夹管理类
    _favManager = [[BMKFavPoiManager alloc] init];
    
    //地图
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.zoomLevel = 17.0;
    //定位
    _locService = [[BMKLocationService alloc] init];
    [_mapView setUserTrackingMode:BMKUserTrackingModeFollow];
    _mapView.showsUserLocation = NO;
    [_locService startUserLocationService];
    

}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    _mapView.showsUserLocation = YES;
    [_mapView updateLocationData:userLocation];
    _userLocation = userLocation;
}

- (void)backButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back_pic"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 11, 19);
    [backBtn addTarget:self action:@selector(backBtnclick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)hiddenKeyBoard {
    [_nameTextField resignFirstResponder];
}

- (IBAction)saveAction:(UIButton *)sender {
    [self hiddenKeyBoard];
    if (_nameTextField.text.length == 0) {
        [PromptInfo showText:@"请输入名称"];
        return;
    }
    if (_coor.latitude == 0 && _coor.longitude == 0) {
        [PromptInfo showText:@"请获取经纬度"];
        return;
    }
    BMKFavPoiInfo *poiInfo = [[BMKFavPoiInfo alloc] init];
    poiInfo.pt = _coor;
    poiInfo.poiName = _nameTextField.text;
    poiInfo.address = _address;
    NSInteger res = [_favManager addFavPoi:poiInfo];
    if (res == 1) {
//        [PromptInfo showText:@"保存成功"];
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle: nil message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertView animated:YES completion:nil];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            //调用了代理对象的协议方法，通知代理对象。
            [self.delegate registSucess:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertView addAction:action];
        
    } else {
        [PromptInfo showText:@"保存失败"];
        NSLog(@"=====%ld",(long)res);
    }
}

- (void)backBtnclick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BMKMapViewDelegate
/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    [self hiddenKeyBoard];
}

/**
 *双击地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回双击处坐标点的经纬度
 */
-(void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi {
    [self hiddenKeyBoard];
}

/**
 *长按地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回长按事件坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate {
    _coor = coordinate;
    NSLog(@"%f %f",coordinate.latitude,coordinate.longitude);
    if (_coor.latitude != 0 && _coor.longitude != 0) {
        [PromptInfo showText:@"成功获取地理位置!"];
    }
    
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
//    发起反向地理编码检索
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = _coor;
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

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
//      NSLog(@"==%@",result.addressDetail.streetName);
      _addressName = result.addressDetail.streetName;
      NSMutableString *mStr = [NSMutableString stringWithFormat:@"%@",result.addressDetail.province];
      [mStr appendFormat:@"%@",result.addressDetail.city];
      [mStr appendFormat:@"%@",result.addressDetail.district];
      [mStr appendFormat:@"%@",result.addressDetail.streetName];
      [mStr appendFormat:@"%@",result.addressDetail.streetNumber];
      _address = [NSString stringWithString:mStr];
      NSLog(@"%@",_address);
//      NSLog(@"123%@",result.address);
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}

@end
