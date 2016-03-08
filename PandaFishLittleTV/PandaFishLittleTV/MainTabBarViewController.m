//
//  MainTabBarViewController.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/24.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "MainViewController.h"
#import "FenLeiViewController.h"
#import "ZhiBoViewController.h"
#import "GuanZhuViewController.h"
#import "ZHeaderHelp.h"
#import "AppDelegate.h"


@implementation MainTabBarViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
    [self createViewController];

}

/**
 *   创建子视图控制器
 *
 *  @return <#return value description#>
 */


- (void)createViewController {
    
    NSMutableArray *viewControllers = [NSMutableArray new];
    
    NSArray *ClassName = @[@"MainViewController",@"FenLeiViewController",@"ZhiBoViewController",@"GuanZhuViewController"];
    NSArray *imageNameArr = @[@"tabbar1s",@"tabbar2s",@"tabbar4s",@"tabbar5s"];
    
    NSArray *imageHLNameArr = @[@"tabbar1",@"tabbar2",@"tabbar4",@"tabbar5"];

    // 标题名称
    NSArray *titleName = @[@"热门",@"分类",@"直播",@"我的收藏"];
    for (int i = 0; i < titleName.count; i++) {

        Class cla = NSClassFromString([NSString stringWithFormat:@"%@",ClassName[i]]);
        UIViewController *vc = [cla new];
        
        NSString *imageName = imageNameArr[i];
        NSString *imageHLName = imageHLNameArr[i];
        //设置图片的渲染模式为不渲染
        UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *imageHL = [[UIImage imageNamed:imageHLName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        // 标题，正常状态的图片，选中状态的图片
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:titleName[i] image:image selectedImage:imageHL];
        vc.tabBarItem = item;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];

        [viewControllers addObject:nav];
    }
    // 设置分栏控制器的子视图
    self.viewControllers = viewControllers;
}

@end
