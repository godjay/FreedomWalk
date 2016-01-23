//
//  YCSettingItem.h
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/4.
//  Copyright © 2015年 YC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCSettingItem : NSObject
@property (nonatomic,copy)NSString *icon;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,assign)Class destVcClass;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;

@end
