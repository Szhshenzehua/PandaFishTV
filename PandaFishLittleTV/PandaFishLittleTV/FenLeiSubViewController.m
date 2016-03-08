//
//  FenLeiSubViewController.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/29.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "FenLeiSubViewController.h"
#import "MainCollectionViewCell.h"
#import "PlayViewController.h"
#import <AFNetworking.h>
#import "SubGameModel.h"
#import "PlayViewController.h"
#import <UIImageView+WebCache.h>
#import "SubGameCollectionViewCell.h"
#import "ShouCangModel.h"


@interface FenLeiSubViewController ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation FenLeiSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 在子类中加载更多的时候 。在loadDataSource 中不能初始化self.dataSource
    self.dataSource = [NSMutableArray new];
    [self createBGImage];
    self.title = _cnGamename;
    self.collectionViewCell.backgroundColor = [UIColor whiteColor];
    [self.collectionViewCell registerNib:[UINib nibWithNibName:@"SubGameCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SubGameCollectionViewCellCellID"];
    
}
- (void)createBGImage {
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    UIImage *iamge = [UIImage imageNamed:@"IMG_0.JPG"];
//    imageView.image = iamge;
//    self.collectionViewCell.backgroundView = imageView;
}
- (void)createMenuBtn {


    
}
- (void)endRedresh {
    
    [super endRedresh];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    [self createWaterRecon];

    subGameItems *model = self.dataSource[indexPath.row];
    
    PlayViewController * vc = [PlayViewController new];

    NSString * videoURl = [NSString stringWithFormat:PlayVideoAPI,model.room_key];
    
    vc.playURL = videoURl;
    
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

- (NSInteger)SublayoutNum {
    
    return 2;
}
- (void)initData {
    
    self.page = 10;
    
}

- (int)pageChange {
    
    return 10;
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
    //记载的页数
    //int num = 1;
    NSString * url = [NSString stringWithFormat:SubGameAPI,_gameName,self.page];
    //NSLog(@"游戏分类的网址是%@",url);
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (self.isPullDown) {
    
            SubGameModel *model = [[SubGameModel alloc] initWithDictionary:responseObject error:nil];
            self.dataSource = (NSMutableArray *)model.data.items;
        }
        
        if (self.isLoadMore) {
            
           self.dataSource = [NSMutableArray new];
            SubGameModel *model = [[SubGameModel alloc] initWithDictionary:responseObject error:nil];
            
            [self.dataSource addObjectsFromArray:(NSMutableArray *)model.data.items];
        }
        
      [self endRedresh];
      [self.collectionViewCell reloadData];
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"推荐主播错误是%@",error);
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SubGameCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SubGameCollectionViewCellCellID" forIndexPath:indexPath];

    subGameItems *model = self.dataSource[indexPath.row];
    
    if (!model) {
        return cell;
    }
    
    [cell.roomImage sd_setImageWithURL:[NSURL URLWithString:model.pictures.img] placeholderImage:[UIImage imageNamed:@"clean"]];
    
    cell.roomName.text = model.name;
    cell.preceName.text = model.userinfo.nickName;
    
   return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataSource.count ;
    
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
