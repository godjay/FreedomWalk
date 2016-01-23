//
//  TestViewController.h
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/11.
//  Copyright © 2015年 YC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@protocol TestViewControllerDelegate <NSObject>

@optional

- (void)loadMoreData;
//- (void)loadMoreWithSearch:(NSString *)search;
@end

@interface TestViewController : UIViewController <BMKGeoCodeSearchDelegate>
{
    BMKGeoCodeSearch *_searcher;
}

@property (nonatomic,strong)NSMutableArray *infoData;

@property (nonatomic,weak)id<TestViewControllerDelegate>delegate;

@property (nonatomic,weak)BMKUserLocation *userLocation;
@property (nonatomic,copy)NSString *mySearch;
@property (nonatomic,assign)int tag;


@property (nonatomic , copy) NSString *star;
@property (nonatomic , copy) NSString *end;
//- (instancetype)initWithUserLocation:(BMKUserLocation *)userLocation search:(NSString *)search andTag: (int)tag;
@end
