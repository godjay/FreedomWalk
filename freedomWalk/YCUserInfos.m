//
//  YCUserInfos.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/21.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "YCUserInfos.h"

@implementation YCUserInfos

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.nickname = dic[@"nickname"];
        self.imageUrl = dic[@"figureurl_qq_2"];
    }
    return self;
}

@end
