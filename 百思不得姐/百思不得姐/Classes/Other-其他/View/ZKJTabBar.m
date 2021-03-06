//
//  ZKJTabBar.m
//  百思不得姐
//
//  Created by ZKJ on 2017/2/20.
//  Copyright © 2017年 ZKJ. All rights reserved.
//

#import "ZKJTabBar.h"
#import "ZKJPublishVC.h"

@interface ZKJTabBar ()

/** 发布按钮 */
@property(nonatomic,weak) UIButton *publishBtn;

@end

@implementation ZKJTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        [publishBtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishBtn];
        self.publishBtn = publishBtn;
    }
    return self;
}

- (void)publishBtnClick
{
    ZKJPublishVC *vc = [[ZKJPublishVC alloc] init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 标记按钮是否已经添加过监听器
    static BOOL addTag = NO;
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    // 设置发布按钮的frame
    self.publishBtn.bounds = CGRectMake(0, 0, self.publishBtn.currentBackgroundImage.size.width, self.publishBtn.currentBackgroundImage.size.height);
    self.publishBtn.center = CGPointMake(width * 0.5, height * 0.5);
    
    // 设置其他UITabBarButton的frame
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = width / 5;
    CGFloat H = height;
    NSInteger index = 0;
    for (UIControl *btn in self.subviews) {
        if (![btn isKindOfClass:[UIControl class]] || btn == self.publishBtn) continue;
        
        // 计算按钮的x值
        X = W * ((index > 1) ? (index + 1) : index);
        btn.frame = CGRectMake(X, Y, W, H);
        
        // 增加索引
        index++;
        
        if (addTag == NO) {
            // 监听按钮点击
            [btn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    addTag = YES;
}

- (void)addClick
{
    [ZKJDefaultCenter postNotificationName:ZKJTabBarDidSelectNotification object:nil userInfo:nil];
}

@end
