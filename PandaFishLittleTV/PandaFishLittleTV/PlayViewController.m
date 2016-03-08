//
//  PlayViewController.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/3/3.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "PlayViewController.h"
#import "DBManager.h"
#import "ShouCangModel.h"
#import <UIImageView+WebCache.h>
#import "VideoViewController.h"
#import "TQStarRatingView.h"
#import "ZHeaderHelp.h"
@interface PlayViewController ()<StarRatingViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *shoucanButton;
@property (weak, nonatomic) IBOutlet UIImageView *roooImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nameImageView;
@property (weak, nonatomic) IBOutlet UILabel *xiangQingLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) UILabel *myLabel;

@property (nonatomic, strong)  TQStarRatingView *starsView;
@property (nonatomic, strong) UIView *starsBGView;
@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UIButton *btn1;

@property (nonatomic, copy) NSString *stastNum;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    
    _model = [ShouCangModel new];
    _model.name = self.name;
    _model.imageURl = self.imageURl;
    _model.roomID = self.roomID;
    _model.roomKey = self.roomKey;
    
    [self createUI];
    
    
    BOOL isExostRecord = [[DBManager sharedManager] isExistAppForRoomID:_model.roomID];
    
    if (isExostRecord) {
        
        [_shoucanButton setImage:[UIImage imageNamed:@"like1hl"] forState:(UIControlStateNormal)];
    }else {
        [_shoucanButton setImage:[UIImage imageNamed:@"like1nm"] forState:(UIControlStateNormal)];
    }
    [_shoucanButton addTarget:self action:@selector(shouCangBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    
    NSLog(@"wangzhishi%@",_playURL);
    
}
- (void)createUI {

    [self createStrasView];
    
    [_roooImageView sd_setImageWithURL:[NSURL URLWithString:_roomImageURl] placeholderImage:[UIImage imageNamed:@"about"]];
    _nameLabel.text = _model.name;
    _xiangQingLabel.text = _xiangqing;
    [_nameImageView sd_setImageWithURL:[NSURL URLWithString:_model.imageURl] placeholderImage:[UIImage imageNamed:@"about"]];
}

- (void)createStrasView {
    
    _starsBGView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight + 100, kWindowWidth, kWindowHeight / 3)];
    
    
    _starsView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(kWindowWidth/ 6, 20, kWindowWidth * 2 / 3, 50) numberOfStar:5];
    _starsView.delegate = self;
    
    _starsView.userInteractionEnabled = YES;
    _btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    _btn.frame = CGRectMake(kWindowWidth/ 6 + 10 , 80, 50 ,50);
    _btn.tag = 100;
    [_btn setTitle:@"取消" forState:(UIControlStateNormal)];
    [_btn addTarget:self action:@selector(btnPressed:) forControlEvents:(UIControlEventTouchUpInside)];
    
  _btn1 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    _btn1.frame = CGRectMake( kWindowWidth * 2 / 3  , 80, 50 ,50);
    _btn1.tag = 101;
    [_btn1 setTitle:@"确定" forState:(UIControlStateNormal)];
    [_btn1 addTarget:self action:@selector(btnPressed:) forControlEvents:(UIControlEventTouchUpInside)];

    _starsBGView.backgroundColor = [UIColor blackColor];
    _starsBGView.alpha = 0.6;
    [_starsBGView addSubview:_btn];

    [_starsBGView addSubview:_btn1];
    [_starsBGView addSubview:_starsView];
    
    [self.view addSubview:_starsBGView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
// _starsBGView.frame = CGRectMake(0, kWindowHeight + 100, kWindowWidth, kWindowHeight / 3);
//    
}

- (void)btnPressed:(UIButton *)sender {

    
    if (sender.tag == 100) {
        
        
    }else if (sender.tag == 101) {
    
      
        
        _model.pinFen = self.stastNum;
        
        [_shoucanButton setImage:[UIImage imageNamed:@"like1hl"] forState:(UIControlStateNormal)];
        [[DBManager sharedManager] insertModel:self.model];
    }

    
    _starsBGView.frame = CGRectMake(0, kWindowHeight + 100, kWindowWidth, kWindowHeight / 3);
     _starsView.starForegroundView.alpha = 0;
 }


-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    self.stastNum = [NSString stringWithFormat:@"%0.2f",score * 10 ];
    
    if ([self.stastNum isEqualToString:@"10.00"]) {
        self.stastNum = @"9.99";
    }
    
    if (self.stastNum == nil){
        
        self.stastNum = @"0.00";
    }
}



- (void)shouCangBtn:(id)sender {
    
    BOOL isExostRecord = [[DBManager sharedManager] isExistAppForRoomID:_model.roomID];
    // 已收藏的
    
    if (isExostRecord) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定移除收藏" message:@"您真的要移除对主播的收藏吗%>_<%" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertController *a2 = [UIAlertController alertControllerWithTitle:@"成功移除收藏" message:@"主播会更加努力直播，为大家快乐↖(^ω^)↗" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *aA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [a2 addAction:aA];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

            [_shoucanButton setImage:[UIImage imageNamed:@"like1nm"] forState:(UIControlStateNormal)];
            [[DBManager sharedManager] deleteValueWithRoomId:_model.roomID];
            
            [self presentViewController:a2 animated:YES completion:nil];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:^ {
            
        }];
        
    } else {
    
        [UIView animateWithDuration:1.2 animations:^{
            
            _starsBGView.frame = CGRectMake(0, kWindowHeight * 2 / 3, kWindowWidth, kWindowHeight / 3);
        }];

    }

}

- (IBAction)juBaoBtn:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定举报" message:@"举报内容:色情暴力,违反法律法规" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertController *a2 = [UIAlertController alertControllerWithTitle:@"举报成功" message:@"已经收到举报,我们会尽快核实,为此对你带来的不便我们由衷的道歉!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *aA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [a2 addAction:aA];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        [self presentViewController:a2 animated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

- (IBAction)playVideo:(id)sender {
    
    VideoViewController *vc = [VideoViewController new];
    vc.videoUrl = [NSURL URLWithString:_playURL];
    [self presentViewController:vc animated:YES completion:nil];
    
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

- (IBAction)button:(id)sender {
}
@end
