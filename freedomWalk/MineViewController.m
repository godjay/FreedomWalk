//
//  MineViewController.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/2.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "MineViewController.h"
#import "YCSettingItem.h"
#import "YCSettingGroup.h"
#import "HistoryViewController.h"
#import "OutlineViewController.h"
#import "OutlineViewController.h"
#import "AdrViewController.h"
#import "SettingViewController.h"
#import "YCNavController.h"
#import "ViewController.h"

#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height
#define iconBtnWH 90
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
@end

@implementation MineViewController

//懒加载
- (NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor colorWithRed:234/255.0 green:240/255.0 blue:243/255.0 alpha:1.0]];
    //设置导航栏为不透明
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupHeaderView];
    
    //不可滚动
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, KHeight / 2.7, self.view.frame.size.width - 20, KHeight / 2.0)];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self setupGroup0];
    [self setupGroup1];
}

- (void)setupHeaderView{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight / 2.7)];
    UIImageView *mineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_background.jpg"]];
    mineView.frame = CGRectMake(0, 0, KWidth, KHeight / 2.7);
    
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.layer.cornerRadius = 45.0;
    iconBtn.clipsToBounds = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *imageUrl = [defaults objectForKey:@"image"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
    
    [iconBtn setBackgroundImage:image forState:UIControlStateNormal];
    [iconBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    CGFloat iconBtnY = (KHeight / 2.7 - 90)/3;
    iconBtn.frame = CGRectMake((KWidth - 90)/2, iconBtnY, iconBtnWH, iconBtnWH);
    
    UILabel *nickLable = [[UILabel alloc] initWithFrame:CGRectMake(0, iconBtnY + iconBtnWH + 20, KWidth, iconBtnWH / 2)];
    nickLable.textAlignment = NSTextAlignmentCenter;
    NSString *nickName = [defaults objectForKey:@"nickName"];
    nickLable.text = nickName;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back_pic"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(20, 30, 11, 19);
    [backBtn addTarget:self action:@selector(mineBackClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *mineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mineBtn setImage:[UIImage imageNamed:@"我的消息"] forState:UIControlStateNormal];
    mineBtn.frame = CGRectMake(KWidth - 30, 30, 16, 17);
    
    [header addSubview:mineView];
    [header addSubview:iconBtn];
    [header addSubview:nickLable];
    [header addSubview:backBtn];
    [header addSubview:mineBtn];
    [self.view addSubview:header];
}

- (void)setupGroup0{
    YCSettingItem *history = [YCSettingItem itemWithIcon:@"我的历史记录" title:@"历史记录" destVcClass:[HistoryViewController class]];
    YCSettingItem *outline = [YCSettingItem itemWithIcon:@"mine_package" title:@"离线包下载" destVcClass:[OutlineViewController class]];
    YCSettingItem *adr = [YCSettingItem itemWithIcon:@"我的常用地址" title:@"常用地址" destVcClass:[AdrViewController class]];
    YCSettingGroup *group0 = [[YCSettingGroup alloc] init];
    group0.items = @[history,outline,adr];
    [self.data addObject:group0];

}

- (void)setupGroup1{
    YCSettingItem *setting = [YCSettingItem itemWithIcon:@"我的设置" title:@"设置" destVcClass:[SettingViewController class]];
    YCSettingItem *outLogin = [YCSettingItem itemWithIcon:@"我的退出账号" title:@"退出帐号"];
    YCSettingGroup *group1 = [[YCSettingGroup alloc] init];
    group1.items = @[setting,outLogin];
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
    static NSString *ID = @"mine";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    YCSettingGroup *group = self.data[indexPath.section];
    YCSettingItem *item = group.items[indexPath.row];
    cell.textLabel.text = item.title;
    cell.imageView.image = [UIImage imageNamed:item.icon];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    YCSettingGroup *group = self.data[indexPath.section];
    YCSettingItem *item = group.items[indexPath.row];
    if (item.destVcClass != nil){
    UIViewController *vc = [[item.destVcClass alloc] init];
        if ([vc isKindOfClass:[AdrViewController class]]) {
            AdrViewController *adrVC = (AdrViewController *)vc;
            adrVC.userLocation = _userLocation;
        }
    vc.title = item.title;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 11, 19);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_pic"] forState:UIControlStateNormal];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn addTarget:self action:@selector(mineBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSLog(@"退出登录....");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *appDomain = [[NSBundle mainBundle]bundleIdentifier];
        [defaults removePersistentDomainForName:appDomain];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *viewC = (ViewController *)[storyboard instantiateInitialViewController];
        [self presentViewController:viewC animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 10;
}

//按钮点击
- (void)mineBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
