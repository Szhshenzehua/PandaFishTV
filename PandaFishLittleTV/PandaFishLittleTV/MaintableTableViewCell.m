//
//  MaintableTableViewCell.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/28.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "MaintableTableViewCell.h"
#import "ZHeaderHelp.h"
#import <AFNetworking.h>
#import "MainCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@implementation MaintableTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}


- (void)createView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 3.0;
    layout.minimumInteritemSpacing = 3.0;
    
    //附加头视图 大小 水平滚动 宽度有效，高度无效
    layout.headerReferenceSize = CGSizeMake(0, 0);
    //附加尾视图 大小 垂直滚动 高度有效，宽度无效
    layout.footerReferenceSize = CGSizeMake(0, 0);
    
    //kWindowWidth / 2 - 10
    
    layout.itemSize = CGSizeMake(kWindowWidth / 2  , (kWindowHeight - 44)/ 4);
    //设置水平滚动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, (kWindowHeight - 44)/ 4) collectionViewLayout:layout];    //
    //    [_collectionView registerClass:[subCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    
    [_myCollectionView  registerNib:[UINib nibWithNibName:@"MainCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MainCollectionViewCellID"];
    
    _myCollectionView.delegate = self;
   _myCollectionView.dataSource = self;
    _myCollectionView.pagingEnabled = YES;
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    UIImage *iamge = [UIImage imageNamed:@"bg"];
//    
//    imageView.image = iamge;
//    
//    _myCollectionView.backgroundView = imageView;
//    
    [self.contentView addSubview:_myCollectionView];
}

- (void)loadDadaSourceand:(NSString *)roomID and:(NSString *)roomImage {
    
    //    SIxPlepleModel * model = self.dataSource[indexPath.row];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970] * 1000.0000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    NSString *playURL = [NSString stringWithFormat:RoomIDKeyAPI,roomID,timeString];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //增加新的类型text/html
    NSSet *currentAcceptSet = manager.responseSerializer.acceptableContentTypes;
    NSMutableSet *mset = [NSMutableSet setWithSet:currentAcceptSet];
    [mset addObject:@"text/html"];
    [mset addObject:@"application/json"];
    
    manager.responseSerializer.acceptableContentTypes = mset;
    
    NSString *url = playURL;
    
    self.urlWithRoomKeySource = [NSMutableArray new];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        RoomKeyModel *model = [[RoomKeyModel alloc] initWithDictionary:responseObject error:nil];
        if (_delegate && [_delegate respondsToSelector:@selector(playVideo:andRoomId:andRoomImage:)]) {
            
            [_delegate playVideo:model andRoomId:roomID andRoomImage:roomImage];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       // NSLog(@"视频播放的地址%@",error);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 2;
    
}

- (void)config:(SIxPlepleModel *)model1 and:(SIxPlepleModel *)model2 {
    
    [_myCollectionView removeFromSuperview];
    
    [self createView];
    _myCollectionView.backgroundView = nil;
    
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.dataSource = [NSMutableArray new];
    [self.dataSource addObject:model1];
    [self.dataSource addObject:model2];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainCollectionViewCellID" forIndexPath:indexPath];
    
    SIxPlepleModel *model = self.dataSource[indexPath.row];
    
    [cell.roomImageVIew sd_setImageWithURL:[NSURL URLWithString:model.bigimg] placeholderImage:[UIImage imageNamed:@"clean"]];
    
    cell.roomName.text = model.name;
    cell.persenName.text = model.nickname;
    //NSLog(@"%@",cell.persenName.text);
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    
    
    SIxPlepleModel * model = self.dataSource[indexPath.row];
    // 点击 ，调用获得roomKey的方法
    [self loadDadaSourceand:model.roomid and:model.bigimg];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
