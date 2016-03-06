//
//  NewLeftViewController.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/26.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "NewLeftViewController.h"
#import "ZHeaderHelp.h"
#import "ForWeViewController.h"
#import <SDImageCache.h>
#import "JWCache.h"


#define kScreenFrame [UIScreen mainScreen].bounds
#define kScreenWith [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


#define kScreenWith [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

const CGFloat kNavigationBarHeight = 44;
const CGFloat kStatusBarHeight = 20;

@interface NewLeftViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, strong) UIView *headerContentView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, strong) NSMutableArray *dataSouce;

@property (nonatomic, strong) NSMutableArray *imageDataSouce;



@end

@implementation NewLeftViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSouce = [NSMutableArray arrayWithObjects:@"建议反馈",@"帮助",@"清空缓存", nil];
    _imageDataSouce = [NSMutableArray arrayWithObjects:@"like1hl",@"about",@"head",nil];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    self.headerHeight = 300;
    [self.view addSubview:self.tableView];
    
    //header
    CGRect bounds = CGRectMake(0, 0, kScreenWith, self.headerHeight);
    UIView *contentView = [[UIView alloc] initWithFrame:bounds];
    contentView.backgroundColor = [UIColor blackColor];
    //背景
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.bounds = bounds;
    headerImageView.center = contentView.center;
    headerImageView.image = [UIImage imageNamed:@"back4.jpg"];
    contentView.layer.masksToBounds = YES;
    
    self.headerImageView = headerImageView;
    self.headerContentView = contentView;
    [self.headerContentView addSubview:self.headerImageView];
    self.headerContentView.layer.masksToBounds = YES;
    
    //信息内容
    CGRect icon_frame = CGRectMake(12, self.headerContentView.bounds.size.height-80-12, 80, 80);
    UIImageView *icon = [[UIImageView alloc] initWithFrame:icon_frame];
    icon.backgroundColor = [UIColor clearColor];
    icon.image = [UIImage imageNamed:@"person2.jpg"];
    // 设置圆形的图片
    icon.layer.cornerRadius = 80/2.0f;
    icon.layer.masksToBounds = YES;
    icon.layer.borderWidth = 1.0f;
    icon.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.headerContentView addSubview:icon];
    self.icon = icon;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(108, self.headerContentView.bounds.size.height-60-12, kScreenWith-108-12, 50)];
    label.text = @"你好中国,我在郑州!";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0;
    self.label = label;
    [self.headerContentView addSubview:self.label];
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:bounds];
    [headerView addSubview:self.headerContentView];
    self.tableView.tableHeaderView = headerView;;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset_Y = scrollView.contentOffset.y;
    CGFloat alpha = (offset_Y + 40)/300.0f;
    self.backView.backgroundColor = [self.backColor colorWithAlphaComponent:alpha];
    
    if (offset_Y < -64) {
        //放大比例
        CGFloat add_topHeight = -(offset_Y+kNavigationBarHeight+kStatusBarHeight);
        self.scale = (self.headerHeight+add_topHeight)/self.headerHeight;
        //改变 frame
        CGRect contentView_frame = CGRectMake(0, -add_topHeight, kScreenWith, self.headerHeight+add_topHeight);
        self.headerContentView.frame = contentView_frame;
        CGRect imageView_frame = CGRectMake(-(kScreenWith*self.scale-kScreenWith)/2.0f, 0, kScreenWith*self.scale, self.headerHeight+add_topHeight);
        self.headerImageView.frame = imageView_frame;
        
        CGRect icon_frame = CGRectMake(12, self.headerContentView.bounds.size.height-80-12, 80, 80);
        self.icon.frame = icon_frame;
        
        self.label.frame = CGRectMake(108, self.headerContentView.bounds.size.height-60-12, kScreenWith-108-12, 50);
        
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSouce.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataSouce[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:self.imageDataSouce[indexPath.row]];
    
    return cell;
}

-(UITableView *)tableView{
    
    if (_tableView == nil) {
        
        CGRect tableView_frame = CGRectMake(0, -64, kScreenWith, kScreenHeight+kNavigationBarHeight+kStatusBarHeight);
        _tableView = [[UITableView alloc] initWithFrame:tableView_frame style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"dianjile%ld",indexPath.row);
    
    switch (indexPath.row) {
        case 0:
        {
//            LoginViewController *loginVC = [LoginViewController new];
//            
//            [self.navigationController pushViewController:loginVC animated:YES];
            
        }
            break;
        case 1:
        {
//            WeViewController *weVC = [WeViewController new];
//            
//            [self.navigationController pushViewController:weVC animated:YES];
            ForWeViewController * vc = [ForWeViewController new];
            [self createWaterRecon];
            
           [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        case 2:
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清理缓存" message:[NSString stringWithFormat:@"确定清除缓存%.2fM", [self getCacheSize]] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertController *a2 = [UIAlertController alertControllerWithTitle:@"清理成功" message:@"已经很干净啦" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *aA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            
            [a2 addAction:aA];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"清理" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                // 图片缓存
                [self removeCacheData];
                [JWCache resetCache];
                [self presentViewController:a2 animated:YES completion:nil];
            }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }
            break;
        default:
            break;
    }
    
}

- (void)removeCacheData {
    
    [[SDImageCache sharedImageCache] clearDisk];
}

- (double)getCacheSize {
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    NSUInteger fileSize = [imageCache getSize]; // 以字节为单位
    NSString *myCachePath =  [JWCache cacheDirectory];
    //NSLog(@"%@",myCachePath);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *fileInfo = [fm attributesOfItemAtPath:myCachePath error:nil];
    fileSize += fileInfo.fileSize;
    return fileSize/1024.0/1024.0;
}


/**
 *  水纹效果
 */
- (void)createWaterRecon {
    
    CATransition *trasition = [CATransition animation];
    trasition.duration = 1;
    [trasition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    trasition.type = @"rippleEffect";
    [self.navigationController.view.layer addAnimation:trasition forKey:@"animation"];
    
}

- (void)viewWillAppear:(BOOL)animated {

   // [self.navigationController setNavigationBarHidden:YES];

}

- (void)viewWillDisappear:(BOOL)animated {

   // [self.navigationController setNavigationBarHidden:NO];

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
