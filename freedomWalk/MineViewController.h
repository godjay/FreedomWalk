//
//  MineViewController.h
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/2.
//  Copyright © 2015年 YC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface MineViewController : UIViewController
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic , strong) BMKUserLocation *userLocation;
@end
