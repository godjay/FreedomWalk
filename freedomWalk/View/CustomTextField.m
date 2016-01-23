//
//  CustomTextField.m
//  Nearby
//
//  Created by xwbb on 15/12/4.
//  Copyright © 2015年 Mr.Y. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame withPlaceholder:(NSString *)placeholder withLeftView:(UIView *)leftView
{
    if (self = [super initWithFrame:frame]) {
        //边框设计
        self.layer.cornerRadius = 5;
        //提示内容
        self.placeholder = placeholder;
        
        CGSize size = [placeholder sizeWithAttributes:@{NSFontAttributeName :[UIFont boldSystemFontOfSize:17]}];
        margin = size.width;
    }
    return self;
}

//- (CGRect)textRectForBounds:(CGRect)bounds {
//    int margin = 50;
//    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - margin, bounds.size.height);
//    return inset;
//}
//
//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    int margin = 50;
//    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - margin, bounds.size.height);
//    return inset;
//}

- (CGRect)placeholderRectForBounds:(CGRect)bounds;
{
    int changeX = (bounds.size.width - margin) / 2;
    CGRect inset = CGRectMake(bounds.origin.x + changeX, bounds.origin.y+2, bounds.size.width - margin, bounds.size.height);
    return inset;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds;
{
    int changeX = (bounds.size.width - margin) / 2;
    CGRect inset = CGRectMake(bounds.origin.x + changeX + margin, bounds.origin.y + (20/2)-3, 20, 20);
    return inset;
}

@end
