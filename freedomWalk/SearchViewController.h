//
//  SearchViewController.h
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/7.
//  Copyright © 2015年 YC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
/*
@protocol SearchViewControllerDelegate <NSObject>

@optional

- (void)searchWithtext:(NSString *)text;

@end

@interface SearchViewController : UIViewController

@property (nonatomic,weak) id<SearchViewControllerDelegate> delegate;
@end
*/

@interface SearchViewController : UIViewController
@property (nonatomic,weak)BMKUserLocation *userLocation;

@property (nonatomic,strong)BMKPoiSearch *poisearch;
@property (nonatomic,assign)int curPage;
@property (nonatomic,strong)NSString *myLoc;
@property (nonatomic,copy)NSString *mySearch;
@property (nonatomic,weak)BMKPoiInfo* poi;

@property (nonatomic,strong)NSMutableArray *infoDatas;
@end