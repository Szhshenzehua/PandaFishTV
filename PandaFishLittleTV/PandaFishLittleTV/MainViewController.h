//
//  MainViewController.h
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/24.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "TableViewController.h"
#import "MaintableTableViewCell.h"
@interface MainViewController : TableViewController<UITableViewDelegate,UITableViewDataSource,MaintableTableViewCellDelegete>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;




@end
