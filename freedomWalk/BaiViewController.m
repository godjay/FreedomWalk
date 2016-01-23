//
//  BaiViewController.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/11/24.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "BaiViewController.h"
#import "MBProgressHUD+MJ.h"

@interface BaiViewController () <UIWebViewDelegate>

- (IBAction)back:(UIBarButtonItem *)sender;

@end

@implementation BaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *BWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:BWebView];
    BWebView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [BWebView loadRequest:request];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //显示提醒框
    [MBProgressHUD showMessage:@"哥在帮你拼命加载ing.."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //隐藏提醒框
    [MBProgressHUD hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //隐藏提醒框
    [MBProgressHUD hideHUD];
}



- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}
@end
