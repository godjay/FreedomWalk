//
//  AdressCell.h
//  freedomWalk
//
//  Created by xwbb on 15/12/17.
//  Copyright © 2015年 YC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface AdressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *favNameL;
@property (weak, nonatomic) IBOutlet UILabel *adressNameL;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (nonatomic , strong) BMKFavPoiInfo *favPoiInfo;

@end
