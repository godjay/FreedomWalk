//
//  DetailViewController.m
//  Nearby
//
//  Created by xwbb on 15/12/7.
//  Copyright © 2015年 Mr.Y. All rights reserved.
//

#import "DetailViewController.h"

#import "IntroduceCell.h"
#import "CommentsCell.h"
#import "LocationCell.h"

#import "FakeTabBarView.h"
#import "FakeAlertView.h"

#import "UIViewExt.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    //遮罩视图
    UIControl *_maskView;
    UITableView *_tableView;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //创建导航栏
    [self _createNavigationBar];
    
    //创建 TableView
    [self _createTableView];
    
    //创建 FakeTabBar
    [self _createFakeTabBar];

    //创建遮罩视图
    [self _createMaskView];
    
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"MaskView_Notification" object:nil];
}

#pragma mark - Create Views
//创建导航栏
- (void)_createNavigationBar
{
    //左边按钮
    UIButton *leftButt = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButt.frame = CGRectMake(0, 0, 11, 19);
    [leftButt setImage:[UIImage imageNamed:@"back_pic"] forState:UIControlStateNormal];
    [leftButt addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButt];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //收藏按钮
    UIButton *rightButt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButt1.frame = CGRectMake(0, 0, 65, 23);
    [rightButt1 setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    [rightButt1 setTitle:@"收藏" forState: UIControlStateNormal];
    [rightButt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButt1 addTarget:self action:@selector(hobbyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightButt1];
    
    //分享按钮
    UIButton *rightButt2 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButt2.frame = CGRectMake(0, 0, 60, 25);
    [rightButt2 setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [rightButt2 setTitle:@"分享" forState: UIControlStateNormal];
    [rightButt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButt2 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithCustomView:rightButt2];

    NSArray *rightItems = @[rightItem2,rightItem1];
    self.navigationItem.rightBarButtonItems = rightItems;
    
}

//创建 TableView
- (void)_createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 50) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册单元格
    [_tableView registerNib:[UINib nibWithNibName:@"IntroduceCell" bundle:nil] forCellReuseIdentifier:@"Introduce_Cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CommentsCell" bundle:nil] forCellReuseIdentifier:@"Comments_Cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LocationCell" bundle:nil] forCellReuseIdentifier:@"Location_Cell"];
    [self.view addSubview:_tableView];
}

- (void)_createFakeTabBar
{
    FakeTabBarView *fTabbar = [[FakeTabBarView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    fTabbar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:fTabbar];
}

- (void)_createMaskView
{
    _maskView = [[UIControl alloc] initWithFrame:self.view.bounds];
    //设置背景颜色
    _maskView.backgroundColor = [UIColor colorWithWhite:.2 alpha:.5];
    //隐藏遮罩视图
    _maskView.hidden = YES;
    
    FakeAlertView *faView = [[FakeAlertView alloc] initWithFrame:CGRectMake((kScreenWidth - 300)/2, (kScreenHeight - 270)/2, 300, 270)];
    [_maskView addSubview:faView];
    
    //添加到头视图下面
    [self.navigationController.view addSubview:_maskView];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section == 2) {
        return 10;
    } else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0) {
        IntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Introduce_Cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    } else if (indexPath.section == 1)
    {
        LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Location_Cell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 2)
    {
        CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Comments_Cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 3)
    {
        NSString *identifier = @"End_Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.textLabel.text = @"查看剩余209条评论";
            cell.textLabel.textColor = [UIColor cyanColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
    return nil;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 50;
    }
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110;
    } else if (indexPath.section == 1)
    {
        return 100;
    } else if (indexPath.section == 2)
    {
        return 200;
    } else
    {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2 || section == 3) {
        return 0.00001;
    } else
    {
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, 200, 50)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(bgView.left, 0, 100, 50)];
        titleL.text = @"热门评论";
        titleL.textColor = [UIColor blackColor];
        titleL.font = [UIFont systemFontOfSize:25 weight:13];
        [bgView addSubview:titleL];
        
        UIImageView *picV = [[UIImageView alloc] initWithFrame:CGRectMake(titleL.right, (bgView.height - 15)/2, 20, 17)];
        picV.image = [UIImage imageNamed:@"热门评论"];
        [bgView addSubview:picV];
        
        return bgView;
    }
    return nil;
}

#pragma mark -Button Action
- (void)backAction:(UIButton *)butt
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hobbyAction:(UIButton *)butt
{
    NSLog(@"收藏");
}

- (void)shareAction:(UIButton *)butt
{
    NSLog(@"分享");
}

#pragma mark - Notification
- (void)notificationAction:(NSNotification *)notifi
{
    _maskView.hidden = NO;
}

@end
