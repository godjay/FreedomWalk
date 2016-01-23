//
//  AdressCell.m
//  freedomWalk
//
//  Created by xwbb on 15/12/17.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "AdressCell.h"


@implementation AdressCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setFavPoiInfo:(BMKFavPoiInfo *)favPoiInfo
{
    _favPoiInfo = favPoiInfo;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _favNameL.text = _favPoiInfo.poiName;
    _adressNameL.text = _favPoiInfo.address;
}

- (IBAction)deleteAction:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"delete_Info" object:_favPoiInfo.favId];

}

- (IBAction)gotoAction:(UIButton *)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"goto_Infos" object:_favPoiInfo.address];
}

@end
