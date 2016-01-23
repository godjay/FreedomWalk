//
//  AdrViewController.h
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/4.
//  Copyright © 2015年 YC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FavoritesViewController.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface AdrViewController : UITableViewController<BMKGeoCodeSearchDelegate,FavoritesViewControllerDelegate,NSCoding>
{
    BMKGeoCodeSearch *_searcher;
    BMKFavPoiManager *_favPoiManager;
}

@property (nonatomic , strong) NSArray *dataArray;

@property (nonatomic , copy) NSString *star;
@property (nonatomic , copy) NSString *end;

@property (nonatomic , strong) BMKUserLocation *userLocation;


@end
