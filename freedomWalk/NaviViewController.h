//
//  NaviViewController.h
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/2.
//  Copyright © 2015年 YC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
@interface NaviViewController : UIViewController
@property (nonatomic,strong)BMKPoiSearch *poisearch;
@property (nonatomic,copy)NSString *mySearch;
@property (nonatomic,weak)BMKUserLocation *userLocation;
@property (nonatomic,assign)int curPage;
@property (nonatomic,strong)NSMutableArray *infoDatas;

@end
