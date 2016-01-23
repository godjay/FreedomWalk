//
//  StarView.m
//  Demo2 评分视图（封装）
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 Mr.Y. All rights reserved.
//

#import "StarView.h"
#import "UIViewExt.h"
@implementation StarView

//1.alloc 初始化方式
- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if ( self ) {
        
        [self _createSubviews];
        
    }
    
    return self;
}

//2.xib文件初始化的时候，在awakeFromNib中创建子视图
- (void)awakeFromNib
{
//    [super awakeFromNib];
    
    [self _createSubviews];
    
}

//创建子视图
- (void)_createSubviews
{
    //获取图片
    UIImage *grayImg = [UIImage imageNamed:@"评分(01).png"];
    UIImage *yellowImg = [UIImage imageNamed:@"评分.png"];
    
    //获取图片宽度和高度
    CGFloat width = grayImg.size.width;
    CGFloat height = grayImg.size.height;
    
    //1.灰色星星视图
    _grayStar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width * 5, height)];
    //设置背景颜色
    _grayStar.backgroundColor = [UIColor colorWithPatternImage:grayImg];
    [self addSubview:_grayStar];
    
    //2.金色星星视图
    _yellowStar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width * 5, height)];
    //设置背景颜色
    _yellowStar.backgroundColor = [UIColor colorWithPatternImage:yellowImg];
    [self addSubview:_yellowStar];
    
    
    //放大的比例(根据高度修改)
    float scale = self.height / _grayStar.height;
    
    _grayStar.transform = CGAffineTransformMakeScale(scale, scale);
    _yellowStar.transform = CGAffineTransformMakeScale(scale, scale);
    
    //设置要显示的视图的宽度
    _viewWidth = _grayStar.width;
    
    //还原到原来的坐标原点
    _grayStar.origin = CGPointMake(0, 0);
    _yellowStar.origin = CGPointMake(0, 0);
    
}

- (void)setRating:(float)rating
{
    
    _rating = rating;
    
    [self setNeedsLayout];
    
}

- (void)layoutSubviews
{
    //根据评分，修改金色星星视图的宽度
    _yellowStar.width = _viewWidth * _rating * .1;
    
}

@end
