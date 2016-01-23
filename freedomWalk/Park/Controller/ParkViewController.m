//
//  ParkViewController.m
//  Nearby
//
//  Created by xwbb on 15/12/7.
//  Copyright © 2015年 Mr.Y. All rights reserved.
//

#import "ParkViewController.h"

#import "ParkCell.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ParkViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@end

@implementation ParkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建导航栏
    [self _createNavigationBar];
    
    //创建 TableView
    [self _createTableView];
    
}

//创建导航栏
- (void)_createNavigationBar
{
    self.navigationItem.title = @"停车场";
    
    //左边按钮
    UIButton *leftButt = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButt.frame = CGRectMake(0, 0, 11, 19);
    [leftButt setImage:[UIImage imageNamed:@"back_pic"] forState:UIControlStateNormal];
    [leftButt addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButt];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //右边按钮
    UIButton *rightButt = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButt.frame = CGRectMake(0, 0, 15, 20);
    [rightButt setImage:[UIImage imageNamed:@"01.png"] forState:UIControlStateNormal];
    [rightButt addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];
        
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButt];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 创建 TableView
- (void)_createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册单元格
    [_tableView registerNib:[UINib nibWithNibName:@"ParkCell" bundle:nil] forCellReuseIdentifier:@"Park_Cell"];
    
    [self.view addSubview:_tableView];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ParkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Park_Cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.numLabel.text = [NSString stringWithFormat:@"%ld.",indexPath.section+1];
    
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    } else
    {
        return 0.00001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


#pragma mark - Button Action
- (void)backAction:(UIButton *)butt
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationAction:(UIButton *)butt
{
    
}

@end
