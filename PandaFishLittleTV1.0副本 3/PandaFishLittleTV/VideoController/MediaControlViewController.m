//
//  MediaControlViewController.m
//  KS3PlayerDemo
//
//  Created by Blues on 15/3/18.
//  Copyright (c) 2015年 KSY. All rights reserved.
//

#import "MediaControlViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoViewController.h"
#import "MediaControlView.h"
#import "MediaControlDefine.h"
#import "ThemeManager.h"
#import "MediaVoiceView.h"
#import "KSYDefine.h"

#import <sys/sysctl.h>
#import <mach/mach.h>

@interface MediaControlViewController (){
    BOOL _isKSYPlayerPling;
    UIActivityIndicatorView *_indicatorView;
    UILabel *_indicatorLabel;
    BOOL _isPrepared;
    KSYVideoQuality _curVideoQuality;
    KSYVideoScale _curVideoScale;
    
    CGFloat _minCPU, _maxCPU;
    CGFloat _minMem, _maxMem;
    NSTimer *_timer;
}

@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL isCompleted;
@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat curPosition;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIView *errorView;
@property (nonatomic, assign) NSInteger audioAmplify;
@property (nonatomic, assign) CGFloat curVoice;
@property (nonatomic, assign) CGFloat curBrightness;
@property (nonatomic, assign) KSYGestureType gestureType;

@end

@implementation MediaControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // **** player delegate
    KSYPlayer *player = [(VideoViewController *)_delegate player];
    player.delegate = self;
    
    _isActive = YES;
    _isCompleted = NO;
    _isLocked = NO;
    _audioAmplify = 1;
    _gestureType = kKSYUnknown;
    _curVideoQuality = kKSYVideoNormal;
    _curVideoScale = kKSYVideo16W9H;
    
    _minCPU = 999, _maxCPU = 0;
    _minMem = 999, _maxMem = 0;
    
    // **** 主题包管理
    ThemeManager *themeManager = [ThemeManager sharedInstance];
//    [themeManager changeTheme:@"blue"];
//    [themeManager changeTheme:@"green"];
//    [themeManager changeTheme:@"orange"];
//    [themeManager changeTheme:@"pink"];
    [themeManager changeTheme:@"red"];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect mediaControlRect = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height / 2);
    MediaControlView *mediaControlView = [[MediaControlView alloc] initWithFrame:mediaControlRect];
    self.view = mediaControlView;
    mediaControlView.controller = self;
    
    [self performSelector:@selector(hideAllControls) withObject:nil afterDelay:3.0];
    [self refreshControl];
    
    UIButton *playBtn = (UIButton *)[self.view viewWithTag:kBarPlayBtnTag];
    UIImage *playImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
    UIImage *playImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_hl"];
    UIImage *pauseImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_normal"];
    UIImage *pauseImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_hl"];
    if (!player.shouldAutoplay) {
        [playBtn setImage:playImg_n forState:UIControlStateNormal];
        [playBtn setImage:playImg_h forState:UIControlStateHighlighted];
        
    }else{
        [playBtn setImage:pauseImg_n forState:UIControlStateNormal];
        [playBtn setImage:pauseImg_h forState:UIControlStateNormal];
    }
    
    [self clickFullBtn:nil];
    
    // **** 水印
    NSString *strFileName = [[[(VideoViewController *)_delegate videoUrl] absoluteString] lastPathComponent];
    if ([strFileName isEqualToString:@"Phone-h265.480p.20Min.300K.mp4"] == YES) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 240, 31)];
        UIImage *img = [UIImage imageNamed:@"phone-h265.480p.300kbps.png"];
        imgView.image = img;
        [self.view addSubview:imgView];
    }
    if ([strFileName isEqualToString:@"Pad-h265.720p.20Min.1M.mp4"] == YES) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 175, 240, 31)];
        UIImage *img = [UIImage imageNamed:@"ipad-h265.720p.1Mbps.png"];
        imgView.image = img;
        [self.view addSubview:imgView];
    }
    
    // **** timer
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showSysInfo) userInfo:nil repeats:YES];
}
- (void)showSysInfo {
    double usedMemoryofApp = [self usedMemory];
    float cpu_usage = [self cpu_usage];
    
    if (cpu_usage > _maxCPU) {
        _maxCPU = cpu_usage;
    }
    else if (cpu_usage < _minCPU) {
        _minCPU = cpu_usage;
    }
    
    if (usedMemoryofApp > _maxMem) {
        _maxMem = usedMemoryofApp;
    }
    else if (usedMemoryofApp < _minMem) {
        _minMem = usedMemoryofApp;
    }
    
    UILabel *cpuLabel = (UILabel *)[self.view viewWithTag:kCPULabel];
    UILabel *memLabel = (UILabel *)[self.view viewWithTag:kMemLabel];
    cpuLabel.text = [NSString stringWithFormat:@"CPU: %ld%%", (long)cpu_usage];
    memLabel.text = [NSString stringWithFormat:@"Mem: %.1f MB", usedMemoryofApp]; // **** 15: 临时的偏移量
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshControl {
    UILabel *startLabel = (UILabel *)[self.view viewWithTag:kProgressCurLabelTag];
    UILabel *endLabel = (UILabel *)[self.view viewWithTag:kProgressMaxLabelTag];
    UISlider *progressSlider = (UISlider *)[self.view viewWithTag:kProgressSliderTag];
    
    NSInteger duration = (NSInteger)[(VideoViewController *)_delegate player].duration;
    NSInteger position = (NSInteger)[(VideoViewController *)_delegate player].currentPlaybackTime;
    int iMin  = (int)(position / 60);
    int iSec  = (int)(position % 60);
    startLabel.text = [NSString stringWithFormat:@"%02d:%02d", iMin, iSec];
    if (duration > 0) {
        int iDuraMin  = (int)(duration / 60);
        int iDuraSec  = (int)(duration % 3600 % 60);
        endLabel.text = [NSString stringWithFormat:@"/%02d:%02d", iDuraMin, iDuraSec];
        progressSlider.value = position;
        progressSlider.maximumValue = duration;
    }
    else {
        endLabel.text = @"--:--";
        progressSlider.value = 0.0f;
        progressSlider.maximumValue = 1.0f;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
    if (_isActive == YES) {
        [self performSelector:@selector(refreshControl) withObject:nil afterDelay:1.0];
    }
}

#pragma mark - Actions

- (void)clickPlayBtn:(id)sender
{
    if (!_isPrepared) {
        return;
    }
    UIButton *btn = (UIButton *)sender;
    UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
    UIImage *paueImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_normal"];
    if ([_delegate respondsToSelector:@selector(isPlaying)] == YES) {
        if ([_delegate isPlaying] == NO && [_delegate respondsToSelector:@selector(play)] == YES) {
            [_delegate play];
            [btn setImage:paueImg forState:UIControlStateNormal];
        }
        else if ([_delegate isPlaying] == YES && [_delegate respondsToSelector:@selector(pause)] == YES) {
            [_delegate pause];
            [btn setImage:playImg forState:UIControlStateNormal];
        }
    }
}

- (void)clickHighlightBtn:(id)sender {
    UIButton *qualityBtn = (UIButton *)sender;
    qualityBtn.layer.borderColor = [[ThemeManager sharedInstance] themeColor].CGColor;
}

- (void)clickNormalBtn:(id)sender {
    UIButton *qualityBtn = (UIButton *)sender;
    qualityBtn.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)showColor:(id)sender {
    UIButton *qualityBtn = (UIButton *)sender;
    qualityBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [qualityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)clickQualityBtn:(id)sender
{
    UIButton *qualityBtn = (UIButton *)sender;
    UIColor *tintColor = [[ThemeManager sharedInstance] themeColor];
    qualityBtn.layer.borderColor = tintColor.CGColor;
    [qualityBtn setTitleColor:tintColor forState:UIControlStateNormal];
    [self performSelector:@selector(showColor:) withObject:sender afterDelay:0.1];
    UIView *qualityView = [self.view viewWithTag:kQualityViewTag];
    UIView *scaleView = [self.view viewWithTag:kScaleViewTag];
    if (qualityView != nil) {
        [UIView animateWithDuration:0.3 animations:^{
            qualityView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [qualityView removeFromSuperview];
        }];
        return ;
    }
    if (scaleView != nil) {
        [UIView animateWithDuration:0.3 animations:^{
            scaleView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [scaleView removeFromSuperview];
        }];
    }
    CGPoint btnLocation = [qualityBtn.superview convertPoint:qualityBtn.frame.origin toView:self.view];
    CGRect rect = CGRectMake(btnLocation.x - 5, btnLocation.y - 120, qualityBtn.frame.size.width + 10, 115);
    qualityView = [[UIView alloc] initWithFrame:rect];
    qualityView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:qualityView];
    qualityView.tag = kQualityViewTag;
    
    UIView *qualityBgView = [[UIView alloc] initWithFrame:qualityView.bounds];
    qualityBgView.backgroundColor = [UIColor blackColor];
    qualityBgView.alpha = 0.6;
    qualityBgView.layer.masksToBounds = YES;
    qualityBgView.layer.cornerRadius = 3;
    [qualityView addSubview:qualityBgView];
    NSArray *arrTitles = @[@"流畅", @"高清", @"超清"];
    for (NSInteger i = 0; i < 3; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arrTitles[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(5, 5 + 35 * i, rect.size.width - 10, 30);
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        btn.tag = i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:tintColor forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(adjustVideoQuality:) forControlEvents:UIControlEventTouchUpInside];
        [qualityView addSubview:btn];
        if (i == _curVideoQuality) {
            UIColor *themeColor = [[ThemeManager sharedInstance] themeColor];
            [btn setTitleColor:themeColor forState:UIControlStateNormal];
        }
        else {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

- (void)adjustVideoQuality:(UIButton *)adjustQualityBtn {
    UIButton *showQualityViewBtn = (UIButton *)[self.view viewWithTag:kQualityBtnTag];
    UIColor *tintColor = [[ThemeManager sharedInstance] themeColor];
    adjustQualityBtn.layer.borderColor = tintColor.CGColor;
    [adjustQualityBtn setTitleColor:tintColor forState:UIControlStateNormal];
    [self performSelector:@selector(showColor:) withObject:adjustQualityBtn afterDelay:0.1];
    KSYVideoQuality videoQuality = kKSYVideoNormal;
    if (adjustQualityBtn.tag == 0) {
        videoQuality = kKSYVideoNormal;
        [showQualityViewBtn setTitle:@"流畅" forState:UIControlStateNormal];
    }
    else if (adjustQualityBtn.tag == 1) {
        videoQuality = kKSYVideoHight;
        [showQualityViewBtn setTitle:@"高清" forState:UIControlStateNormal];
    }
    else if (adjustQualityBtn.tag == 2) {
        videoQuality = kKSYVideoSuper;
        [showQualityViewBtn setTitle:@"超清" forState:UIControlStateNormal];
    }
    _curVideoQuality = videoQuality;
    if ([_delegate respondsToSelector:@selector(setVideoQuality:)] == YES) {
        [_delegate setVideoQuality:videoQuality];
    }
    UIView *qualityView = [self.view viewWithTag:kQualityViewTag];
    [UIView animateWithDuration:0.3 animations:^{
        qualityView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [qualityView removeFromSuperview];
    }];
}

- (void)progressDidBegin:(id)slider
{
    KSYPlayer *player = [(VideoViewController *)_delegate player];
    _isKSYPlayerPling = player.isPlaying;
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
    [(UISlider *)slider setThumbImage:dotImg forState:UIControlStateNormal];
    NSInteger duration = (NSInteger)[(VideoViewController *)_delegate player].duration;
    if (duration > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
        if ([_delegate isPlaying] == YES) {
            _isActive = NO;
            [_delegate pause];
            UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
            UIButton *btn = (UIButton *)[self.view viewWithTag:kBarPlayBtnTag];
            [btn setImage:playImg forState:UIControlStateNormal];
        }
    }
}

- (void)progressChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    if (!_isPrepared) {
        slider.value = 0.0f;
        return;
    }
    NSInteger duration = (NSInteger)[(VideoViewController *)_delegate player].duration;
    if (duration > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
        UISlider *progressSlider = (UISlider *)[self.view viewWithTag:kProgressSliderTag];
        UILabel *startLabel = (UILabel *)[self.view viewWithTag:kProgressCurLabelTag];

        if ([_delegate isPlaying] == YES) {
            _isActive = NO;
            [_delegate pause];
            UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
            UIButton *btn = (UIButton *)[self.view viewWithTag:kBarPlayBtnTag];
            [btn setImage:playImg forState:UIControlStateNormal];
        }
        NSInteger position = progressSlider.value;
        int iMin  = (int)(position / 60);
        int iSec  = (int)(position % 60);
        NSString *strCurTime = [NSString stringWithFormat:@"%02d:%02d/", iMin, iSec];
        startLabel.text = strCurTime;
    }
    else {
        slider.value = 0.0f;
        [self showNotice:@"直播不支持拖拽"];
    }
}

- (void)progressChangeEnd:(id)sender {
    if (!_isPrepared) {
        return;
    }
    
    UISlider *slider = (UISlider *)sender;
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
    [slider setThumbImage:dotImg forState:UIControlStateNormal];
    NSInteger duration = (NSInteger)[(VideoViewController *)_delegate player].duration;
    if (duration > 0) {
        if ([_delegate respondsToSelector:@selector(seekProgress:)] == YES) {
            [_delegate seekProgress:slider.value];
        }
    }
    else {
        slider.value = 0.0f;
        [self showNotice:@"直播不支持拖拽"];
        //NSLog(@"###########当前是直播状态无法拖拽进度###########");
    }
}

- (void)brightnessChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [[UIScreen mainScreen] setBrightness:slider.value];
}

- (void)brightnessDidBegin:(id)sender {
    UISlider *slider = (UISlider *)sender;
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
    [slider setThumbImage:dotImg forState:UIControlStateNormal];
}

- (void)brightnessChangeEnd:(id)sender {
    UISlider *slider = (UISlider *)sender;
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
    [slider setThumbImage:dotImg forState:UIControlStateNormal];
}

- (void)voiceChanged:(id)sender
{
    UISlider *voiceSlider = (UISlider *)sender;
    MPMusicPlayerController *musicPlayer;
    musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    [musicPlayer setVolume:voiceSlider.value];
}
- (void)clickExitBtn:(id)sender {
     VideoViewController *videoView = (VideoViewController *)_delegate;
    if (videoView.player != nil) {
        [videoView.player reset];
        [videoView.player shutdown];
    }
    [videoView dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)clickFullBtn:(id)sender {
    
    VideoViewController *videoView = (VideoViewController *)_delegate;
    if (videoView.fullScreenModeToggled) {
        videoView.beforeOrientation = UIDeviceOrientationPortrait;
        [videoView minimizeVideo];
        videoView.deviceOrientation = UIDeviceOrientationPortrait;
    }else{
        videoView.beforeOrientation = UIDeviceOrientationLandscapeLeft;
        [videoView launchFullScreen];
        videoView.deviceOrientation = UIDeviceOrientationLandscapeLeft;
    }
}

- (void)clickScaleBtn:(id)sender {
    UIButton *scaleBtn = (UIButton *)sender;
    UIColor *tintColor = [[ThemeManager sharedInstance] themeColor];
    scaleBtn.layer.borderColor = tintColor.CGColor;
    [scaleBtn setTitleColor:tintColor forState:UIControlStateNormal];
    [self performSelector:@selector(showColor:) withObject:sender afterDelay:0.1];
    UIView *scaleView = [self.view viewWithTag:kScaleViewTag];
    UIView *qualityView = [self.view viewWithTag:kQualityViewTag];
    if (scaleView != nil) {
        [UIView animateWithDuration:0.3 animations:^{
            scaleView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [scaleView removeFromSuperview];
        }];
        return ;
    }
    if (qualityView != nil) {
        [UIView animateWithDuration:0.3 animations:^{
            qualityView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [qualityView removeFromSuperview];
        }];
    }
    CGPoint btnLocation = [scaleBtn.superview convertPoint:scaleBtn.frame.origin toView:self.view];
    CGRect rect = CGRectMake(btnLocation.x - 5, btnLocation.y - 90, scaleBtn.frame.size.width + 10, 90);
    scaleView = [[UIView alloc] initWithFrame:rect];
    scaleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scaleView];
    scaleView.tag = kScaleViewTag;
    
    UIView *scaleBgView = [[UIView alloc] initWithFrame:scaleView.bounds];
    scaleBgView.backgroundColor = [UIColor blackColor];
    scaleBgView.alpha = 0.6;
    scaleBgView.layer.masksToBounds = YES;
    scaleBgView.layer.cornerRadius = 3;
    [scaleView addSubview:scaleBgView];
    NSArray *arrTitles = @[@"16:9", @"4:3"];
    for (NSInteger i = 0; i < arrTitles.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arrTitles[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(5, 5 + 35 * i, rect.size.width - 10, 30);
        btn.tag = i;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn setTitleColor:tintColor forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(adjustVideoScale:) forControlEvents:UIControlEventTouchUpInside];
        [scaleView addSubview:btn];
        if (i == _curVideoScale) {
            UIColor *themeColor = [[ThemeManager sharedInstance] themeColor];
            [btn setTitleColor:themeColor forState:UIControlStateNormal];
        }
        else {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

- (void)adjustVideoScale:(id)sender {
    UIButton *showScaleBtn = (UIButton *)[self.view viewWithTag:kScaleBtnTag];
    UIButton *scaleBtn = (UIButton *)sender;
    UIColor *tintColor = [[ThemeManager sharedInstance] themeColor];
    scaleBtn.layer.borderColor = tintColor.CGColor;
    [scaleBtn setTitleColor:tintColor forState:UIControlStateNormal];
    [self performSelector:@selector(showColor:) withObject:scaleBtn afterDelay:0.1];
    
    KSYVideoScale scale = kKSYVideo16W9H;
    if (scaleBtn.tag == 0) {
        scale = kKSYVideo16W9H;
        [showScaleBtn setTitle:@"16:9" forState:UIControlStateNormal];
    }
    else if (scaleBtn.tag == 1) {
        scale = kKSYVideo4W3H;
        [showScaleBtn setTitle:@"4:3" forState:UIControlStateNormal];
    }
    _curVideoScale = scale;
    if ([_delegate respondsToSelector:@selector(setVideoScale:)] == YES) {
        [_delegate setVideoScale:scale];
    }
    
    UIView *scaleView = [self.view viewWithTag:kScaleViewTag];
    [UIView animateWithDuration:0.3 animations:^{
        scaleView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [scaleView removeFromSuperview];
    }];
}

- (void)clickEpisodeBtn:(id)sender {
    UIButton *episodeBtn = (UIButton *)sender;
    UIColor *tintColor = [[ThemeManager sharedInstance] themeColor];
    episodeBtn.layer.borderColor = tintColor.CGColor;
    [episodeBtn setTitleColor:tintColor forState:UIControlStateNormal];
    [self performSelector:@selector(showColor:) withObject:sender afterDelay:0.1];
//    NSLog(@"剧集");
}

- (void)clickSnapBtn:(id)sender {
    KSYPlayer *player = [(VideoViewController *)_delegate player];
    UIImage *snapImage = [player thumbnailImageAtCurrentTime];
    UIImageWriteToSavedPhotosAlbum(snapImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)clickLockBtn:(id)sender {
    _isLocked = !_isLocked;
    UIView *barView = [self.view viewWithTag:kBarViewtag];
    UIView *voiceView = [self.view viewWithTag:kVoiceViewTag];
    UIView *brightnessView = [self.view viewWithTag:kBrightnessViewTag];
    UIView *toolView = [self.view viewWithTag:kToolViewTag];
    UIView *qualityView = [self.view viewWithTag:kQualityViewTag];
    UIView *scaleView = [self.view viewWithTag:kScaleViewTag];
    UIButton *lockBtn = (UIButton *)sender;
    if (_isLocked == YES) {
        barView.alpha = 0.0;
        voiceView.alpha = 0.0;
        brightnessView.alpha = 0.0;
        toolView.alpha = 0.0;
        qualityView.alpha = 0.0;
        scaleView.alpha = 0.0;
        UIImage *lockCloseImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_lock_close_normal"];
        UIImage *lockCloseImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_lock_close_hl"];
        [lockBtn setImage:lockCloseImg_n forState:UIControlStateNormal];
        [lockBtn setImage:lockCloseImg_h forState:UIControlStateHighlighted];
    }
    else {
        barView.alpha = 1.0;
        voiceView.alpha = 1.0;
        brightnessView.alpha = 1.0;
        toolView.alpha = 1.0;
        qualityView.alpha = 1.0;
        scaleView.alpha = 1.0;
        UIImage *lockOpenImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_lock_open_normal"];
        UIImage *lockOpenImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_lock_open_hl"];
        [lockBtn setImage:lockOpenImg_n forState:UIControlStateNormal];
        [lockBtn setImage:lockOpenImg_h forState:UIControlStateHighlighted];
    }
}

- (void)clickSoundOff:(UITapGestureRecognizer *)tapGesture {
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    [musicPlayer setVolume:0];
    MediaVoiceView *mediaVoiceView = (MediaVoiceView *)[self.view viewWithTag:kMediaVoiceViewTag];
    [mediaVoiceView setIVoice:0];
}

#pragma mark - Snap delegate

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        
        CGRect noticeRect = CGRectMake(0, 0, 100, 100);
        UIView *noticeView = [[UIView alloc] initWithFrame:noticeRect];
        noticeView.backgroundColor = [UIColor clearColor];
        CGPoint center = self.view.center;
        noticeView.center = CGPointMake(center.y, center.x);
        [self.view addSubview:noticeView];
        
        UIView *noticeBgView = [[UIView alloc] initWithFrame:noticeView.bounds];
        noticeBgView.backgroundColor = [UIColor blackColor];
        noticeBgView.alpha = 0.6f;
        noticeBgView.layer.masksToBounds = YES;
        noticeBgView.layer.cornerRadius = 3;
        [noticeView addSubview:noticeBgView];
        
        // **** mark
        CGRect imgRect = CGRectMake(32, 7, 36, 36);
        UIImageView *completeImgView = [[UIImageView alloc] initWithFrame:imgRect];
        UIImage *snapCompleteImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_complete_normal"];
        completeImgView.image = snapCompleteImg;
        [noticeView addSubview:completeImgView];
        
        CGRect labelRect = CGRectMake(0, 57, 100, 36);
        UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
        label.text = @"截图成功";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [noticeView addSubview:label];
        
        // **** dismiss
        [UIView animateWithDuration:1.0 animations:^{
            noticeView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [noticeView removeFromSuperview];
        }];
    }
}

#pragma mark - Touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    KSYPlayer *player = [(VideoViewController *)_delegate player];
    _isKSYPlayerPling = player.isPlaying;
    UISlider *progressSlider = (UISlider *)[self.view viewWithTag:kProgressSliderTag];
    _startPoint = [[touches anyObject] locationInView:self.view];
    _curPosition = progressSlider.value;
    _curBrightness = [[UIScreen mainScreen] brightness];
    _curVoice = [MPMusicPlayerController applicationMusicPlayer].volume;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // **** 锁屏状态下，屏幕禁用
    if (_isLocked == YES) {
        return;
    }
    CGPoint curPoint = [[touches anyObject] locationInView:self.view];
    CGFloat deltaX = curPoint.x - _startPoint.x;
    CGFloat deltaY = curPoint.y - _startPoint.y;
    CGFloat totalWidth = self.view.frame.size.width;
    CGFloat totalHeight = self.view.frame.size.height;
    if (totalHeight == [[UIScreen mainScreen] bounds].size.height) {
        totalWidth = self.view.frame.size.height;
        totalHeight = self.view.frame.size.width;
    }
    NSInteger duration = (NSInteger)[(VideoViewController *)_delegate player].duration;
    if (fabs(deltaX) < fabs(deltaY)) {
        // **** 亮度
        if ((curPoint.x < totalWidth / 2) && (_gestureType == kKSYUnknown || _gestureType == kKSYBrightness)) {
            CGFloat deltaBright = deltaY / totalHeight * 1.0;
            [[UIScreen mainScreen] setBrightness:_curBrightness - deltaBright];
            UISlider *brightnessSlider = (UISlider *)[self.view viewWithTag:kBrightnessSliderTag];
            [brightnessSlider setValue:_curBrightness - deltaBright animated:NO];
            UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
            [brightnessSlider setThumbImage:dotImg forState:UIControlStateNormal];
            UIView *brightnessView = [self.view viewWithTag:kBrightnessViewTag];
            brightnessView.alpha = 1.0;
            _gestureType = kKSYBrightness;
        }
        // **** 声音
        else if (_gestureType == kKSYUnknown || _gestureType == kKSYVoice) {
            CGFloat deltaVoice = deltaY / totalHeight * 1.0;
            MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
            CGFloat voiceValue = _curVoice - deltaVoice;
            if (voiceValue < 0) {
                voiceValue = 0;
            }
            else if (voiceValue > 1) {
                voiceValue = 1;
            }
            [musicPlayer setVolume:voiceValue];
            MediaVoiceView *mediaVoiceView = (MediaVoiceView *)[self.view viewWithTag:kMediaVoiceViewTag];
            [mediaVoiceView setIVoice:voiceValue];
            _gestureType = kKSYVoice;
        }
        return ;
    }
    else if (duration > 0 && (_gestureType == kKSYUnknown || _gestureType == kKSYProgress)) {
        
        if (!_isPrepared) {
            return;
        }
        if (fabs(deltaX) > fabs(deltaY)) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
            if ([_delegate isPlaying] == YES) {
                [self clickPlayBtn:nil]; // **** 拖拽进度时，暂停播放
            }
            _gestureType = kKSYProgress;
            
            [self performSelector:@selector(showORhideProgressView:) withObject:@NO];
            CGFloat deltaProgress = deltaX / totalWidth * duration;
            UISlider *progressSlider = (UISlider *)[self.view viewWithTag:kProgressSliderTag];
            UIView *progressView = [self.view viewWithTag:kProgressViewTag];
            UILabel *progressViewCurLabel = (UILabel *)[self.view viewWithTag:kCurProgressLabelTag];
            UIImageView *wardImageView = (UIImageView *)[self.view viewWithTag:kWardMarkImgViewTag];
            UILabel *startLabel = (UILabel *)[self.view viewWithTag:kProgressCurLabelTag];
            NSInteger position = _curPosition + deltaProgress;
            if (position < 0) {
                position = 0;
            }
            else if (position > duration) {
                position = duration;
            }
            progressSlider.value = position;
            int iMin1  = ((int)labs(position) / 60);
            int iSec1  = ((int)labs(position) % 60);
            int iMin2  = ((int)fabs(deltaProgress) / 60);
            int iSec2  = ((int)fabs(deltaProgress) % 60);
            NSString *strCurTime1 = [NSString stringWithFormat:@"%02d:%02d/", iMin1, iSec1];
            NSString *strCurTime2 = [NSString stringWithFormat:@"%02d:%02d", iMin2, iSec2];
            startLabel.text = strCurTime1;
            if (deltaX > 0) {
                strCurTime2 = [@"+" stringByAppendingString:strCurTime2];
                UIImage *forwardImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_forward_normal"];
                wardImageView.frame = CGRectMake(progressView.frame.size.width - 30, 15, 20, 20);
                wardImageView.image = forwardImg;
            }
            else {
                strCurTime2 = [@"-" stringByAppendingString:strCurTime2];
                UIImage *backwardImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_backward_normal"];
                wardImageView.frame = CGRectMake(10, 15, 20, 20);
                wardImageView.image = backwardImg;
            }
            progressViewCurLabel.text = strCurTime2;
            UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
            [progressSlider setThumbImage:dotImg forState:UIControlStateNormal];
        }
    }
    else if (duration <= 0 && (_gestureType == kKSYUnknown || _gestureType == kKSYProgress)) {
        if (!_isPrepared) {
            return;
        }
        [self showNotice:@"直播不支持拖拽"];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_gestureType == kKSYUnknown) { // **** tap 动作
        if (_isActive == YES) {
            [self hideAllControls];
        }
        else {
            [self showAllControls];
        }
    }
    else if (_gestureType == kKSYProgress) {
        if (!_isPrepared) {
            return;
        }
        
        UISlider *progressSlider = (UISlider *)[self.view viewWithTag:kProgressSliderTag];
        if ([_delegate respondsToSelector:@selector(seekProgress:)] == YES) {
            [_delegate seekProgress:progressSlider.value];
        }
        UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
        [progressSlider setThumbImage:dotImg forState:UIControlStateNormal];
    }
    else if (_gestureType == kKSYBrightness) {
        UISlider *brightnessSlider = (UISlider *)[self.view viewWithTag:kBrightnessSliderTag];
        UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
        [brightnessSlider setThumbImage:dotImg forState:UIControlStateNormal];
        if (_isActive == NO) {
            UIView *brightnessView = [self.view viewWithTag:kBrightnessViewTag];
            [UIView animateWithDuration:0.3 animations:^{
                brightnessView.alpha = 0.0f;
            }];
        }
    }
    _gestureType = kKSYUnknown;
}

- (void)seekCompletedWithPosition:(CGFloat)position {
    UISlider *progressSlider = (UISlider *)[self.view viewWithTag:kProgressSliderTag];
    UIButton *btn = (UIButton *)[self.view viewWithTag:kBarPlayBtnTag];
    progressSlider.value = position;
    if (_isCompleted == YES) {
        _isCompleted = NO;
        UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
        [btn setImage:playImg forState:UIControlStateNormal];
    }
    else {

        KSYPlayer *player = [(VideoViewController *)_delegate player];
        if (_isKSYPlayerPling) {
            [player play];
        }else{
            _isKSYPlayerPling = NO;
            [player pause];
        }
        _isActive = YES;
        [self refreshControl];
    }
}

#pragma mark - KSYMediaPlayerDelegate

- (void)mediaPlayerStateChanged:(KSYPlayerState)PlayerState {
    
    if (PlayerState != KSYPlayerStateError) {
        [self removeError];
    }
    KSYPlayer *player = [(VideoViewController *)_delegate player];
    if (PlayerState == KSYPlayerStateInitialized) {
        _isPrepared = NO;
        [self showLoading];
    }else if (PlayerState == KSYPlayerStatePrepared){
        [self performSelectorOnMainThread:@selector(removeError) withObject:nil waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(removeLoading) withObject:nil waitUntilDone:NO];
    }
    UIButton *btn = (UIButton *)[self.view viewWithTag:kBarPlayBtnTag];
    UIImage *pauseImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_normal"];
    UIImage *pauseImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_hl"];
    UIImage *playImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
    UIImage *playImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_hl"];
    if (PlayerState == KSYPlayerStatePlaying) {
        [btn setImage:pauseImg_n forState:UIControlStateNormal];
        [btn setImage:pauseImg_h forState:UIControlStateHighlighted];
    }else if (PlayerState == KSYPlayerStatePaused || player.state == KSYPlayerStateStopped) {
        [btn setImage:playImg_n forState:UIControlStateNormal];
        [btn setImage:playImg_h forState:UIControlStateHighlighted];
    }
    if (PlayerState == KSYPlayerStatePrepared) {
        _isPrepared = YES;
    }
}

- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {
    //NSLog(@"time changed: %@", aNotification);
    
}

- (void)mediaPlayerCompleted:(KSYPlayer *)player {
//    NSLog(@"播放结束");
    _isCompleted = YES;
    [_delegate seekProgress:0.0];
    if ([(VideoViewController *)_delegate isCycleplay] == YES && _errorView.hidden == YES) {
        [_delegate play];
    }
    // **** 结果
//    [_timer invalidate];
//    UILabel *cpuLabel = (UILabel *)[self.view viewWithTag:kCPULabel];
//    UILabel *memLabel = (UILabel *)[self.view viewWithTag:kMemLabel];
//    cpuLabel.text = [NSString stringWithFormat:@"CPU: Min = %ld%% Max = %ld%% AVER = %ld%%", (long)_minCPU, (long)_maxCPU, (long)(_maxCPU + _minCPU) / 2];
//    memLabel.text = [NSString stringWithFormat:@"Mem: Min = %.1f MB Max = %.1f MB AVER = %.1f MB", _minMem, _maxMem, (_maxMem + _minMem) / 2]; // **** 15: 临时的偏移量
}

- (void)mediaPlayerWithError:(NSError *)error {
//    NSLog(@"error: %@", error);
    [self showError];
    [self removeLoading];
}

- (void)mediaPlayerBuffing:(KSYBufferingState)bufferingState {
    if (bufferingState == KSYPlayerBufferingStart) {
        [self showLoading];
    }
    else {
        [self performSelectorOnMainThread:@selector(removeLoading) withObject:nil waitUntilDone:NO];
    }
}

- (void)mediaPlayerSeekCompleted:(KSYPlayer *)player {
    CGFloat position = player.currentPlaybackTime;
    [self seekCompletedWithPosition:position];
}

#pragma mark - Helper

- (void)showAllControls {
    UIView *barView = [self.view viewWithTag:kBarViewtag];
    UIView *voiceView = [self.view viewWithTag:kVoiceViewTag];
    UIView *brightnessView = [self.view viewWithTag:kBrightnessViewTag];
    UIView *toolView = [self.view viewWithTag:kToolViewTag];
    UIView *lockView = (UIButton *)[self.view viewWithTag:kLockViewTag];
    [UIView animateWithDuration:0.3 animations:^{
        if (_isLocked == NO) {
            barView.alpha = 1.0;
            voiceView.alpha = 1.0;
            brightnessView.alpha = 1.0;
            toolView.alpha = 1.0;
        }
        lockView.alpha = 1.0;
    } completion:^(BOOL finished) {
        _isActive = YES;
        [self refreshControl];
    }];
}

- (void)hideAllControls {
    UIView *barView = [self.view viewWithTag:kBarViewtag];
    UIView *voiceView = [self.view viewWithTag:kVoiceViewTag];
    UIView *brightnessView = [self.view viewWithTag:kBrightnessViewTag];
    UIView *toolView = [self.view viewWithTag:kToolViewTag];
    UIView *qualityView = [self.view viewWithTag:kQualityViewTag];
    UIView *scaleView = [self.view viewWithTag:kScaleViewTag];
    UIView *lockView = [self.view viewWithTag:kLockViewTag];
    [UIView animateWithDuration:0.3 animations:^{
        if (_isLocked == NO) {
            barView.alpha = 0.0;
            voiceView.alpha = 0.0;
            brightnessView.alpha = 0.0;
            toolView.alpha = 0.0;
            qualityView.alpha = 0.0;
            scaleView.alpha = 0.0;
        }
        lockView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [qualityView removeFromSuperview];
        [scaleView removeFromSuperview];
        _isActive = NO;
    }];
}

- (void)showORhideProgressView:(NSNumber *)bShowORHide {
    UIView *progressView = [self.view viewWithTag:kProgressViewTag];
    progressView.hidden = bShowORHide.boolValue;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideProgressView) object:nil];
    if (!bShowORHide.boolValue) {
        [self performSelector:@selector(hideProgressView) withObject:nil afterDelay:1];
    }
}

- (void)hideProgressView {
    UIView *progressView = [self.view viewWithTag:kProgressViewTag];
    progressView.hidden = YES;
}

- (void)showNotice:(NSString *)strNotice {
    static BOOL isShowing = NO;
    if (isShowing == NO) {
        CGRect noticeRect = CGRectMake(0, 0, 150, 30);
        UIView *noticeView = [[UIView alloc] initWithFrame:noticeRect];
        noticeView.backgroundColor = [UIColor clearColor];
        UIView *bgView = [[UIView alloc] initWithFrame:noticeView.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 5;
        bgView.alpha = 0.6;
        [noticeView addSubview:bgView];
        
        UILabel *noticeLabel = [[UILabel alloc] initWithFrame:noticeView.bounds];
        noticeLabel.text = strNotice;
        noticeLabel.textAlignment = NSTextAlignmentCenter;
        noticeLabel.textColor = [UIColor whiteColor];
        [noticeView addSubview:noticeLabel];
        [self.view addSubview:noticeView];
        
        noticeView.center = self.view.center;
        if (self.view.frame.size.height == [[UIScreen mainScreen] bounds].size.height) {
            noticeView.center = CGPointMake(self.view.center.y, self.view.center.x);
        }
        
        [UIView animateWithDuration:1.0 animations:^{
            noticeView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [noticeView removeFromSuperview];
            isShowing = NO;
        }];
    }
}

#pragma mark - Player state

- (void)reSetLoadingViewFrame
{
    if (!_loadingView.hidden) {
        _loadingView.frame = self.view.bounds;
        UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[_loadingView viewWithTag:kLoadIndicatorViewTag];
        indicatorView.center = CGPointMake(_loadingView.center.x, _loadingView.center.y - 10);
        UILabel *indicatorLabel = (UILabel *)[_loadingView viewWithTag:kLoadIndicatorLabelTag];
        indicatorLabel.center = CGPointMake(_loadingView.center.x, _loadingView.center.y + 20);
    }
    if (!_errorView.hidden) {
        _errorView.frame = self.view.bounds;
        UILabel *indicatorLabel = (UILabel *)[_errorView viewWithTag:kErrorLabelTag];
        indicatorLabel.center = CGPointMake(_errorView.center.x, _errorView.center.y);
    }
}

- (void)showLoading {
    if (_loadingView == nil) {
        _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        _loadingView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_loadingView];
        [self.view sendSubviewToBack:_loadingView];
        
        // **** activity
        CGSize size = self.view.frame.size;
        if ((NSInteger)size.height == (NSInteger)[[UIScreen mainScreen] bounds].size.height) {
            CGFloat temp = size.width;
            size.width = size.height;
            size.height = temp;
        }
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.tag = kLoadIndicatorViewTag;
        _indicatorView.center = CGPointMake(_loadingView.center.x, _loadingView.center.y - 10);
        [_indicatorView startAnimating];
        [_loadingView addSubview:_indicatorView];
        
        CGRect labelRect = CGRectMake(0, 0, 100, 30);
        _indicatorLabel = [[UILabel alloc] initWithFrame:labelRect];
        _indicatorLabel.tag = kLoadIndicatorLabelTag;
        _indicatorLabel.text = @"加载中...";
        _indicatorLabel.textAlignment = NSTextAlignmentCenter;
        _indicatorLabel.textColor = [UIColor whiteColor];
        [_loadingView addSubview:_indicatorLabel];
    }
    _indicatorLabel.center = CGPointMake(_loadingView.center.x, _loadingView.center.y + 20);
    _loadingView.hidden = NO;
    [self reSetLoadingViewFrame];
}

- (void)removeLoading {
    _loadingView.hidden = YES;
}

- (void)showError {
    if (_errorView == nil) {
        _errorView = [[UIView alloc] initWithFrame:self.view.bounds];
        _errorView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_errorView];
        [self.view sendSubviewToBack:_errorView]; // **** 可以让视图返回
        
        // **** indicator
        CGSize size = self.view.frame.size;
        if ((NSInteger)size.height == (NSInteger)[[UIScreen mainScreen] bounds].size.height) {
            CGFloat temp = size.width;
            size.width = size.height;
            size.height = temp;
        }
        CGRect labelRect = CGRectMake(size.width / 2 - 50, size.height / 2 - 45, 100, 50);
        UILabel *indicatorLabel = [[UILabel alloc] initWithFrame:labelRect];
        indicatorLabel.tag = kErrorLabelTag;
        indicatorLabel.text = @":( 视频出错了，请重试！";
        indicatorLabel.textColor = [UIColor whiteColor];
        [_errorView addSubview:indicatorLabel];
    }
    _errorView.hidden = NO;
    [self reSetLoadingViewFrame];
}

- (void)removeError{
    _errorView.hidden = YES;
}

int count = 0;

- (void)retiveDrmKey:(NSString *)drmVersion player:(KSYPlayer *)player
{
    DrmRelativeModel *relativeModle = [DrmRelativeModel new];
    relativeModle.kscDrmHost = @"115.231.96.89:80";
    relativeModle.customName = @"service";
    relativeModle.drmMethod = @"GetCek";
    relativeModle.expire = @"1710333224";
    relativeModle.nonce = @"12341234";
    relativeModle.accessKeyId = @"2HITWMQXL2VBB3XMAEHQ";
//    relativeModle.signature = @"5iZ1rTfBjF/9v3U0k/1Pezx98RE=";
    relativeModle.cekVersion = drmVersion;
    [player setRelativeFullURLWithAccessKey:@"2HITWMQXL2VBB3XMAEHQ" secretKey:@"ilZQ9p/NHAK1dOYA/dTKKeIqT/t67rO6V2PrXUNr" drmRelativeModel:relativeModle];
//    [player setDrmKey:@"72" cek:@"123a9bd9af2aa4f85d84099d9e6b6be3"];
    count++;
}

// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

- (float) cpu_usage
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

@end
