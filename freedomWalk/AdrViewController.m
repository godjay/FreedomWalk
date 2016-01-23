//
//  AdrViewController.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/4.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "AdrViewController.h"

#import "AdressCell.h"

@interface AdrViewController ()

@end

@implementation AdrViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    _favPoiManager = [[BMKFavPoiManager alloc] init];
    NSArray *array = [_favPoiManager getAllFavPois];
    if (array != nil) {
        _dataArray = [NSArray arrayWithArray:array];
    } else
    {
        _dataArray = [NSArray array];
    }
    //注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"AdressCell" bundle:nil] forCellReuseIdentifier:@"Adress_Cell"];
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoInfo:) name:@"goto_Infos" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteNotifi:) name:@"delete_Info" object:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != _dataArray.count) {
        AdressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Adress_Cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.numLabel.text = [NSString stringWithFormat:@"%ld.",indexPath.section + 1];
        //        cell.model = _dataArray[indexPath.section];
        cell.favPoiInfo = _dataArray[indexPath.section];
        return cell;
    } else{
        NSString *identifier = @"End_Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        UILabel *logoutL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        logoutL.text = @"添加";
        logoutL.textAlignment = NSTextAlignmentCenter;
        logoutL.backgroundColor = [UIColor lightGrayColor];
        cell.backgroundView = logoutL;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == _dataArray.count) {
        return 20;
    } else
    {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _dataArray.count) {
        return 15;
    } else{
        return 0.0001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == _dataArray.count) {
        return 50;
    } else{
        return 105;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == _dataArray.count) {
        NSLog(@"添加");
        FavoritesViewController *favoVC = [[FavoritesViewController alloc] initWithNibName:@"FavoritesViewController" bundle:nil];
        favoVC.delegate = self;
        UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:favoVC];
        [self presentViewController:naviVC animated:YES completion:nil];
    }
}

#pragma mark - 代理
- (void)registSucess:(NSDictionary *)infosDic
{
    _dataArray = [_favPoiManager getAllFavPois];
    
    [self.tableView reloadData];
}

#pragma mark - 通知

- (void)gotoInfo:(NSNotification *)noti
{
    _end = noti.object;
    NSLog(@"%@",_end);
    if (_userLocation == nil) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"你没有定位,请定位!" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertC animated:YES completion:nil];
        //确定按钮事件
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        //取消按钮事件
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
        //添加按钮
        [alertC addAction:cancelAction];
        [alertC addAction:sureAction];
        
    } else
    {
        //初始化检索对象
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
        //发起反向地理编码检索
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeoCodeSearchOption.reverseGeoPoint = _userLocation.location.coordinate;
        BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)deleteNotifi:(NSNotification *)notifi
{
    
    BOOL res = [_favPoiManager deleteFavPoi:notifi.object];
    if (res) {
        [PromptInfo showText:@"清除成功"];
        _dataArray = nil;
    } else {
        [PromptInfo showText:@"清除失败"];
    }
    _dataArray = [_favPoiManager getAllFavPois];
    [self.tableView reloadData];
}

#pragma mark - ReverseGeoCode Delegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableString *mStr = [NSMutableString stringWithFormat:@"%@",result.addressDetail.province];
        [mStr appendFormat:@"%@",result.addressDetail.city];
        [mStr appendFormat:@"%@",result.addressDetail.district];
        [mStr appendFormat:@"%@",result.addressDetail.streetName];
        [mStr appendFormat:@"%@",result.addressDetail.streetNumber];
        _star = [NSString stringWithString:mStr];
        
        NSDictionary *dic = @{
                              @"star":_star,
                              @"end":_end
                              };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goto_Infos_twice" object:self userInfo:dic];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

@end
