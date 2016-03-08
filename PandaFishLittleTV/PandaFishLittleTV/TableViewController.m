//
//  TableViewController.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/24.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "TableViewController.h"

@implementation TableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 标题，正常状态的图片，选中状态的图片
    
//    self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self createTableView];
}

//- (void)createTableView {
//
//    _tableView = [[UITableView alloc] initWithFrame:KWindowBounds style:(UITableViewStylePlain)];
//    
//    _tableView.delegate = self;
//    
//    _tableView.dataSource = self;
//    [self.view addSubview:_tableView];
//
//
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    return self.dataSource.count;
//
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
//    
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cellID"];
//    }
//
//    return cell;
//}


- (void)viewDidAppear:(BOOL)animated {


}

- (void)viewWillAppear:(BOOL)animated {

    [self.navigationController setNavigationBarHidden:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
