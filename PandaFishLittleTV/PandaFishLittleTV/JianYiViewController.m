//
//  JianYiViewController.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/3/7.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "JianYiViewController.h"

@interface JianYiViewController ()
@property (weak, nonatomic) IBOutlet UILabel *myLabel;

@property (weak, nonatomic) IBOutlet UITextView *myText;



@end

@implementation JianYiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _myText.text = [self backNsString];
    
    _myText.backgroundColor = [UIColor clearColor];
    
    _myText.userInteractionEnabled = NO;
    
}

- (NSString *)backNsString {

return @"  非常感谢你对这款APP的喜爱,如果你在使用的过程中遇到的一些问题,或者您对这款APP有更好的建议。您都可以向我发送邮件,收到邮件以后,我会尽快的为你解答疑问。或者在接下来的一段时间里采纳一些好的建议,对这款APP进行升级。让我们一起努力让这款APP更加强壮!!! 我的邮箱是:zehua2016@gmail.com";

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
