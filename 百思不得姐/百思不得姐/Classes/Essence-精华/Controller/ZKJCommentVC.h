//
//  ZKJCommentVC.h
//  百思不得姐
//
//  Created by ZKJ on 2017/3/27.
//  Copyright © 2017年 ZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKJTopic;
@interface ZKJCommentVC : UIViewController

/** 帖子的数据模型 */
@property (nonatomic, strong) ZKJTopic *topic;

@end
