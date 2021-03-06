//
//  ZKJTopicViewController.m
//  百思不得姐
//
//  Created by JM on 16/3/16.
//  Copyright © 2017年 ZKJ. All rights reserved.
//

#import "ZKJTopicViewController.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MJExtension.h>
#import <MJRefresh.h>
#import "ZKJTopic.h"
#import "ZKJTopicCell.h"
#import "ZKJCommentVC.h"
#import "ZKJNewController.h"

@interface ZKJTopicViewController ()

/** 帖子数据 */
@property(nonatomic,strong) NSMutableArray *topicArr;
/** maxtime */
@property(nonatomic,copy) NSString *maxtime;
/** 当前的页码 */
@property(nonatomic,assign) NSInteger page;
/** 上次请求的参数 */
@property(nonatomic,strong) NSDictionary *parameters;
/** 上次选中的索引(或者控制器) */
@property (nonatomic, assign) NSInteger lastSelIndex;

@end

@implementation ZKJTopicViewController

- (NSMutableArray *)topicArr
{
    if (!_topicArr) {
        _topicArr = [NSMutableArray array];
    }
    return _topicArr;
}

static NSString * const cellName = @"topic";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化tableView
    [self setUpTableView];
    
    // 添加刷新控件
    [self setupRefresh];
}

// 初始化tableView
- (void)setUpTableView
{
    // 设置内边距
    CGFloat top = ZKJTitilesViewY + ZKJTitilesViewH;
    CGFloat bottom = self.tabBarController.tabBar.height;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZKJTopicCell class]) bundle:nil] forCellReuseIdentifier:cellName];
    [ZKJDefaultCenter addObserver:self selector:@selector(tabBarSelect) name:ZKJTabBarDidSelectNotification object:nil];
}

- (void)tabBarSelect
{
    // 如果是连续选中2次, 直接刷新
    if (self.lastSelIndex == self.tabBarController.selectedIndex && self.view.isShowingOnKeyWindow) {
        [self.tableView.mj_header beginRefreshing];
    }
    
    // 记录这一次选中的索引
    self.lastSelIndex = self.tabBarController.selectedIndex;
}

/** 添加刷新控件 */
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - a参数
- (NSString *)a
{
    return [self.parentViewController isKindOfClass:[ZKJNewController class]] ? @"newlist" : @"list";
}

#pragma mark - 下拉刷新
- (void)loadNewData
{
    [self.tableView.mj_footer endRefreshing];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = self.a;
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    self.parameters = parameters;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        if (self.parameters != parameters) return ;
        
        ZKJLog(@"%@", responseObject);
        
        self.topicArr = [ZKJTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
        self.page = 0;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.parameters != parameters) return ;
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 上拉加载更多
- (void)loadMoreData
{
    [self.tableView.mj_header endRefreshing];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = self.a;
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    parameters[@"maxtime"] = self.maxtime;
    NSInteger page = self.page + 1;
    parameters[@"page"] = @(page);
    self.parameters = parameters;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        if (self.parameters != parameters) return ;
        
        ZKJLog(@"%@", responseObject);
        
        NSArray *newTopic = [ZKJTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        [self.topicArr addObjectsFromArray:newTopic];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        
        // 设置页码
        self.page = page;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (self.parameters != parameters) return ;
        
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKJTopic *topic = self.topicArr[indexPath.row];
    return topic.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.topicArr.count == 0);
    return self.topicArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ZKJTopic *topic = self.topicArr[indexPath.row];
//    if (topic.type == ZKJTopicTypePicture) {
//        ZKJLog(@"%@", [topic.big_image pathExtension].lowercaseString);
//        ZKJLog(@"%zd", topic.isBigPicture);
//        ZKJLog(@"%f", topic.height);
//    }
    ZKJTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    cell.topic = self.topicArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZKJCommentVC *vc = [[ZKJCommentVC alloc] init];
    vc.topic = self.topicArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
