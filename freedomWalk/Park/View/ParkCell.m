//
//  ParkCell.m
//  Nearby
//
//  Created by xwbb on 15/12/7.
//  Copyright © 2015年 Mr.Y. All rights reserved.
//

#import "ParkCell.h"
#import "BMKPoiInfos.h"

@implementation ParkCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setInfos:(BMKPoiInfos *)infos
{
    _infos = infos;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _nameLabel.text = self.infos.name;
    _adressLabel.text = _infos.address;
    _distanceLabel.text = [NSString stringWithFormat:@"%.1fKM",_infos.distance / 1000.0];
}

- (IBAction)lookPano:(UIButton *)sender {
    CLLocationCoordinate2D pt = _infos.pt;
    NSValue *value = [NSValue valueWithBytes:&pt objCType:@encode(CLLocationCoordinate2D)];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openPano_Navi" object:value];
}

- (IBAction)gotoThere:(UIButton *)sender {
    
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    //    发起反向地理编码检索
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = _infos.pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

#pragma mark - ReverseGeoCode Delegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableString *mStr = [NSMutableString stringWithFormat:@"%@",result.addressDetail.province];
        [mStr appendFormat:@"%@",result.addressDetail.city];
        [mStr appendFormat:@"%@",result.addressDetail.district];
        [mStr appendFormat:@"%@",result.addressDetail.streetName];
        [mStr appendFormat:@"%@",result.addressDetail.streetNumber];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"goto_Navi" object:mStr];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

@end
