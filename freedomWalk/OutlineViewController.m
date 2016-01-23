//
//  OutlineViewController.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/4.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "OutlineViewController.h"
#import "MBProgressHUD+MJ.h"
#import "OfflineDemoMapViewController.h"


#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height

@interface OutlineViewController ()<BMKOfflineMapDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation OutlineViewController
- (void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor colorWithRed:234/255.0 green:240/255.0 blue:243/255.0 alpha:1.0]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化离线地图服务
    _offlineMap = [[BMKOfflineMap alloc] init];
    _offlineMap.delegate = self;
    _arrayHotCityData = [_offlineMap getHotCityList];
    _arrayOfflineCityData = [_offlineMap getOfflineCityList];
    
    [self setupView];

}

- (void)setupView {
    
    UIView *search = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KWidth, 64)];
    search.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:search];
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"1",@"2", nil];
    UISegmentedControl *tableChangeControl = [[UISegmentedControl alloc] initWithItems:array];
    self.tableChangeControl = tableChangeControl;
    [tableChangeControl addTarget:self action:@selector(indexChange) forControlEvents:UIControlEventValueChanged];
    
    [tableChangeControl setTitle:@"未下载" forSegmentAtIndex:0];
    [tableChangeControl setTitle:@"已下载" forSegmentAtIndex:1];
    tableChangeControl.tintColor = [UIColor colorWithRed:26.0/255.0 green:193.0/255.0 blue:105.0/255.0 alpha:1];
    [tableChangeControl setBackgroundImage:[UIImage imageNamed:@"mine_background"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    NSDictionary *textAttr1 = @{NSFontAttributeName:[UIFont systemFontOfSize:17],
                               NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSDictionary *textAttr2 = @{NSFontAttributeName:[UIFont systemFontOfSize:17],
                                NSForegroundColorAttributeName:[UIColor grayColor]};
    [tableChangeControl setTitleTextAttributes:textAttr1 forState:UIControlStateSelected];
    [tableChangeControl setTitleTextAttributes:textAttr2 forState:UIControlStateNormal];

    CGFloat tableChangeControlW = KWidth / 2.6;
    CGFloat tableChangeControlH = 64 / 1.6;
    CGFloat tableChangeControlX = (KWidth - tableChangeControlW) / 2;
    CGFloat tableChangeControlY = (64 - tableChangeControlH) / 2 + 64;
    tableChangeControl.frame = CGRectMake(tableChangeControlX, tableChangeControlY, tableChangeControlW, tableChangeControlH);
    tableChangeControl.selectedSegmentIndex = 0;
    
    [self.view addSubview:tableChangeControl];
    
    _groupTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tableChangeControl.frame) + 20, KWidth - 20, KHeight - CGRectGetMaxY(tableChangeControl.frame) - 20)];
    _groupTableView.showsVerticalScrollIndicator = NO;
    _groupTableView.delegate = self;
    _groupTableView.dataSource = self;
    _groupTableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:240/255.0 blue:243/255.0 alpha:1.0];
    _plainTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tableChangeControl.frame) + 20, KWidth - 20, KHeight - CGRectGetMaxY(tableChangeControl.frame) - 20)];
    _groupTableView.showsVerticalScrollIndicator = NO;
    _plainTableView.delegate = self;
    _plainTableView.dataSource = self;
    
    [self.view addSubview:_plainTableView];

    [self.view addSubview:_groupTableView];
}

- (void)dealloc {
    NSLog(@"xh");
    if (_offlineMap != nil) {
        _offlineMap = nil;
    }
}

- (void)indexChange{
    if (self.tableChangeControl.selectedSegmentIndex == 0) {
        _groupTableView.hidden = NO;
        _plainTableView.hidden = YES;
        [_groupTableView reloadData];
    }else{
        _groupTableView.hidden = YES;
        _plainTableView.hidden = NO;
        //获取各城市离线地图更新信息
        _arraylocalDownLoadMapInfo = [NSMutableArray arrayWithArray:[_offlineMap getAllUpdateInfo]];
        [_plainTableView reloadData];
    }
}

//离线地图delegate，用于获取通知
- (void)onGetOfflineMapState:(int)type withState:(int)state
{
    
    if (type == TYPE_OFFLINE_UPDATE) {
        //id为state的城市正在下载或更新，start后会毁掉此类型
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        NSLog(@"城市名：%@,下载比例:%d",updateInfo.cityName,updateInfo.ratio);

        if (updateInfo.ratio == 100) {
            [MBProgressHUD showSuccess:@"坑爹完成"];
        }
    }
    if (type == TYPE_OFFLINE_NEWVER) {
        //id为state的state城市有新版本,可调用update接口进行更新
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        NSLog(@"是否有更新%d",updateInfo.update);
    }
    if (type == TYPE_OFFLINE_UNZIP) {
        //正在解压第state个离线包，导入时会回调此类型
    }
    if (type == TYPE_OFFLINE_ZIPCNT) {
        //检测到state个离线包，开始导入时会回调此类型
        NSLog(@"检测到%d个离线包",state);
        if(state==0)
        {
            [self showImportMesg:state];
        }
    }
    if (type == TYPE_OFFLINE_ERRZIP) {
        //有state个错误包，导入完成后会回调此类型
        NSLog(@"有%d个离线包导入错误",state);
    }
    if (type == TYPE_OFFLINE_UNZIPFINISH) {
        NSLog(@"成功导入%d个离线包",state);
        //导入成功state个离线包，导入成功后会回调此类型
        [self showImportMesg:state];
    }
//    [MBProgressHUD hideHUD];

}

//导入提示框
- (void)showImportMesg:(int)count
{
    NSString* showmeg = [NSString stringWithFormat:@"成功导入离线地图包个数:%d", count];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"导入离线地图" message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    [myAlertView show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == _groupTableView)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

//定义section标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView == _groupTableView)
    {
        //定义每个section的title
        NSString *provincName=@"";
        if(section == 0)
        {
            provincName=@"热门城市";
        }
        else if(section == 1)
        {
            provincName=@"全国";
        }
        return provincName;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == _groupTableView)
    {
        if(section == 0)
        {
            return [_arrayHotCityData count];
        }
        else if(section == 1)
        {
            return [_arrayOfflineCityData count];
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return [_arraylocalDownLoadMapInfo count];
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"OfflineMapCityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if(tableView == _groupTableView)
    {
        //热门城市列表
        if(indexPath.section == 0)
        {
            BMKOLSearchRecord* item = [_arrayHotCityData objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", item.cityName];
            
            UIView *download = [[UIView alloc] initWithFrame:CGRectMake(KWidth * 0.7, 0, KWidth / 5, 40)];
//            download.backgroundColor = [UIColor redColor];
            //转换包大小
            NSString*packSize = [self getDataSizeString:item.size];
            UILabel *sizelabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
            sizelabel.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin;
            sizelabel.text = packSize;
            sizelabel.backgroundColor = [UIColor clearColor];
            [download addSubview:sizelabel];
            
            UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            downBtn.userInteractionEnabled = NO;
            downBtn.frame = CGRectMake(50, 10, 20, 20);
            [downBtn setBackgroundImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
            [download addSubview:downBtn];
            
            cell.accessoryView = download;
        }
        //支持离线下载城市列表
        else if(indexPath.section == 1)
        {
            BMKOLSearchRecord* item = [_arrayOfflineCityData objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", item.cityName];

            UIView *download = [[UIView alloc] initWithFrame:CGRectMake(KWidth * 0.7, 0, KWidth / 5, 40)];
            //转换包大小
            NSString*packSize = [self getDataSizeString:item.size];
            UILabel *sizelabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
            sizelabel.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin;
            sizelabel.text = packSize;
            sizelabel.backgroundColor = [UIColor clearColor];
            [download addSubview:sizelabel];
            
            UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            downBtn.userInteractionEnabled = NO;
            downBtn.frame = CGRectMake(50, 10, 20, 20);
            [downBtn setBackgroundImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
            [download addSubview:downBtn];
            
            cell.accessoryView = download;
        }
    }
    else
    {
        if(_arraylocalDownLoadMapInfo != nil && _arraylocalDownLoadMapInfo.count > indexPath.row)
        {
            BMKOLUpdateElement* item = [_arraylocalDownLoadMapInfo objectAtIndex:indexPath.row];
            //是否可更新
            if(item.update)
            {
//                cell.textLabel.text = [NSString stringWithFormat:@"%@————%d(可更新)", item.cityName,item.ratio];
                cell.textLabel.text = [NSString stringWithFormat:@"%@(可更新)", item.cityName];
            }
            else
            {
//                cell.textLabel.text = [NSString stringWithFormat:@"%@————%d", item.cityName,item.ratio];
                cell.textLabel.text = [NSString stringWithFormat:@"%@(最新)", item.cityName];
            }
        }
        else
        {
            cell.textLabel.text = @"";
        }
    }

    return cell;
}

//是否允许table进行编辑操作
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == _groupTableView)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

//提交编辑列表的结果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除poi
        if (tableView == _plainTableView) {
            BMKOLUpdateElement* item = [_arraylocalDownLoadMapInfo objectAtIndex:indexPath.row];
            //删除指定城市id的离线地图
            [_offlineMap remove:item.cityID];
            //将此城市的离线地图信息从数组中删除
            [(NSMutableArray*)_arraylocalDownLoadMapInfo removeObjectAtIndex:indexPath.row];
            [_plainTableView reloadData];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if(tableView == _groupTableView)
    {
        //热门城市列表
        if(indexPath.section == 0)
        {
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"离线包下载" message:@"你确定你要下载坑爹的地图？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [MBProgressHUD showSuccess:@"坑爹开始"];
                BMKOLSearchRecord* item = [_arrayHotCityData objectAtIndex:indexPath.row];
                //                NSLog(@"%d",item.cityID);
                [_offlineMap start:item.cityID];
            }];
            [aler addAction:cancel];
            [aler addAction:ok];
            [self presentViewController:aler animated:YES completion:nil];
        }
        //支持离线下载城市列表
        else if(indexPath.section == 1)
        {
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"离线包下载" message:@"你确定你要下载坑爹的地图？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                BMKOLSearchRecord* item = [_arrayOfflineCityData objectAtIndex:indexPath.row];
                //                NSLog(@"%d",item.cityID);
                [_offlineMap start:item.cityID];
            }];
            [aler addAction:cancel];
            [aler addAction:ok];
            [self presentViewController:aler animated:YES completion:nil];
        }
    }/*
    else
    {
        BMKOLUpdateElement* item = [_arraylocalDownLoadMapInfo objectAtIndex:indexPath.row];
        if(item.ratio==100&&item.update)//跳转到地图查看页面进行地图更新
            //        if(item.ratio==100)
        {
            //跳转到地图浏览页面
            OfflineDemoMapViewController *offlineMapViewCtrl = [[OfflineDemoMapViewController alloc] init];
            offlineMapViewCtrl.title = @"查看离线地图";
            offlineMapViewCtrl.cityId = item.cityID;
            offlineMapViewCtrl.offlineServiceOfMapview = _offlineMap;
            UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
            customLeftBarButtonItem.title = @"返回";
            self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
            [self.navigationController pushViewController:offlineMapViewCtrl animated:YES];
            
        }
        else if(item.ratio<100)//弹出提示框
        {
            //            cityId.text = [NSString stringWithFormat:@"%d",item.cityID];
            //            cityName.text = item.cityName;
            //            downloadratio.text = [NSString stringWithFormat:@"已下载:%d", item.ratio];
            //            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该离线地图未完全下载，请继续下载！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            //            [myAlertView show];
        }
        
    }
         */
}

#pragma mark 包大小转换工具类（将包大小转换成合适单位）
-(NSString *)getDataSizeString:(int) nSize
{
    NSString *string = nil;
    if (nSize<1024)
    {
        string = [NSString stringWithFormat:@"%dB", nSize];
    }
    else if (nSize<1048576)
    {
        string = [NSString stringWithFormat:@"%dK", (nSize/1024)];
    }
    else if (nSize<1073741824)
    {
        if ((nSize%1048576)== 0 )
        {
            string = [NSString stringWithFormat:@"%dM", nSize/1048576];
        }
        else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int i = decimal / 10;
                if (i >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int i = decimal / 100;
                if (i >= 5)
                {
                    decimal = i + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%dMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%d.%@M", nSize/1048576, decimalStr];
            }
        }
    }
    else	// >1G
    {
        string = [NSString stringWithFormat:@"%dG", nSize/1073741824];
    }
    
    return string;
}

@end
