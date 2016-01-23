//
//  YCNavController.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/2.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "YCNavController.h"

@interface YCNavController ()

@end

@implementation YCNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
//30 170 139
+ (void)initialize{
    UINavigationBar *navBar = [UINavigationBar appearance];
//    [navBar setBackgroundImage:[UIImage imageNamed:@"mine_background.jpg"] forBarMetrics:UIBarMetricsDefault];
    [navBar setBarTintColor:[UIColor colorWithRed:30/255.0 green:170/255.0 blue:139/255.0 alpha:1.0]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:dict];
    [navBar setTintColor:[UIColor whiteColor]];
    
}



@end
