//
//  HistoryViewController.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/4.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "HistoryViewController.h"

#import "HistoryCell.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    //注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryCell" bundle:nil] forCellReuseIdentifier:@"History_Cell"];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 10;
    } else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"History_Cell" forIndexPath:indexPath];
        return cell;
    } else
    {
        NSString *identifier = @"End_Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        UILabel *logoutL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        logoutL.text = @"清除历史记录";
        logoutL.textAlignment = NSTextAlignmentCenter;
        logoutL.backgroundColor = [UIColor lightGrayColor];
        cell.backgroundView = logoutL;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    } else{
        return 30;
    }
}


@end
