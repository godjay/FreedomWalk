//
//  QQViewController.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/11/24.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "QQViewController.h"
#import "MBProgressHUD+MJ.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "mainViewController.h"
#import "YCNavController.h"
#import "YCUserInfos.h"

@interface QQViewController ()<TencentSessionDelegate,TencentLoginDelegate>

{
    TencentOAuth *tencentOAuth;
    NSArray *permissions;
}


@end

@implementation QQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    tencentOAuth = [[TencentOAuth alloc]initWithAppId:@"1104911809" andDelegate:self];
    //设置需要的权限列表，此处尽量使用什么取什么。
    permissions = [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t",nil];

    [tencentOAuth authorize:permissions inSafari:NO];
}

//登陆完成调用
- (void)tencentDidLogin
{

    NSLog(@"登录完成");
    if (tencentOAuth.accessToken && 0 != [tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        [tencentOAuth getUserInfo];
        
        //获得
        NSString *accessToken = tencentOAuth.accessToken;
        NSString *openId = tencentOAuth.openId;
        NSDate *expDate = tencentOAuth.expirationDate;
        NSArray *infoArray = @[accessToken,openId,expDate];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:infoArray forKey:@"infoArray"];
        [defaults synchronize];

        //设置
//        [tencentOAuth setAccessToken:accessToken];
//        [tencentOAuth setOpenId:openId];
//        [tencentOAuth setExpirationDate:expDate];
        
        //登录成功跳转主控制器
        mainViewController *main = [[mainViewController alloc] init];
        YCNavController *nav = [[YCNavController alloc] initWithRootViewController:main];
        self.view.window.rootViewController = nav;
    }
    else
    {
        NSLog(@"登录不成功 没有获取accesstoken");
    }
    
}

//非网络错误导致登录失败：
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"tencentDidNotLogin");
    if (cancelled)
    {
        NSLog(@"用户取消登录");
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        NSLog(@"登录失败");
    }
}

// 网络错误导致登录失败：
-(void)tencentDidNotNetWork
{
    NSLog(@"无网络连接，请设置网络");
}


-(void)getUserInfoResponse:(APIResponse *)response
{
    NSLog(@"respons:%@",response.jsonResponse);
    YCUserInfos *userInfos = [[YCUserInfos alloc] initWithDic:response.jsonResponse];
    NSLog(@"%@",userInfos.imageUrl);
    NSString *imageUrl = userInfos.imageUrl;
    NSString *nickName = userInfos.nickname;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userInfos.imageUrl]]];
//    NSData *imageData = UIImagePNGRepresentation(image);
    [defaults setObject:imageUrl forKey:@"image"];
    [defaults setObject:nickName forKey:@"nickName"];
    [defaults synchronize];
}





@end
