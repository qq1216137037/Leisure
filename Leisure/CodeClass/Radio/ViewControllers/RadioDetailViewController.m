//
//  RadioDetailViewController.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "RadioDetailViewController.h"
#import "RadioDetailListModel.h"
#import "RadioDetailListModelCell.h"
#import "RadioDetailListHeaderView.h"
#import "RadioCarouselModel.h"

#define kLIMIT 10

@interface RadioDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger start;

@property (nonatomic, strong) NSMutableArray *detailListArray;

@end

@implementation RadioDetailViewController

- (NSMutableArray *)detailListArray
{
    if (!_detailListArray) {
        self.detailListArray = [NSMutableArray array];
    }
    return _detailListArray;
}

// 上拉刷新请求
- (void)requestRefreshData {
    _start += kLIMIT;
    [NetWorkrequestManage requestWithType:POST url:RADIODETAILMORE_URL parameters:@{ @"radioid" : _radioModel.radioid, @"start" : @(_start), @"limit" : @(kLIMIT)} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        
        
        // 获取所有电台列表数据
        NSArray *allListArr = dataDic[@"data"][@"list"];
        for (NSDictionary *allList in allListArr) {
            RadioDetailListModel *listModel = [[RadioDetailListModel alloc] init];
            
            [listModel setValuesForKeysWithDictionary:allList];
            
            [self.detailListArray addObject:listModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if (allListArr.count != kLIMIT) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        });
    } error:^(NSError *error) {
        
    }];
}

- (void) requestData {
    [self.detailListArray removeAllObjects];
    [NetWorkrequestManage requestWithType:POST url:RADIODETAILLIST_URL parameters:@{@"radioid" : _radioModel.radioid} finish:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        //NSLog(@"%@", dataDic);
        
        NSURL *url = [NSURL URLWithString:dataDic[@"data"][@"radioInfo"][@"coverimg"]];
        [_headerImageView sd_setImageWithURL:url];
        
        NSArray *listArray = dataDic[@"data"][@"list"];
        for (NSDictionary *modelDic in listArray) {
            RadioDetailListModel *model = [[RadioDetailListModel alloc] init];
            [model setValuesForKeysWithDictionary:modelDic];
            [self.detailListArray addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
        
    } error:^(NSError *error) {
        NSLog(@"出错");
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createHeaderImageView];
    
    [self createTableView];
    
    [self requestData];
}

- (void)createHeaderImageView
{
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
    [self.view addSubview:_headerImageView];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 180, ScreenWidth, ScreenHeight - 264) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestRefreshData)];
    
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RadioDetailListModelCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RadioDetailListModel class])];
    
    [self.view addSubview:_tableView];
}

#pragma mark - Table View Delegate & DataSouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RadioDetailListHeaderView" owner:nil options:nil];
    RadioDetailListHeaderView *view = [arr lastObject];
    [view setData:self.radioModel];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseModel *model = self.detailListArray[indexPath.row];
    BaseTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RadioDetailListModel class]) forIndexPath:indexPath];
    
    [cell setData:model];

    return cell;
}

@end