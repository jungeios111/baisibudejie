//
//  ZKJFriendTrendsController.m
//  百思不得姐
//
//  Created by ZKJ on 2017/2/20.
//  Copyright © 2017年 ZKJ. All rights reserved.
//

#import "ZKJFriendTrendsController.h"
#import "ZKJRecommendViewController.h"
#import "ZKJLoginRegisterVC.h"

@interface ZKJFriendTrendsController ()

@end

@implementation ZKJFriendTrendsController

/**
 * 在xib或者storyboard文件中,实现label的title文字换行:按住option键敲回车
 */




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景色
    self.view.backgroundColor = ZKJGlobalBGColor;
    self.navigationItem.title = @"我的关注";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" andHighLightImage:@"friendsRecommentIcon-click" andTarget:self andAction:@selector(btnClick)];
}

- (void)btnClick
{
//    ZKJLogFunC;
    ZKJRecommendViewController *vc = [[ZKJRecommendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginClick:(id)sender {
    ZKJLoginRegisterVC *vc = [[ZKJLoginRegisterVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
