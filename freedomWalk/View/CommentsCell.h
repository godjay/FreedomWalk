//
//  CommentsCell.h
//  Nearby
//
//  Created by xwbb on 15/12/7.
//  Copyright © 2015年 Mr.Y. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StarView;
@interface CommentsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet StarView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picView;


@end
