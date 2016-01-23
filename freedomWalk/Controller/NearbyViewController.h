//
//  NearbyViewController.h
//  Nearby
//
//  Created by xwbb on 15/12/4.
//  Copyright © 2015年 Mr.Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
@interface NearbyViewController : UIViewController
@property (nonatomic,weak)BMKUserLocation *userLocation;
@property (nonatomic,assign)int curPage;
@property (nonatomic,strong)BMKPoiSearch *poisearch;
@property (nonatomic,strong)NSMutableArray *infoDatas;
@property (nonatomic,copy)NSString *mySearch;
@property (nonatomic,assign)int searchSome;

@end
