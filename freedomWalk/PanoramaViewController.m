//
//  PanoramaViewController.m
//  BMDemo
//
//  Created by xwbb on 15/12/14.
//  Copyright © 2015年 Mr.Y. All rights reserved.
//

#import "PanoramaViewController.h"

@interface PanoramaViewController ()

@end

@implementation PanoramaViewController

- (void)dealloc
{
    [_panoramaView removeFromSuperview];
    _panoramaView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    // key 为在百度LBS平台上统一申请的接入密钥ak 字符串
    _panoramaView = [[BaiduPanoramaView alloc] initWithFrame:frame key:@"v7idfWcq3aFgSgD9xGqNMn5U"];
    // 为全景设定一个代理
    //    _panoramaView.delegate = self;
    [self.view addSubview:_panoramaView];
    // 设定全景的清晰度， 默认为middle
    [_panoramaView setPanoramaImageLevel:ImageDefinitionMiddle];
    
    // 切换全景场景至指定的地理坐标
    [_panoramaView setPanoramaWithLon:_panoLC.longitude lat:_panoLC.latitude];
    
}



@end
