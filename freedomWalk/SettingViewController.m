//
//  SettingViewController.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/4.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "SettingViewController.h"
#import "YCSettingItem.h"
#import "YCSettingGroup.h"

#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height

@interface SettingViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation SettingViewController

//懒加载
- (NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor colorWithRed:234/255.0 green:240/255.0 blue:243/255.0 alpha:1.0]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, KWidth - 20, KHeight * 0.63)];
    //不可滚动
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    [self setupGroup0];
    [self setupGroup1];
}

- (void)setupGroup0{
    YCSettingItem *text1 = [YCSettingItem itemWithIcon:@"消息通知" title:@"消息通知"];
    YCSettingItem *text2 = [YCSettingItem itemWithIcon:@"我的设置" title:@"导航设置"];
    YCSettingItem *text3 = [YCSettingItem itemWithIcon:@"重置地图" title:@"重置地图"];
    YCSettingGroup *group0 = [[YCSettingGroup alloc] init];
    group0.items = @[text1,text2,text3];
    [self.data addObject:group0];
    
}

- (void)setupGroup1{
    YCSettingItem *text4 = [YCSettingItem itemWithIcon:@"关于" title:@"关于" destVcClass:[SettingViewController class]];
    YCSettingItem *text5 = [YCSettingItem itemWithIcon:@"应用推荐" title:@"应用推荐"];
    YCSettingGroup *group1 = [[YCSettingGroup alloc] init];
    group1.items = @[text4,text5];
    [self.data addObject:group1];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YCSettingGroup *group = self.data[section];
    return group.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"text";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    YCSettingGroup *group = self.data[indexPath.section];
    YCSettingItem *item = group.items[indexPath.row];
    cell.textLabel.text = item.title;
    cell.imageView.image = [UIImage imageNamed:item.icon];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
@end
