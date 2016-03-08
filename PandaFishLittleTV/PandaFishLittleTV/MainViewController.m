//
//  MainViewController.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/24.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "MainViewController.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "PlayViewController.h"
#import "AppDelegate.h"
#import "ZHDiffView.h"
#import "NewLeftViewController.h"
#import "ZHeaderHelp.h"
#import "HeadImageArrayModel.h"
#import "SIxPlepleModel.h"
#import "RoomKeyModel.h"
#import "MaintableTableViewCell.h"
#import "UITableViewCell+DisplayAnimation.h"
#import "ShouCangModel.h"
#import "JHRefresh.h"

//#import "VideoViewController.h"


@interface MainViewController ()<MaintableTableViewCellDelegete>

@property (nonatomic, strong) NSMutableArray *sixtenPlepeo;

@property (nonatomic, strong) NSMutableArray *urlWithRoomKeySource;

@property (nonatomic, strong) RoomKeyModel *roomKeyModel;

@property (nonatomic, strong) Videoinfo *videoInfoModel;

@property (nonatomic, strong)  AFHTTPSessionManager *manager;

@property (nonatomic) BOOL isPullDown;

@end

@implementation MainViewController




- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray new];
    self.sixtenPlepeo = [NSMutableArray new];
    
    self.navigationItem.title = @"热门";
    
    [self createTableView];

    [self createPullRefresh];
    
    [self.tableView headerStartRefresh];
    
    [self createMenuBtn];
    
   // self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
}


- (void)createPullRefresh {
    
    __weak  MainViewController  *weakSelf = self;
    
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        _isPullDown = YES;
        [weakSelf loadDataSource];
        
    }];
}
/**
 *  结束刷新
 */
- (void)endRedresh {
    
    if (_isPullDown) {
        // 结束刷新
        _isPullDown = NO;
        [self.tableView headerEndRefreshingWithResult:(JHRefreshResultSuccess)];
    }
}

- (void)createMenuBtn {
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"nav_menu_icon"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    self.navigationItem.leftBarButtonItem = releaseButtonItem;
}
- (void) openOrCloseLeftList
{
    NewLeftViewController *vc = [NewLeftViewController new];
    [self createWaterRecon];
    // 进去时 隐藏tabbar  出来的时候 显示
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)loadDataSource {

    _manager = [AFHTTPSessionManager manager];
    
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //增加新的类型text/html
    NSSet *currentAcceptSet = _manager.responseSerializer.acceptableContentTypes;
    NSMutableSet *mset = [NSMutableSet setWithSet:currentAcceptSet];
    [mset addObject:@"text/html"];
    [mset addObject:@"application/json"];
    
    _manager.responseSerializer.acceptableContentTypes = mset;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970] * 1000.0000;
    
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    //转为字符型
    NSString * url = [NSString stringWithFormat:PandaSlideAPI,timeString];
    
    [_manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (_isPullDown) {
            
            self.dataSource = [NSMutableArray new];
            self.dataSource = [HeadImageArrayModel arrayOfDictionariesFromModels:responseObject];
            
        }
        [self endRedresh];
        [self createHeadTableView];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"推荐主播错误是%@",error);
    }];
    
    NSString *sixPleplo = [NSString stringWithFormat:PandaRoomAPI,timeString];
    [_manager GET: sixPleplo parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        /**
         *  _isPullDown 在上面经历过刷新以后 值就变成了NO
         */
        
        if (!_isPullDown) {
            self.sixtenPlepeo = [NSMutableArray new];
            self.sixtenPlepeo = [SIxPlepleModel arrayOfDictionariesFromModels:responseObject];
        }
        
        [self endRedresh];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
         NSLog(@"16ren 错误是%@",error);
    }];
}


- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:KWindowBounds style:(UITableViewStylePlain)];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[MaintableTableViewCell class] forCellReuseIdentifier:@"CellID1"];
    
}

- (void)createHeadTableView {

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, (kWindowHeight - 44) / 2 )];
    ZHDiffView *ZHdiffView = [[ZHDiffView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth , (kWindowHeight - 44) / 2)];
    // 在加载网络图片的时候， 把images 添加 URL 。在 ZHdiffView  view1 sd_image
    NSMutableArray * imageUrl = [NSMutableArray new];
    
    for ( id item in self.dataSource ) {
        
        HeadImageArrayModel * model = item;
        
        [imageUrl addObject:model.bigimg];
    }
    
    ZHdiffView.images = imageUrl;
    
    ZHdiffView.backgroundColor=[UIColor clearColor];
    
    ZHdiffView.click = ^(int i) {
        
        NSLog(@"%d",i);
        // 根据 i 的值 将 url 传出 要注意的是 这里的 i 是从1 开始的
        
        // 这个判断，是因为发现进去页面以后，直接点击中间的那张，报数是 0 ,滑动一下在复位就变成3.最中间的那张
        int num;
        
        
        if (i == 0) {
             num = 2;
        }else {
             num = i - 1;
        }
        
        HeadImageArrayModel * roomModel = self.dataSource[num];
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a = [dat timeIntervalSince1970] * 1000.0000;
        NSString *timeString = [NSString stringWithFormat:@"%f", a];
        
        NSString *playURL = [NSString stringWithFormat:RoomIDKeyAPI,roomModel.roomid,timeString];
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        //增加新的类型text/html
        NSSet *currentAcceptSet = _manager.responseSerializer.acceptableContentTypes;
        NSMutableSet *mset = [NSMutableSet setWithSet:currentAcceptSet];
        [mset addObject:@"text/html"];
        [mset addObject:@"application/json"];
        
        _manager.responseSerializer.acceptableContentTypes = mset;
        NSString *url = playURL;
        
        self.urlWithRoomKeySource = [NSMutableArray new];
    
        [_manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            RoomKeyModel *model = [[RoomKeyModel alloc] initWithDictionary:responseObject error:nil];
        
            [self playVideo:model andRoomId:roomModel.roomid andRoomImage:imageUrl[num]];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"视频播放的地址%@",error);
         }];
};

    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:headView.frame];
    
    bgImageView.image = [UIImage imageNamed:@"stars4"];
    [headView addSubview:bgImageView];
    [headView addSubview:ZHdiffView];
    self.tableView.tableHeaderView = headView;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sixtenPlepeo.count / 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (kWindowHeight - 44) / 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MaintableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID1"];
    if (!cell) {
        cell = [[MaintableTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"CellID1"];
    }
    SIxPlepleModel *model1 = self.sixtenPlepeo[indexPath.row * 2];
    SIxPlepleModel *model2 = self.sixtenPlepeo[indexPath.row * 2 + 1];
    cell.delegate = self;
    [cell config:model1 and:model2];
    // 播放的特效
    [cell startCellScaleAnimation];
    
    return cell;
}

- (void)playVideo:(RoomKeyModel *)roomUrl andRoomId:(NSString *)roomId andRoomImage:(NSString *)roomImage {

    PlayViewController * vc = [PlayViewController new];
    
    [self createWaterRecon];
    // 进去时 隐藏tabbar  出来的时候 显示
    vc.hidesBottomBarWhenPushed = YES;
    RoomKeyModel *model = roomUrl;
  //  NSLog(@"%@",model);
    if(model.data.info.videoinfo.room_key) {
        
    NSString *str = [NSString stringWithString:model.data.info.videoinfo.room_key];
        
        NSString * videoURl = [NSString stringWithFormat:PlayVideoAPI,str];
        
        vc.playURL = videoURl;
        
        vc.roomKey = model.data.info.videoinfo.room_key;
        vc.roomID = roomId;
        vc.name = model.data.info.hostinfo.name;
        vc.roomImageURl = roomImage;
        vc.imageURl = model.data.info.hostinfo.avatar;
        vc.xiangqing = model.data.info.roominfo.bulletin;
       [self.navigationController pushViewController:vc animated:YES];
    }
}
/**
 *  水纹效果
 */
- (void)createWaterRecon {
    
    CATransition *trasition = [CATransition animation];
    trasition.duration = 1;
    [trasition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    trasition.type = @"rippleEffect";
    [self.navigationController.view.layer addAnimation:trasition forKey:@"animation"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
