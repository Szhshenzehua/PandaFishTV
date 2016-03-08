//
//  FenLeiViewController.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/24.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "FenLeiViewController.h"
#import "FenLeiSubViewController.h"
#import <AFNetworking.h>
#import "GameFenLeiModel.h"
#import "FenLeiCollectionViewCell.h"

@interface FenLeiViewController ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation FenLeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 标题，正常状态的图片，选中状态的图片
    // 注册 cell
    
    [self.collectionViewCell registerNib:[UINib nibWithNibName:@"FenLeiCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FenLeiCollectionViewCellID"];
    
   // self.dataSource = [NSMutableArray new];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"分类";
    [self createBGImage];
}

- (void)createBGImage {
//
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    UIImage *iamge = [UIImage imageNamed:@"IMG_1.JPG"];
//    imageView.image = iamge;
//    self.collectionViewCell.backgroundView = imageView;
    
    self.collectionViewCell.backgroundColor = [UIColor whiteColor];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    FenLeiSubViewController *vc = [FenLeiSubViewController new];

    [self createWaterRecon];
    
    GameData * model = self.dataSource[indexPath.row];
    
    vc.gameName = model.ename;
    vc.cnGamename = model.cname;
    
    // 进去时 隐藏tabbar  出来的时候 显示
    vc.hidesBottomBarWhenPushed = YES;
    

    [self.navigationController pushViewController:vc animated:YES];

}

- (NSInteger)SublayoutNum {

    return 3;
}

- (void)createWaterRecon {
    [super createWaterRecon];
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
    NSString * url = [NSString stringWithFormat:GameAPI,timeString];
    
   // NSLog(@"游戏分类的网址是%@",url);
    
    [_manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        if (self.isPullDown) {
            
            self.dataSource = [NSMutableArray new];
            GameFenLeiModel *model = [[GameFenLeiModel alloc] initWithDictionary:responseObject error:nil];
            self.dataSource = (NSMutableArray *)model.data;
        }
        
        [self.collectionViewCell reloadData];
        
        [self endRedresh];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"推荐主播错误是%@",error);
    }];
}

- (void)createLoadMoreRefresh {


}

- (void)endRedresh {

    [super endRedresh];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

   FenLeiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FenLeiCollectionViewCellID" forIndexPath:indexPath];
    GameData *model = self.dataSource[indexPath.row];

    [cell config:model];
    
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
