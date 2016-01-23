//
//  PanoramaViewController.h
//  BMDemo
//
//  Created by xwbb on 15/12/14.
//  Copyright © 2015年 Mr.Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduPanoramaView.h"
#import "BaiduPanoDataFetcher.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface PanoramaViewController : UIViewController
{
    BaiduPanoramaView *_panoramaView;
}

@property (nonatomic) CLLocationCoordinate2D panoLC;

@end
