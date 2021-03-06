//
//  UIView+ZKJExtension.h
//  百思不得姐
//
//  Created by ZKJ on 2017/2/21.
//  Copyright © 2017年 ZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZKJExtension)

/** X */
@property(nonatomic,assign) CGFloat x;
/** Y */
@property(nonatomic,assign) CGFloat y;
/** W */
@property(nonatomic,assign) CGFloat width;
/** H */
@property(nonatomic,assign) CGFloat height;
/** size */
@property(nonatomic,assign) CGSize size;
/** centerX */
@property(nonatomic,assign) CGFloat centerX;
/** centerY */
@property(nonatomic,assign) CGFloat centerY;

/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;

//- (CGFloat)x;
//- (void)setX:(CGFloat)x;
/** 在分类中声明@property, 只会生成方法的声明, 不会生成方法的实现和带有_下划线的成员变量 */

+ (instancetype)viewFromXib;

@end
