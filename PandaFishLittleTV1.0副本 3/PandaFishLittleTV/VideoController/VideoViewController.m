//
//  VideoViewController.m
//  KS3PlayerDemo
//
//  Created by Blues on 15/3/18.
//  Copyright (c) 2015年 KSY. All rights reserved.
//

#import "VideoViewController.h"
#import "MediaControlViewController.h"
#import "KSYDefine.h"
#import "MediaControlView.h"
#import "MediaControlDefine.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
@interface VideoViewController ()

@property (nonatomic, strong) KSYPlayer *player;
@property (nonatomic) CGRect previousBounds;
@end

@implementation VideoViewController{
    
    UITextField *nativeField;
    UITextField *hlsField;
    UITextField *rtmpField;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _isCycleplay = YES;
    _beforeOrientation = UIDeviceOrientationPortrait;
    _pauseInBackground = YES;
    _motionInterfaceOrientation = UIInterfaceOrientationMaskLandscape;
    self.view.backgroundColor = [UIColor blackColor];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}
- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
//    NSLog(@"%@",videoUrl);
    [self netWorkStatus];
    
}
/**
 AFNetworkReachabilityStatusUnknown          = -1,  // 未知
 AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
 AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
 AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
 */
- (void)netWorkStatus
{
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
       // NSLog(@"%ld",status);
        if (status == 0 || status
            == -1) {
            [self netUnknown];
        }else if(status == 1) {
            [self netReachableViaWWAN];
        }else {
            if (!self.player) {
                [self initPlayer];
            }
        }
    }];
}
- (void)netReachableViaWWAN {
    if (self.player) {
       [self.player stop];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"你正在使用4g/3g/2g网络,继续观看可能产生超额流量费。" preferredStyle:UIAlertControllerStyleAlert];
    //添加按钮
    UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if (!self.player) {
            [self initPlayer];
        }else {
            [self.player play];
        }
    }];
    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (self.player) {
            [_player reset];
            [_player shutdown];
        }
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alertController addAction:okAlertAction];
    [alertController addAction:cancelAlertAction];
    //让弹出框显示
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}
- (void)netUnknown {
    if (self.player) {
        [self.player stop];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"网络连接异常" message:@"暂无法访问" preferredStyle:UIAlertControllerStyleAlert];
    //添加按钮
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (self.player) {
            [_player reset];
            [_player shutdown];
        }
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [alertController addAction:alertAction];
    //让弹出框显示
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}
- (void)initPlayer {
    _player = [[KSYPlayer alloc] initWithMURL:_videoUrl withOptions:nil];
    _player.shouldAutoplay = YES; ///+++++++ update
    _player.videoView.frame = CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)/2);
    _player.videoView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_player.videoView];
    
    _mediaControlViewController = [[MediaControlViewController alloc] init];
    
    _mediaControlViewController.delegate = self;
    [self.view addSubview:_mediaControlViewController.view];
    [_player setScalingMode:MPMovieScalingModeAspectFit];
    
    [_player prepareToPlay];
    [self orientationChanged];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(orientationChanged:)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil];
    [self registerApplicationObservers];
    [_player setAnalyzeduration:500];

}
- (void)adjustVideoViewScale {
    CGFloat width = _player.videoView.frame.size.width;
    CGFloat height = _player.videoView.frame.size.height;
    CGFloat x = _player.videoView.frame.origin.x;
    CGFloat y = _player.videoView.frame.origin.y;
    if (width > height * W16H9Scale) {
        x = (width - (height * W16H9Scale)) / 2;
        width = height * W16H9Scale;
    }
    else {
        y = (height - (width / W16H9Scale)) / 2;
        height = width / W16H9Scale;
    }
    _player.videoView.frame = CGRectMake(x, y, width, height);
}

- (void)registerApplicationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
}

- (void)unregisterApplicationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillTerminateNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

- (void)applicationWillEnterForeground
{
}

- (void)applicationDidBecomeActive
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![_player isPlaying]) {
            [self play];
        }
    });
}

- (void)applicationWillResignActive
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_pauseInBackground && [_player isPlaying]) {
            [self pause];
        }
    });
}

- (void)applicationDidEnterBackground
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_pauseInBackground && [_player isPlaying]) {
            [self pause];
        }
    });
}

- (void)applicationWillTerminate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_pauseInBackground && [_player isPlaying]) {
            [self pause];
        }
    });
}
- (void)orientationChanged
{
    
    UIDeviceOrientation orientation = UIDeviceOrientationLandscapeRight;
    if (self.deviceOrientation!=orientation) {
        if (orientation == UIDeviceOrientationPortrait)
        {
            self.deviceOrientation = orientation;
            [self minimizeVideo];
        }
        else if (orientation == UIDeviceOrientationLandscapeRight||orientation == UIDeviceOrientationLandscapeLeft)
        {
            self.deviceOrientation = orientation;
            [self launchFullScreen];
        }
        [_mediaControlViewController reSetLoadingViewFrame];
    }
}
- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];

    if (self.deviceOrientation!=orientation) {
        if (orientation == UIDeviceOrientationPortrait)
        {
            self.deviceOrientation = orientation;
            [self minimizeVideo];
        }
        else if (orientation == UIDeviceOrientationLandscapeRight||orientation == UIDeviceOrientationLandscapeLeft)
        {
            self.deviceOrientation = orientation;
            [self launchFullScreen];
        }
        [_mediaControlViewController reSetLoadingViewFrame];
    }
}

- (void)launchFullScreen
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if (!_fullScreenModeToggled) {
        _fullScreenModeToggled = YES;
        [self launchFullScreenWhileUnAlwaysFullscreen];
    }
    else {
        [self launchFullScreenWhileFullScreenModeToggled];
    }
     [_mediaControlViewController reSetLoadingViewFrame];
}

- (void)minimizeVideo
{
    if (_fullScreenModeToggled) {
        _fullScreenModeToggled = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationFade];
        [self minimizeVideoWhileUnAlwaysFullScreen];
    }
     [_mediaControlViewController reSetLoadingViewFrame];
}

- (void)launchFullScreenWhileFullScreenModeToggled{
    if ([UIApplication sharedApplication].statusBarOrientation == (UIInterfaceOrientation)[[UIDevice currentDevice] orientation]) {
        return;
    }
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (!KSYSYS_OS_IOS8) {
        [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
    }
    [UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration
                          delay:0.0f
                        options:(UIViewAnimationOptions)UIViewAnimationCurveLinear
                     animations:^{
                         float deviceHeight = [[UIScreen mainScreen] bounds].size.height;
                         float deviceWidth = [[UIScreen mainScreen] bounds].size.width;
                         UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
                         CGFloat angle =((orientation==UIDeviceOrientationLandscapeLeft)?(-M_PI):M_PI);
                         
                         _player.videoView.transform = CGAffineTransformRotate(_player.videoView.transform, angle);
                         _mediaControlViewController.view.transform = CGAffineTransformRotate(_mediaControlViewController.view.transform, angle);
                         
                         [_player.videoView setCenter:CGPointMake(deviceWidth/2, deviceHeight/2)];
                         _player.videoView.bounds = CGRectMake(0, 0, deviceHeight, deviceWidth);
                         [(MediaControlView *)_mediaControlViewController.view updateSubviewsLocation];
                     }
                     completion:^(BOOL finished) {
                         _beforeOrientation = [UIDevice currentDevice].orientation;
                     }];
}

- (void)launchFullScreenWhileUnAlwaysFullscreen
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationLandscapeRight) {
        if (!KSYSYS_OS_IOS8) {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
        }
        else {
        }
    }
    else {
        if (!KSYSYS_OS_IOS8) {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
            
        }
        else {
        }
    }
    self.previousBounds = _player.videoView.frame;
    [UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionLayoutSubviews//UIViewAnimationCurveLinear
                     animations:^{
                         float deviceHeight = KSYSYS_OS_IOS8?[[UIScreen mainScreen] bounds].size.width:[[UIScreen mainScreen] bounds].size.height;
                         float deviceWidth = KSYSYS_OS_IOS8?[[UIScreen mainScreen] bounds].size.height:[[UIScreen mainScreen] bounds].size.width;
                         
                         deviceHeight = [[UIScreen mainScreen] bounds].size.height;
                         deviceWidth = [UIScreen mainScreen].bounds.size.width;
                         if (orientation == UIDeviceOrientationLandscapeRight) {
                             _player.videoView.transform = CGAffineTransformRotate(_player.videoView.transform, -M_PI_2);
                             _mediaControlViewController.view.transform = CGAffineTransformRotate( _mediaControlViewController.view.transform, -M_PI_2);
                             MediaControlView *mediaControlView = (MediaControlView *)(_mediaControlViewController.view);
                             mediaControlView.center= _player.videoView.center;
                             
                         }else{
                             _player.videoView.transform = CGAffineTransformRotate(_player.videoView.transform, M_PI_2);
                             _mediaControlViewController.view.transform = CGAffineTransformRotate( _mediaControlViewController.view.transform, M_PI_2);
                             MediaControlView *mediaControlView = (MediaControlView *)(_mediaControlViewController.view);
                             mediaControlView.center= _player.videoView.center;
                         }
                         
                         if ([UIDevice currentDevice].systemVersion.floatValue < 8 ) {
                             
                             [_player.videoView setCenter:CGPointMake(deviceWidth/2, deviceHeight/2)];
                             _player.videoView.bounds = CGRectMake(0, 0, deviceHeight, deviceWidth);
                             
                             MediaControlView *mediaControlView = (MediaControlView *)(_mediaControlViewController.view);
                             mediaControlView.bounds = _player.videoView.bounds;
                             mediaControlView.center = CGPointMake(deviceWidth/2, deviceHeight/2);
                         }else{
                             [_player.videoView setCenter:CGPointMake(deviceWidth/2, deviceHeight/2)];
                             _player.videoView.bounds = CGRectMake(0, 0, deviceHeight, deviceWidth);
                             
                             MediaControlView *mediaControlView = (MediaControlView *)(_mediaControlViewController.view);
                             mediaControlView.center = CGPointMake(deviceWidth/2, deviceHeight/2);
                             mediaControlView.bounds = CGRectMake(0, 0, deviceHeight, deviceWidth);
                         }
                         [(MediaControlView *)_mediaControlViewController.view updateSubviewsLocation];
                     }
                     completion:^(BOOL finished) {
                         _beforeOrientation = [UIDevice currentDevice].orientation;
                     }
     ];
}

- (void)minimizeVideoWhileUnAlwaysFullScreen{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    [UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _player.videoView.transform = CGAffineTransformIdentity;
                         _mediaControlViewController.view.transform = CGAffineTransformIdentity;
                         _player.videoView.frame = self.previousBounds;
                         MediaControlView *mediaControlView = (MediaControlView *)(_mediaControlViewController.view);
                         mediaControlView.bounds = _player.videoView.bounds;
                         mediaControlView.center = CGPointMake(mediaControlView.bounds.size.width / 2, mediaControlView.bounds.size.height/2);
                         
                         [(MediaControlView *)_mediaControlViewController.view updateSubviewsLocation];
                     }
                     completion:^(BOOL success){
                         _beforeOrientation = [UIDevice currentDevice].orientation;
                         
                     }];
}

#pragma mark - minimize Exchange

- (void)minimizeVideoWhileIsAlwaysFullScreen{
    
    [UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _player.videoView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)/2);
                     }
                     completion:^(BOOL success){
                         _beforeOrientation = [UIDevice currentDevice].orientation;
                     }];
}

- (void)getVideoState
{
    //    //NSLog(@"[_player state] = = =%d",[_player state]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (KSYPlayer *)player {
    return _player;
}

#pragma mark - KSYMediaPlayDelegate

- (void)play {
    [_player play];
}

- (void)pause {
    [_player pause];
}

- (void)stop {
    [_player stop];
}

- (BOOL)isPlaying {
    return [_player isPlaying];
}

- (void)shutdown {
    [_player shutdown];
}

- (void)seekProgress:(CGFloat)position {
    [_player setCurrentPlaybackTime:position];
}

- (void)setVideoQuality:(KSYVideoQuality)videoQuality {
    //NSLog(@"set video quality");
}

- (void)setVideoScale:(KSYVideoScale)videoScale {
    CGRect videoRect = [[UIScreen mainScreen] bounds];
    NSInteger scaleW = 16;
    NSInteger scaleH = 9;
    switch (videoScale) {
        case kKSYVideo16W9H:
            scaleW = 16;
            scaleH = 9;
            break;
        case kKSYVideo4W3H:
            scaleW = 4;
            scaleH = 3;
            break;
        default:
            break;
    }
    if (videoRect.size.height >= videoRect.size.width * scaleW / scaleH) {
        videoRect.origin.x = 0;
        videoRect.origin.y = (videoRect.size.height - videoRect.size.width * scaleW / scaleH) / 2;
        videoRect.size.height = videoRect.size.width * scaleW / scaleH;
    }
    else {
        videoRect.origin.x = (videoRect.size.width - videoRect.size.height * scaleH / scaleW) / 2;
        videoRect.origin.y = 0;
        videoRect.size.width = videoRect.size.height * scaleH / scaleW;
    }
    _player.videoView.frame = videoRect;
}

- (void)setAudioAmplify:(CGFloat)amplify {
    [_player setAudioAmplify:amplify];
}

- (void)setCycleplay:(BOOL)isCycleplay {
    
}

#pragma mark - UIInterface layout subviews

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}
- (void)dealloc
{
    [self unregisterApplicationObservers];
}

#pragma mark - StatusBarHidden
- (void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:animated];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
