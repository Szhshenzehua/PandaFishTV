//
//  ForWeViewController.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/28.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "ForWeViewController.h"
#import "MMParallaxPresenter.h"
#import "PageViewController.h"
#import "MMParallaxPage.h"
@interface ForWeViewController ()
@property (weak, nonatomic) IBOutlet MMParallaxPresenter *mmParallaxPresenter;

@end

@implementation ForWeViewController

- (IBAction)bacxk:(id)sender {
    
    
    [self.mmParallaxPresenter reset];
    
    MMParallaxPage *page1 = [[MMParallaxPage alloc] initWithScrollFrame:self.mmParallaxPresenter.frame withHeaderHeight:150 andContentText:[self sampleText1]];
    [page1.headerLabel setText:@"Section 4"];
    [page1.headerView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forest.jpg"]]];
    
    MMParallaxPage *page2 = [[MMParallaxPage alloc] initWithScrollFrame:self.mmParallaxPresenter.frame withHeaderHeight:150 withContentText:[self sampleText2] andContextImage:[UIImage imageNamed:@"icon.png"]];
    [page2.headerLabel setText:@"Section 35"];
    [page2.headerView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mountains.jpg"]]];
    
    [self.mmParallaxPresenter addParallaxPageArray:@[page1, page2]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // self.navigationController.navigationBarHidden = YES;
    
    [self.mmParallaxPresenter setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    
    PageViewController *pageThreeViewController = [[PageViewController alloc] initWithNibName:@"PageViewController" bundle:nil];
    
    MMParallaxPage *page1 = [[MMParallaxPage alloc] initWithScrollFrame:self.mmParallaxPresenter.frame withHeaderHeight:150 andContentText:[self sampleText1]];
    [page1.headerLabel setText:@"感谢"];
    [page1.headerView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stars.jpeg"]]];
    
    MMParallaxPage *page2 = [[MMParallaxPage alloc] initWithScrollFrame:self.mmParallaxPresenter.frame withHeaderHeight:150 withContentText:[self sampleText2] andContextImage:[UIImage imageNamed:@"icon.png"]];
    [page2.headerLabel setText:@"使用窍门"];
    [page2.headerView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mountains.jpg"]]];
    
    MMParallaxPage *page3 = [[MMParallaxPage alloc] initWithScrollFrame:self.mmParallaxPresenter.frame withHeaderHeight:150 andContentView:pageThreeViewController.view];
    [page3.headerLabel setText:@"关于我们"];
    [page3 setTitleAlignment:MMParallaxPageTitleBottomLeftAlignment];
    [page3.headerView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dock.jpg"]]];
    
    [self.mmParallaxPresenter addParallaxPageArray:@[page1, page2, page3]];
    
    
}

- (NSString *)sampleText1 {
    return @"我们的APP是一个致力于让大家能都得到优秀的观看效果而创建的。不需要登录就可以实现，超清的观影体验";
}


- (NSString *)sampleText2 {

return @"我们的APP是一个致力于让大家能都得到优秀的观看效果而创建的。不需要登录就可以实现，超清的观影体验我们的APP是一个致力于让大家能都得到优秀的观看效果而创建的。不需要登录就可以实现，超清的观影体验我们的APP是一个致力于让大家能都得到优秀的观看效果而创建的。不需要登录就可以实现，超清的观影体验";
}

- (NSString *)sampleText3 {

return @"我们的APP是一个致力于让大家能都得到优秀的观看效果而创建的。不需要登录就可以实现，超清的观影体验我们的APP是一个致力于让大家能都得到优秀的观看效果而创建的。不需要登录就可以实现，超清的观影体验我们的APP是一个致力于让大家能都得到优秀的观看效果而创建的。不需要登录就可以实现，超清的观影体验";
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
