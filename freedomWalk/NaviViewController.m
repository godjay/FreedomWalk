//
//  NaviViewController.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/2.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "NaviViewController.h"
#import "MBProgressHUD+MJ.h"
#import "BMKPoiInfos.h"
#import "TestViewController.h"
#import "OutlineViewController.h"

@interface NaviViewController ()<UITextFieldDelegate>
- (IBAction)outline:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *endTextField;

@end

@implementation NaviViewController


- (NSMutableArray *)infoDatas{
    if (_infoDatas == nil) {
        _infoDatas = [NSMutableArray array];
    }
    return _infoDatas;
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _endTextField.returnKeyType = UIReturnKeySearch;
    _endTextField.delegate = self;
//    
//    if (kScreenHeight < 500) {
//        
//        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//        scrollView.backgroundColor = [UIColor colorWithRed:230/255.0 green:238/255.0 blue:241/255.0 alpha:1];
//        //        scrollView.backgroundColor = [UIColor redColor];
//        scrollView.contentSize = CGSizeMake(kScreenWidth, 500);
//        [self.view insertSubview:scrollView atIndex:0];
//        
//        for (UIView *subView in self.view.subviews) {
//            [scrollView addSubview:subView];
//        }
//    }
}


- (IBAction)outline:(id)sender {
    OutlineViewController *out = [[OutlineViewController alloc] init];
    out.title = @"离线导航包";
    [self.navigationController pushViewController:out animated:YES];
}



#pragma TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //收起键盘
    [_endTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Navigation_End" object:_endTextField.text];
    return YES;
}

- (IBAction)buttAction:(UIButton *)sender {
    
    if (sender.tag == 10001) {
        NSLog(@"路况提醒");
    } else if (sender.tag == 10002)
    {
        NSLog(@"导航语音");
    } else if (sender.tag == 10003)
    {
        NSLog(@"离线导航包");
    } 
}

- (IBAction)starSearchAction:(UIButton *)sender {
    //收起键盘
    [_endTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Navigation_End" object:_endTextField.text];
    
}


@end