//
//  AppViewController.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/24.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "AppViewController.h"
#import "AppDelegate.h"
#import "NewLeftViewController.h"
 
@interface AppViewController ()

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
    [self createMenuBtn];

    [self createCollectionView];
    
    [self createPullRefresh];
    [self createLoadMoreRefresh];
    
    // 下拉刷新
    
    [self.collectionViewCell headerStartRefresh];
   // [self loadDataSource];
    
}
/**
 *  需要在子类中重写
 */
- (void)loadDataSource {

}

/**
 *  添加下拉更新和上拉加载更多。。 对于有的页面主页，分类 以及收藏页面是不需要添加 上拉加载更多。 怎在子类中重写一下
 */

- (void)createPullRefresh {

    __weak  AppViewController  *weakSelf = self;

    [self.collectionViewCell addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        
        _isPullDown = YES;
        
        [weakSelf initData];
        
        [weakSelf loadDataSource];
        
    }];
}

- (int)pageChange {


    return 10;
}

- (void)createLoadMoreRefresh {

    __weak AppViewController *weakSelf = self;
    
    [self.collectionViewCell addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        weakSelf.isLoadMore = YES;
        weakSelf.page += [weakSelf pageChange];
        [weakSelf loadDataSource];
    
    }];
}

- (void)initData {

    self.page = 10;

}

/**
 *  结束刷新
 */
- (void)endRedresh {
    
    if (_isPullDown) {
        // 结束刷新
        _isPullDown = NO;
        [self.collectionViewCell headerEndRefreshingWithResult:(JHRefreshResultSuccess)];
    }
    if (_isLoadMore) {
        // 结束上拉加载
        _isLoadMore = NO;
        [self.collectionViewCell footerEndRefreshing];
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
/**
 *  每个子页面的横向的个数
 *
 *  @return 子类必须返回
 */
- (NSInteger)SublayoutNum {


    return 10;
}

- (void)createCollectionView {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1.0;
    
    layout.minimumInteritemSpacing = 1.0;
    
    //附加头视图 大小 水平滚动 宽度有效，高度无效
    layout.headerReferenceSize = CGSizeMake(0, 0);
    //附加尾视图 大小 垂直滚动 高度有效，宽度无效
    layout.footerReferenceSize = CGSizeMake(0, 0);
    // 
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    NSInteger num = [self SublayoutNum];
    
    
    layout.itemSize = CGSizeMake( (kWindowWidth - 30) / num , ((kWindowWidth - 30) / 2) * 6 / 5);
    
    if (num == 2) {
        layout.itemSize = CGSizeMake((kWindowWidth - 20) / 2  , ((kWindowWidth - 50) / 2 ) );
        
    }
    
    _collectionViewCell = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height) collectionViewLayout:layout];

    _collectionViewCell.delegate = self;
    _collectionViewCell.dataSource = self;
    _collectionViewCell.pagingEnabled = YES;
        
    [self.view addSubview:_collectionViewCell];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {


    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
