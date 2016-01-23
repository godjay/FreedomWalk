//
//  FavoritesViewController.h
//  freedomWalk
//
//  Created by xwbb on 15/12/18.
//  Copyright © 2015年 YC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import "UIViewExt.h"
#import "PromptInfo.h"

@protocol FavoritesViewControllerDelegate 

//传递数据源
-(void)registSucess:(NSDictionary *)infosDic;

@end

@interface FavoritesViewController : UIViewController<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate>
{
    BMKFavPoiManager *_favManager;
    CLLocationCoordinate2D _coor;
    BMKGeoCodeSearch *_searcher;
}

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (nonatomic , copy) NSString *addressName;
@property (nonatomic , copy) NSString *address;
@property (nonatomic,strong)BMKLocationService *locService;
@property (nonatomic , strong) BMKUserLocation *userLocation;

@property (nonatomic , weak) id<FavoritesViewControllerDelegate> delegate;

@end
