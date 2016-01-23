//
//  FakeTabBarView.m
//  Nearby
//
//  Created by xwbb on 15/12/7.
//  Copyright © 2015年 Mr.Y. All rights reserved.
//

#import "FakeTabBarView.h"

@implementation FakeTabBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _imageNames = @[@"周边",@"电话",@"评论",@"报错"];
        _titles = @[@" 周边",@" 电话",@" 评论",@" 报错"];;
        
        [self _createButton];
        
    }
    return self;
}

- (void)_createButton
{
    for (int i = 0; i < _titles.count; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * (self.frame.size.width / 4), 0, self.frame.size.width / 4, self.frame.size.height);
        button.tag = 100 + i;
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button setImage:[UIImage imageNamed:_imageNames[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)buttonAction:(UIButton *)butt
{
    if (butt.tag == 100) {
        NSLog(@"周边");
    } else if (butt.tag == 101)
    {
        NSLog(@"电话");
    } else if (butt.tag == 102)
    {
        NSLog(@"评论");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MaskView_Notification" object:nil];
        
    } else if (butt.tag == 103)
    {
        NSLog(@"报错");
    }
}

- (void)drawRect:(CGRect)rect {
    //取出上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawLine:context];
}

- (void)drawLine:(CGContextRef)context
{
    //绘制路径
    CGMutablePathRef path = CGPathCreateMutable();
    
    //设计路径
    CGPathMoveToPoint(path, NULL, self.frame.size.width * 0.25, 20);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width * 0.25, 30);
    
    CGPathMoveToPoint(path, NULL, self.frame.size.width * 0.5, 20);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width * 0.5, 30);
    
    CGPathMoveToPoint(path, NULL, self.frame.size.width * 0.75, 20);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width * 0.75, 30);
    
    //添加到上下文
    CGContextAddPath(context, path);
    
    //设置 显示样式
    //线的宽度
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    //绘制上下文
    CGContextDrawPath(context, kCGPathStroke);
    
    //内存管理---遇到 create.copy 都需要 release
    CGPathRelease(path);
}

@end
