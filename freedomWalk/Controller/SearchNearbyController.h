//
//  SearchNearbyController.h
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/12.
//  Copyright © 2015年 YC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
@interface SearchNearbyController : UIViewController
@property (nonatomic,strong)NSMutableArray *infoDatas;
@property (nonatomic,assign)int curPage;
@property (nonatomic,copy)NSString *mySearch;
@property (nonatomic,weak)BMKUserLocation *userLocation;
@property (nonatomic,strong)NSString *myLoc;
@property (nonatomic,strong)BMKPoiSearch *poisearch;
@property (nonatomic,assign)int tag;


@end
