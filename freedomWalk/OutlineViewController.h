//
//  OutlineViewController.h
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/4.
//  Copyright © 2015年 YC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface OutlineViewController : UIViewController
@property (nonatomic,strong)BMKOfflineMap* offlineMap;
@property (nonatomic,strong)NSArray *arrayHotCityData;//热门城市
@property (nonatomic,strong)NSArray *arrayOfflineCityData;//全国支持离线地图的城市
@property (nonatomic,strong)NSMutableArray *arraylocalDownLoadMapInfo;//本地下载的离线地图
@property (nonatomic,strong)UITableView *groupTableView;
@property (nonatomic,strong)UITableView *plainTableView;
@property (nonatomic,weak)UISegmentedControl *tableChangeControl;

@end
/*
 NSArray* _arrayHotCityData;//热门城市
 NSArray* _arrayOfflineCityData;//全国支持离线地图的城市
 NSMutableArray * _arraylocalDownLoadMapInfo;//本地下载的离线地图
*/