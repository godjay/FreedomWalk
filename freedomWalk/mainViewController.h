//
//  mainViewController.h
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/2.
//  Copyright © 2015年 YC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

#import "BNCoreServices.h"
@interface mainViewController : UIViewController<UITextFieldDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate,BNNaviRoutePlanDelegate,BNNaviUIManagerDelegate,BMKRouteSearchDelegate>
{
    BMKRouteSearch *_routeSearch;
    BMKGeoCodeSearch *_geoCodeSearch;
}

@property (nonatomic,weak)BMKMapView *mapView;
@property (nonatomic,strong)BMKLocationService *locService;
@property (nonatomic,weak)BMKUserLocation *userLocation;
@property (nonatomic,strong)UIImageView *panoBGView;
@property (nonatomic,strong)UIButton *panorama;

@property (nonatomic , strong) NSMutableArray *nodesArray; //导航节点数组
@property (nonatomic , copy) NSString *text1;
@property (nonatomic , copy) NSString *text2;
@property (nonatomic , assign) NSInteger typeNum;

@end
