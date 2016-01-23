//
//  CommentsCell.m
//  Nearby
//
//  Created by xwbb on 15/12/7.
//  Copyright © 2015年 Mr.Y. All rights reserved.
//

#import "CommentsCell.h"
#import "StarView.h"

@implementation CommentsCell

- (void)awakeFromNib {
    
    _picView.layer.cornerRadius = 5.0;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _ratingView.rating = 9.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
