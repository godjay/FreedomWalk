//
//  StarView.h
//  Demo2 评分视图（封装）
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 Mr.Y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarView : UIView

{

    UIView *_grayStar;
    UIView *_yellowStar;
    
    CGFloat _viewWidth; //要显示的视图的宽度
    
}

@property (nonatomic , assign)float rating;

@end
