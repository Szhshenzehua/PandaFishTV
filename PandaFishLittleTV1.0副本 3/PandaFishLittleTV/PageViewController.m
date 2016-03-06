//
//  PageViewController.m
//  MMParallaxScrollPresenter
//
//  Created by Malleo, Mitch on 12/19/14.
//

#import "PageViewController.h"
#import "NewLeftViewController.h"
@interface PageViewController ()

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
