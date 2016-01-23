//
//  ParkCell.h
//  Nearby
//
//  Created by xwbb on 15/12/7.
//  Copyright © 2015年 Mr.Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@class BMKPoiInfos;
@interface ParkCell : UITableViewCell<BMKGeoCodeSearchDelegate>
{
    BMKGeoCodeSearch *_searcher;
}
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@property (nonatomic , strong) BMKPoiInfos *infos;

//@property (nonatomic)CLLocationCoordinate2D pt;
@end
