//
//  AppDelegate.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/11/24.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "AppDelegate.h"
#import "YCNavController.h"
#import "mainViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface AppDelegate ()<BMKGeneralDelegate>

@end
BMKMapManager *_bmkMapmanger;
@implementation AppDelegate



- (BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation
{
    return [TencentOAuth HandleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(nonnull NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    
    _bmkMapmanger = [[BMKMapManager alloc] init];
    BOOL ret = [_bmkMapmanger start:@"v7idfWcq3aFgSgD9xGqNMn5U" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *infoArray = [defaults objectForKey:@"infoArray"];
    if (infoArray != nil) {
        mainViewController *main = [[mainViewController alloc] init];
        YCNavController *mainNav = [[YCNavController alloc] initWithRootViewController:main];
        self.window.rootViewController = mainNav;
    }

    //初始化导航 SDK
    
    [BNCoreServices_Instance initServices:@"v7idfWcq3aFgSgD9xGqNMn5U"];
    [BNCoreServices_Instance startServicesAsyn:^{
        NSLog(@"导航开启成功");
    } fail:^{
        NSLog(@"导航开启失败");
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    [BMKMapView willBackGround];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BMKMapView didForeGround];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }else{
        NSLog(@"错误 %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


@end
