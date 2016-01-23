//
//  SearchResultViewController.h
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/10.
//  Copyright © 2015年 YC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchResultViewControllerDelegate <NSObject>

@optional

- (void)loadMoreData;

@end

@interface SearchResultViewController : UITableViewController

@property (nonatomic,strong)NSMutableArray *infoData;

@property (nonatomic,weak)id<SearchResultViewControllerDelegate>delegate;

@end
