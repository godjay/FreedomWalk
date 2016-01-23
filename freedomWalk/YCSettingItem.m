//
//  YCSettingItem.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/4.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "YCSettingItem.h"

@implementation YCSettingItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title{
    YCSettingItem *item = [[YCSettingItem alloc] init];
    item.icon = icon;
    item.title = title;
    return item;
}
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass{
    YCSettingItem *item = [YCSettingItem itemWithIcon:icon title:title];
    item.destVcClass = destVcClass;
    return item;
}
@end
