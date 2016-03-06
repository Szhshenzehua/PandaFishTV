//
//  GuanZhuViewController.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/3/5.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "GuanZhuViewController.h"
#import <UIImageView+WebCache.h>
#import "DBManager.h"
#import "ShouCangModel.h"
#import "ZHeaderHelp.h"
#import "PlayViewController.h"
#import "GuanZhuaTableViewCell.h"
#import "NewLeftViewController.h"
#import "JHRefresh.h"
#import "PlayViewController.h"
#import "RoomKeyModel.h"
#import "VideoViewController.h"

@interface GuanZhuViewController ()
@property (nonatomic) BOOL isPullDown;


@end

@implementation GuanZhuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTableView];
    
    [self createPullRefresh];
    [self createMenuBtn];
    [self.tableView headerStartRefresh];
    
}

- (void)createPullRefresh {
    
    __weak  GuanZhuViewController  *weakSelf = self;
    
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


- (void)createWaterRecon {
    
    CATransition *trasition = [CATransition animation];
    trasition.duration = 1;
    [trasition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    trasition.type = @"rippleEffect";
    [self.navigationController.view.layer addAnimation:trasition forKey:@"animation"];
    
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

    self.dataSource = [NSMutableArray new];
    
    self.dataSource = (NSMutableArray *) [[DBManager sharedManager] readAllModelsWithFenShu];
    
    [self endRedresh];
    [self.tableView reloadData];

}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:KWindowBounds style:(UITableViewStylePlain)];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GuanZhuaTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ShouCangModel *model = self.dataSource[indexPath.row];
    
    NSString *roomkey = model.roomKey;
    NSString * url = [NSString stringWithFormat:PlayVideoAPI,roomkey];
    
    VideoViewController *vc = [VideoViewController new];
    vc.videoUrl = [NSURL URLWithString:url];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GuanZhuaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    ShouCangModel *model = self.dataSource[indexPath.row];
    cell.showsReorderControl =YES;
    cell.nameLabel.text = model.name;
    cell.pinFenLabel.text = model.pinFen;
    NSLog(@"%@",model.pinFen);
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageURl]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 100;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"点击了删除");
    ShouCangModel *model = self.dataSource[indexPath.row];
    [[DBManager sharedManager] deleteValueWithRoomId:model.roomID];
    
    [self loadDataSource];
    [tableView setEditing:NO animated:YES];
}

//以下方法可以不是必须要实现，添加如下方法可实现特定效果：

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//实现Cell可上下移动，调换位置，需要实现UiTableViewDelegate中如下方法：

//先设置Cell可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//当两个Cell对换位置后
- (void)tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath*)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    NSLog(@"点击了删除");
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//在下面方法中添加 cell.showsReorderControl =YES;
//使Cell显示移动按钮




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
