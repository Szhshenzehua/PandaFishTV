//
//  AppViewController.h
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/24.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHeaderHelp.h"
#import  "JHRefresh.h"

@interface AppViewController : UIViewController <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic) BOOL isPullDown;

@property (nonatomic) BOOL isLoadMore;

@property (nonatomic, strong)UICollectionView *collectionViewCell;

@property (nonatomic,strong)NSMutableArray *dataSource;

@property (nonatomic) int page;

- (int)pageChange;
- (void)initData;

- (void)endRedresh;

- (void)createLoadMoreRefresh;

/**
 *  水纹效果
 */
- (void)createWaterRecon;


- (NSInteger)SublayoutNum;

/**
 *  需要在子类中重写
 */
- (void)loadDataSource;

@end
