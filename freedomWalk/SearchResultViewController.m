//
//  SearchResultViewController.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/10.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "SearchResultViewController.h"
#import "BMKPoiInfos.h"
#import "MJRefresh.h"

@interface SearchResultViewController ()
@end

@implementation SearchResultViewController

- (NSMutableArray *)infoData{
    if (_infoData == nil) {
        _infoData = [NSMutableArray array];
    }
    return _infoData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];

    [self setupRefresh];
}

- (void)setupRefresh{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)footerRereshing{
    //通知代理
    if ([self.delegate respondsToSelector:@selector(loadMoreData)]) {
        [self.delegate loadMoreData];
    }
    
    //刷新表格
    [self.tableView reloadData];
    
    [self.tableView.mj_footer endRefreshing];
}

- (void)setupNav {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 11, 19);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_pic"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn addTarget:self action:@selector(backBClick) forControlEvents:UIControlEventTouchUpInside];
}

//返回按钮点击
- (void)backBClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"info";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    BMKPoiInfos *infos = self.infoData[indexPath.row];
    cell.textLabel.text = infos.name;
    cell.detailTextLabel.text = infos.address;
    NSLog(@"%@",infos.name);
    return cell;
}




@end
