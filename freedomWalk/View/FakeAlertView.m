//
//  FakeAlertView.m
//  Nearby
//
//  Created by xwbb on 15/12/9.
//  Copyright © 2015年 Mr.Y. All rights reserved.
//

#import "FakeAlertView.h"

@implementation FakeAlertView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _titles = @[@"评论",@"拍照",@"从相机上传",@"取消"];;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        
        [self _createButton];
        
    }
    return self;
}

- (void)_createButton
{
    for (int i = 0; i < _titles.count; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0,i * (self.frame.size.height / 4), self.frame.size.width, self.frame.size.height / 4);
        button.tag = 1000 + i;
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:21];
        if (i == 0) {
            
            [button setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
        } else if (i == _titles.count - 1)
        {
            button.backgroundColor = [UIColor grayColor];
        }
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)buttonAction:(UIButton *)butt
{
    
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
    CGPathMoveToPoint(path, NULL, 10, self.frame.size.height * 0.25);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width - 10, self.frame.size.height * 0.25);
    
    CGPathMoveToPoint(path, NULL, 10, self.frame.size.height * 0.5);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width - 10, self.frame.size.height * 0.5);
    
    CGPathMoveToPoint(path, NULL, 10, self.frame.size.height * 0.75);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width - 10, self.frame.size.height * 0.75);
    
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
