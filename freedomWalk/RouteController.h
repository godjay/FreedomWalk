//
//  RouteController.h
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/23.
//  Copyright © 2015年 YC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

typedef enum : NSUInteger {
    公交 = 0,
    驾车,
    步行,
    自行车,
}  RouteType;

@interface RouteController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *start;
@property (weak, nonatomic) IBOutlet UITextField *end;

@property (nonatomic , assign) RouteType routeType;
@property (nonatomic,strong)BMKPoiSearch *poisearch;
@property (nonatomic,copy)NSString *mySearch;
@property (nonatomic,weak)BMKUserLocation *userLocation;
@property (nonatomic,assign)int curPage;
@property (nonatomic,strong)NSMutableArray *infoDatas;

@end
