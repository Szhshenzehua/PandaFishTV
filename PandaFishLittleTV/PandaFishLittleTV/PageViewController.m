//
//  PageViewController.m
//  MMParallaxScrollPresenter
//
//  Created by Malleo, Mitch on 12/19/14.
//

#import "PageViewController.h"
#import "NewLeftViewController.h"
@interface PageViewController ()

@property (weak, nonatomic) IBOutlet UITextView *myText;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _myText.text = [self backNsString];
    
    _myText.backgroundColor = [UIColor clearColor];
    
    _myText.userInteractionEnabled = NO;
    
}

- (NSString *)backNsString {
    
    return @"  121111077,非常感谢你对这款APP的喜爱,如果你在使用的过程中遇到的一些问题,或者您对这款APP有更好的建议。您都可以向我发送邮件,收到邮件以后,我会尽快的为你解答疑问。或者在接下来的一段时间里采纳一些好的建议,对这款APP进行升级。让我们一起努力让这款APP更加强壮!!! 我的邮箱是:zehua2016@gmail.com";
    
}


- (IBAction)Back:(id)sender {
    
    
    NewLeftViewController * vc = [NewLeftViewController new];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
