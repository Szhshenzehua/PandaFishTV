//
//  MaintableTableViewCell.h
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/28.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomKeyModel.h"
#import "SIxPlepleModel.h"

@protocol MaintableTableViewCellDelegete <NSObject>

- (void)playVideo:(RoomKeyModel *)roomUrl andRoomId:(NSString *)roomId andRoomImage:(NSString *)roomImage;

@end

@interface MaintableTableViewCell : UITableViewCell<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong)  UICollectionView *myCollectionView;

@property (nonatomic, strong) NSMutableArray *urlWithRoomKeySource;

@property (nonatomic, strong) id<MaintableTableViewCellDelegete>delegate;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) RoomKeyModel *roomKeyModel;

@property (nonatomic, strong) Videoinfo *videoInfoModel;


- (void)config:(SIxPlepleModel *)model1 and:(SIxPlepleModel *)model2;



@end
