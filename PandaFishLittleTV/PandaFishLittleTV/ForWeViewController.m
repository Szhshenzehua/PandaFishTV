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
    [page1.headerView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stars"]]];
    
    MMParallaxPage *page2 = [[MMParallaxPage alloc] initWithScrollFrame:self.mmParallaxPresenter.frame withHeaderHeight:150 withContentText:[self sampleText2] andContextImage:[UIImage imageNamed:@"icon111.png"]];
    [page2.headerLabel setText:@"使用窍门"];
    [page2.headerView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mountains"]]];
    
    MMParallaxPage *page3 = [[MMParallaxPage alloc] initWithScrollFrame:self.mmParallaxPresenter.frame withHeaderHeight:150 andContentView:pageThreeViewController.view];
    [page3.headerLabel setText:@"关于我们"];
    [page3 setTitleAlignment:MMParallaxPageTitleBottomLeftAlignment];
    [page3.headerView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dock"]]];
    
    [self.mmParallaxPresenter addParallaxPageArray:@[page1, page2, page3]];
    
    
}

- (NSString *)sampleText1 {
    return @"我们的APP是一个致力于让大家能都得到优秀的观看效果而创建的。不需要登录就可以实现，超清的观影体验。在编写APP过程中,感谢github以及开源中国上的一些开源的第三方库,以及一些码友们开源的Demo。当然,这个APP也马上就会上传,希望能够帮助一些新手,或者能够给您在创造神奇的过程中提供一点灵感!!!";
}


- (NSString *)sampleText2 {

return @"对于首页中得轮播视图,您可以左右滑动来选择下一页或者上一页。在进入房间以后,您如果喜欢这个房间,可以点亮星星,这样的话,您只要在'我的收藏'中下来刷新一下就可以找到您关注的房价了。并且我们在点亮星星的同时，还能够依据自己的喜爱程度,对这个房间进行评价,您只需要轻轻滑动爱心就可以进行打分了。收藏房间的分数是从0~~9.99,不要问我为什么满分不是10分,您觉得我会说,少0.01是怕他们骄傲吗？O(∩_∩)O~~~";
}

- (NSString *)sampleText3 {

return @"";
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
