//
//  CollectionCell.m
//  Nearby
//
//  Created by xwbb on 15/12/4.
//  Copyright © 2015年 Mr.Y. All rights reserved.
//

#import "CollectionCell.h"
#import "NearbyListModel.h"

@implementation CollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(NearbyListModel *)model
{
    _model = model;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.image = [UIImage imageNamed:self.model.imageName];
    self.title.text = self.model.title;
}

@end
