//
//  YCUserInfos.h
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/21.
//  Copyright © 2015年 YC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCUserInfos : NSObject
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,copy)NSString *imageUrl;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
