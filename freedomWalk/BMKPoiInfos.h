//
//  BMKPoiInfos.h
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/10.
//  Copyright © 2015年 YC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BMKPoiInfos : NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *city;
@property (nonatomic)int epoitype;
@property (nonatomic)CLLocationCoordinate2D pt;

@property (nonatomic)CLLocationDistance distance;

@end
/*
NSString* _name;			///<POI名称
NSString* _uid;
NSString* _address;		///<POI地址
NSString* _city;			///<POI所在城市
int		  _epoitype;		///<POI类型，0:普通点 1:公交站 2:公交线路 3:地铁站 4:地铁线路
CLLocationCoordinate2D _pt;	///<POI坐标
*/