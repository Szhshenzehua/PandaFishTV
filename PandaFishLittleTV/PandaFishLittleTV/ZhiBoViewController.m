//
//  ZhiBoViewController.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/24.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "ZhiBoViewController.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "SubGameCollectionViewCell.h"
#import "ZHeaderHelp.h"
#import "AllLiveModel.h"
#import "PlayViewController.h"
#import "ShouCangModel.h"
@interface ZhiBoViewController ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation ZhiBoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [NSMutableArray new];
    // 标题，正常状态的图片，选中状态的图片
    self.collectionViewCell.backgroundColor = [UIColor whiteColor];
    self.title = @"直播";
    
    [self.collectionViewCell registerNib:[UINib nibWithNibName:@"SubGameCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SubGameCollectionViewCellCellID"];
    //[self creaeteView];
}

- (void)creaeteView {

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_2.JPG"]];

    imageView.frame = self.view.frame;
    self.collectionViewCell.backgroundView = imageView;

}
- (NSInteger)SublayoutNum {
    
    return 2;
}
- (void)initData {
    
    self.page = 1;
    
}

- (int)pageChange {
    
    return 1;
}

- (void)createWaterRecon {
    [super createWaterRecon];
}


- (void)loadDataSource {
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //增加新的类型text/html
    NSSet *currentAcceptSet = _manager.responseSerializer.acceptableContentTypes;
    NSMutableSet *mset = [NSMutableSet setWithSet:currentAcceptSet];
    [mset addObject:@"text/html"];
    [mset addObject:@"application/json"];
    self.manager.responseSerializer.acceptableContentTypes = mset;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970] * 1000.0000;
    
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    NSString * url = [NSString stringWithFormat:AllLiveAPI,self.page,timeString];
   // NSLog(@"全部直播的网址是%@",url);
    
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // NSLog(@"%@",responseObject);
        AllLiveModel *model = [[AllLiveModel alloc] initWithDictionary:responseObject error:nil];

        if (self.isPullDown) {
             self.dataSource = (NSMutableArray *)model.data.items;
        }
        if (self.isLoadMore) {
            [self.dataSource addObjectsFromArray:model.data.items];
        }

        [self.collectionViewCell reloadData];
        [self endRedresh];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"推荐主播错误是%@",error);
    }];
}


- (void)endRedresh {

    [super endRedresh];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    SubGameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SubGameCollectionViewCellCellID" forIndexPath:indexPath];
    AllLiveItems *model = self.dataSource[indexPath.row];
    cell.roomName.text = model.name;
    cell.preceName.text = model.userinfo.nickName;

  //  NSLog(@"%@",cell.roomName.text);
    
    [cell.roomImage sd_setImageWithURL:[NSURL URLWithString:model.pictures.img] placeholderImage:[UIImage imageNamed:@"clean"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self createWaterRecon];
    
    PlayViewController * vc = [PlayViewController new];
    
    AllLiveItems * model = self.dataSource[indexPath.row];

    NSString *playUrl = [NSString stringWithFormat:PlayVideoAPI,model.room_key];
    
    vc.playURL = playUrl;
    
    vc.roomID = model.id;
    vc.roomKey = model.room_key;
    vc.roomImageURl = model.pictures.img;
    vc.imageURl = model.userinfo.avatar;
    vc.name = model.name;
    vc.xiangqing = model.banned_reason;
    // 进去时 隐藏tabbar  出来的时候 显示
    vc.hidesBottomBarWhenPushed = YES;
    

    [self.navigationController pushViewController:vc animated:YES];
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
