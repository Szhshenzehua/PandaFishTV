//
//  GuanZhuViewController.h
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/3/5.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuanZhuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end
