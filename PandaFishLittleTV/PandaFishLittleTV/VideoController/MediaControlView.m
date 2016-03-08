//
//  MediaControlView.m
//  KS3PlayerDemo
//
//  Created by Blues on 15/3/24.
//  Copyright (c) 2015年 KSY. All rights reserved.
//

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define kTopBarHeight (40 * SCREEN_WIDTH / 320)
#define kBottomBarHeight 58
#define kCoverBarHeight 140
#define kCoverBarLeftMargin 20
#define kCoverBarRightMargin 20
#define kCoverBarTopMargin 48
#define kCoverBarBottomMargin 42
#define kCoverLockViewLeftMargin 68
#define kCoverLockViewBgWidth 40
#define kCoverLockWidth 30
#define kCoverBarWidth 25
#define kProgressViewWidth 150

#import "MediaControlView.h"
#import "MediaControlDefine.h"
#import "MediaControlViewController.h"
#import "ThemeManager.h"
#import "MediaVoiceView.h"
#import "KSYBarView.h"

@implementation MediaControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CGSize size = frame.size;
        UIColor *tintColor = [[ThemeManager sharedInstance] themeColor];
        
        // **** UI elements
        CGRect barRect = CGRectMake(0, size.height - kBottomBarHeight, size.width, kBottomBarHeight);
        KSYBarView *barView = [[KSYBarView alloc] initWithFrame:barRect];
        barView.backgroundColor = [UIColor clearColor];
        barView.tag = kBarViewtag;
        [self addSubview:barView];
        
        UIView *barBgView = [[UIView alloc] initWithFrame:barView.bounds];
        barBgView.backgroundColor = [UIColor blackColor];
        barBgView.alpha = 0.6f;
        barBgView.tag = kBarBgViewTag;
        [barView addSubview:barBgView];
        
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playBtn.alpha = 0.6;
        UIImage *pauseImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_normal"];
        UIImage *pauseImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_hl"];
        [playBtn setImage:pauseImg_n forState:UIControlStateNormal];
        [playBtn setImage:pauseImg_h forState:UIControlStateHighlighted];
        playBtn.frame = CGRectMake(10, 5, 53, 53);
        playBtn.tag = kBarPlayBtnTag;
        [playBtn addTarget:_controller action:@selector(clickPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:playBtn];
        
        CGRect startLabelRect = CGRectMake(45, 25, 55, 15);
        UILabel *startLabel = [[UILabel alloc] initWithFrame:startLabelRect];
        startLabel.text = @"00:00";
        startLabel.textAlignment = NSTextAlignmentRight;
        startLabel.font = [UIFont boldSystemFontOfSize:13];
        startLabel.textColor = tintColor;
        startLabel.tag = kProgressCurLabelTag;
        [barView addSubview:startLabel];
        
        CGRect progressSliderRect = CGRectMake(0, 0, size.width, 10);
        UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
        UIImage *minImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"slider_color"];
        UISlider *progressSlider = [[UISlider alloc] initWithFrame:progressSliderRect];
        [progressSlider setMinimumTrackImage:minImg forState:UIControlStateNormal];
        progressSlider.maximumTrackTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
        [progressSlider setThumbImage:dotImg forState:UIControlStateNormal];
        [progressSlider addTarget:_controller action:@selector(progressDidBegin:) forControlEvents:UIControlEventTouchDown];
        [progressSlider addTarget:_controller action:@selector(progressChanged:) forControlEvents:UIControlEventValueChanged];
        [progressSlider addTarget:_controller action:@selector(progressChangeEnd:) forControlEvents:(UIControlEventTouchUpOutside | UIControlEventTouchCancel|UIControlEventTouchUpInside)];
        progressSlider.value = 0.0;
        progressSlider.tag = kProgressSliderTag;
        [barView addSubview:progressSlider];
        
        CGRect endLabelRect = CGRectMake(45 + 55, 25, 55, 15);
        UILabel *endLabel = [[UILabel alloc] initWithFrame:endLabelRect];
        endLabel.alpha = 0.6;
        endLabel.text = @"/00:00";
        endLabel.font = [UIFont boldSystemFontOfSize:13];
        endLabel.textColor = [UIColor whiteColor];
        endLabel.tag = kProgressMaxLabelTag;
        [barView addSubview:endLabel];
        
//        UIButton *qualityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        qualityBtn.alpha = 0.6f;
//        qualityBtn.hidden = YES;
//        qualityBtn.frame = CGRectMake(size.width - 210, 20, 50, 25);
//        qualityBtn.tag = kQualityBtnTag;
//        qualityBtn.layer.masksToBounds = YES;
//        qualityBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        qualityBtn.layer.borderWidth = 0.5;
//        qualityBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//        [qualityBtn setTitle:@"流畅" forState:UIControlStateNormal];
//        [qualityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [qualityBtn setTitleColor:tintColor forState:UIControlStateHighlighted];
//        [qualityBtn addTarget:_controller action:@selector(clickQualityBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [qualityBtn addTarget:_controller action:@selector(clickNormalBtn:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchDragOutside];
//        [qualityBtn addTarget:_controller action:@selector(clickHighlightBtn:) forControlEvents:UIControlEventTouchDown];
//        [barView addSubview:qualityBtn];
        
//        UIButton *scaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        scaleBtn.alpha = 0.6;
//        scaleBtn.hidden = YES;
//        scaleBtn.frame = CGRectMake(size.width - 140, 25, 50, 25);
//        scaleBtn.tag = kScaleBtnTag;
//        scaleBtn.layer.masksToBounds = YES;
//        scaleBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        scaleBtn.layer.borderWidth = 0.5;
//        scaleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//        [scaleBtn setTitle:@"16:9" forState:UIControlStateNormal];
//        [scaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [scaleBtn setTitleColor:tintColor forState:UIControlStateHighlighted];
//        [scaleBtn addTarget:_controller action:@selector(clickScaleBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [scaleBtn addTarget:_controller action:@selector(clickNormalBtn:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchDragOutside];
//        [scaleBtn addTarget:_controller action:@selector(clickHighlightBtn:) forControlEvents:UIControlEventTouchDown];
//        [barView addSubview:scaleBtn];
        
//        UIButton *episodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        episodeBtn.alpha = 0.6;
//        episodeBtn.hidden = YES;
//        episodeBtn.frame = CGRectMake(size.width - 70, 25, 50, 25);
//        episodeBtn.tag = kEpisodeBtnTag;
//        episodeBtn.layer.masksToBounds = YES;
//        episodeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        episodeBtn.layer.borderWidth = 0.5;
//        episodeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//        [episodeBtn setTitle:@"剧集" forState:UIControlStateNormal];
//        [episodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [episodeBtn setTitleColor:tintColor forState:UIControlStateHighlighted];
//        [episodeBtn addTarget:_controller action:@selector(clickEpisodeBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [episodeBtn addTarget:_controller action:@selector(clickNormalBtn:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchDragOutside];
//        [episodeBtn addTarget:_controller action:@selector(clickHighlightBtn:) forControlEvents:UIControlEventTouchDown];
//        [barView addSubview:episodeBtn];
        
        CGRect fullBtnRect = CGRectMake(size.width - 40, 15, 30, 30);
        UIButton *fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fullBtn.alpha = 0.6;
        UIImage *fullImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_fullscreen_normal"];
        [fullBtn setImage:fullImg forState:UIControlStateNormal];
        fullBtn.frame = fullBtnRect;
        fullBtn.tag = kFullScreenBtnTag;
        [fullBtn addTarget:_controller action:@selector(clickFullBtn:) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:fullBtn];
        
        // **** progress view
        CGRect progressRect = CGRectMake((size.width - kProgressViewWidth) / 2, (size.height - 50) / 2, kProgressViewWidth, 50);
        UIView *progressView = [[UIView alloc] initWithFrame:progressRect];
        progressView.backgroundColor = [UIColor clearColor];
        progressView.tag = kProgressViewTag;
        progressView.hidden = YES;
        [self addSubview:progressView];
        
        UIView *progressBgView = [[UIView alloc] initWithFrame:progressView.bounds];
        progressBgView.backgroundColor = [UIColor blackColor];
        progressBgView.layer.masksToBounds = YES;
        progressBgView.layer.cornerRadius = 5;
        progressBgView.alpha = 0.7;
        [progressView addSubview:progressBgView];
        
        CGRect curProgressLabelRect = CGRectMake(0, 0, progressRect.size.width, 50);
        UILabel *curProgressLabel = [[UILabel alloc] initWithFrame:curProgressLabelRect];
        curProgressLabel.alpha = 0.6f;
        curProgressLabel.tag = kCurProgressLabelTag;
        curProgressLabel.text = @"00:00";
        curProgressLabel.font = [UIFont boldSystemFontOfSize:20];
        curProgressLabel.textAlignment = NSTextAlignmentCenter;
        curProgressLabel.textColor = [UIColor whiteColor];
        [progressView addSubview:curProgressLabel];
        
        CGRect wardImgViewRect = CGRectMake(10, 15, 20, 20);
        UIImageView *wardImgView = [[UIImageView alloc] initWithFrame:wardImgViewRect];
        wardImgView.alpha = 0.6f;
        UIImage *forwardImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_forward_normal"];
        wardImgView.image = forwardImg;
        wardImgView.tag =kWardMarkImgViewTag;
        [progressView addSubview:wardImgView];
        
        // **** brightness view
        CGRect brightnessRect = CGRectMake(kCoverBarLeftMargin, size.height / 4, kCoverBarWidth, size.height / 2);
        UIView *brightnessView = [[UIView alloc] initWithFrame:brightnessRect];
        brightnessView.backgroundColor = [UIColor clearColor];
        brightnessView.layer.masksToBounds = YES;
        brightnessView.layer.cornerRadius = 3;
        brightnessView.tag = kBrightnessViewTag;
        brightnessView.hidden = YES; // **** at first in portrait orientation, it's hidden
        [self addSubview:brightnessView];
        
        UIView *brightnessBgView = [[UIView alloc] initWithFrame:brightnessView.bounds];
        brightnessBgView.backgroundColor = [UIColor blackColor];
        brightnessBgView.alpha = 0.6f;
        [brightnessView addSubview:brightnessBgView];
        
        CGRect brightnessImgViewRect1 = CGRectMake(3, 3, kCoverBarWidth - 6, kCoverBarWidth - 6);
        UIImageView *brightnessImgView1 = [[UIImageView alloc] initWithFrame:brightnessImgViewRect1];
        UIImage *brightnessImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"brightness"];
        brightnessImgView1.image = brightnessImg;
        [brightnessView addSubview:brightnessImgView1];
        
        CGFloat sliderWidth = brightnessRect.size.height - 45;
        CGFloat sliderHeight = 15;
        CGFloat X = -sliderWidth / 2 + brightnessRect.size.width / 2;
        CGFloat Y = brightnessRect.size.height / 2 - sliderHeight / 2 + 4;
        CGRect brightnessSliderRect = CGRectMake(X, Y, sliderWidth, sliderHeight);
        UISlider *brightnessSlider = [[UISlider alloc] initWithFrame:brightnessSliderRect];
        [brightnessSlider setMinimumTrackImage:minImg forState:UIControlStateNormal];
        brightnessSlider.maximumTrackTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
        [brightnessSlider setThumbImage:dotImg forState:UIControlStateNormal];
        brightnessSlider.value = [[UIScreen mainScreen] brightness];
        brightnessSlider.tag = kBrightnessSliderTag;
        [brightnessSlider addTarget:_controller action:@selector(brightnessChanged:) forControlEvents:UIControlEventValueChanged];
        [brightnessSlider addTarget:_controller action:@selector(brightnessDidBegin:) forControlEvents:UIControlEventTouchDown];
        [brightnessSlider addTarget:_controller action:@selector(brightnessChangeEnd:) forControlEvents:(UIControlEventTouchUpOutside | UIControlEventTouchCancel|UIControlEventTouchUpInside)];
        [brightnessView addSubview:brightnessSlider];
        brightnessSlider.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
        CGFloat low_brightness = kCoverBarWidth - 10;
        CGRect brightnessImgViewRect2 = CGRectMake(5, brightnessRect.size.height - low_brightness - 3, low_brightness, low_brightness);
        UIImageView *brightnessImgView2 = [[UIImageView alloc] initWithFrame:brightnessImgViewRect2];
        brightnessImgView2.image = brightnessImg;
        [brightnessView addSubview:brightnessImgView2];
        
        // **** video lock
        CGRect lockViewRect = CGRectMake(kCoverLockViewLeftMargin, (size.height - size.height / 6) / 2, size.height / 6, size.height / 6);
        UIView *lockView = [[UIView alloc] initWithFrame:lockViewRect];
        lockView.tag = kLockViewTag;
        lockView.hidden = YES; // **** hidden at first
        lockView.backgroundColor = [UIColor clearColor];
        [self addSubview:lockView];
        
        UIView *lockBgView = [[UIView alloc] initWithFrame:lockView.bounds];
        lockBgView.backgroundColor = [UIColor blackColor];
        lockBgView.layer.masksToBounds = YES;
        lockBgView.layer.cornerRadius = lockViewRect.size.width / 2;
        lockBgView.alpha = 0.6f;
        [lockView addSubview:lockBgView];

        UIButton *lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lockBtn.alpha = 0.6f;
        lockBtn.frame = CGRectMake(10, 10, lockViewRect.size.width - 20, lockViewRect.size.width - 20);
        UIImage *lockOpenImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_lock_open_normal"];
        UIImage *lockOpenImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_lock_open_hl"];
        [lockBtn setImage:lockOpenImg_n forState:UIControlStateNormal];
        [lockBtn setImage:lockOpenImg_h forState:UIControlStateHighlighted];
        [lockBtn addTarget:_controller action:@selector(clickLockBtn:) forControlEvents:UIControlEventTouchUpInside];
        [lockView addSubview:lockBtn];
        
        // **** voice view
        CGRect voiceRect = CGRectMake(size.width - kCoverBarWidth - kCoverBarRightMargin, size.height / 4, kCoverBarWidth, size.height / 2);
        UIView *voiceView = [[UIView alloc] initWithFrame:voiceRect];
        voiceView.backgroundColor = [UIColor clearColor];
        voiceView.layer.masksToBounds = YES;
        voiceView.layer.cornerRadius = 3;
        voiceView.tag = kVoiceViewTag;
        voiceView.hidden = YES; // **** at first in portrait orientation, it's hidden
        [self addSubview:voiceView];
        
        UIView *voiceBgView = [[UIView alloc] initWithFrame:voiceView.bounds];
        voiceBgView.backgroundColor = [UIColor blackColor];
        voiceBgView.alpha = 0.6f;
        [voiceView addSubview:voiceBgView];
        
        CGFloat voiceImgWidth = kCoverBarWidth - 8;
        UIImage *voiceMinImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"voice_min"];
        CGRect voiceImgViewRect1 = CGRectMake(4, brightnessRect.size.height - voiceImgWidth - 4, voiceImgWidth, voiceImgWidth);
        UIButton *voiceMinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [voiceMinBtn setImage:voiceMinImg forState:UIControlStateNormal];
        voiceMinBtn.frame = voiceImgViewRect1;
        [voiceMinBtn addTarget:_controller action:@selector(clickSoundOff:) forControlEvents:UIControlEventTouchUpInside];
        [voiceView addSubview:voiceMinBtn];
        
        CGRect mediaVoiceRect = CGRectMake(4, 25, kCoverBarWidth - 10, voiceRect.size.height - 25 * 2);
        MediaVoiceView *mediaVoiceView = [[MediaVoiceView alloc] initWithFrame:mediaVoiceRect];
        mediaVoiceView.tag = kMediaVoiceViewTag;
        [mediaVoiceView setFillColor:[[ThemeManager sharedInstance] themeColor]];
        [mediaVoiceView setIVoice:[MPMusicPlayerController applicationMusicPlayer].volume];
        [voiceView addSubview:mediaVoiceView];
        
        CGRect voiceImgViewRect2 = voiceImgViewRect1;//CGRectMake(2, 0, 20, 20);
        voiceImgViewRect2.origin.y = 4;
        UIImageView *voiceImgView2 = [[UIImageView alloc] initWithFrame:voiceImgViewRect2];
        UIImage *voiceMaxImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"voice_max"];
        voiceImgView2.image = voiceMaxImg;
        [voiceView addSubview:voiceImgView2];
        
        // **** tool view
        CGRect toolViewRect = CGRectMake(0, 0, size.width, kTopBarHeight);
        KSYBarView *toolView = [[KSYBarView alloc] initWithFrame:toolViewRect];
        toolView.backgroundColor = [UIColor clearColor];
        toolView.tag = kToolViewTag;
        toolView.hidden = YES; // **** hidden at first, and in the portrait orientation
        [self addSubview:toolView];
        
        UIView *bgToolView = [[UIView alloc] initWithFrame:toolView.bounds];
        bgToolView.backgroundColor = [UIColor blackColor];
        bgToolView.tag = kToolBgViewTag;
        bgToolView.alpha = 0.6;
        [toolView addSubview:bgToolView];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(10, (kTopBarHeight - 22) / 2, 80, 22);
        UIImage *backImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_back_normal"];
        UIImage *backImg_hl = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_back_hl"];
        [backBtn setImage:backImg forState:UIControlStateNormal];
        [backBtn setImage:backImg_hl forState:UIControlStateHighlighted];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 55);
        backBtn.titleEdgeInsets = UIEdgeInsetsMake(9, -38, 10, 0);
        [backBtn addTarget:_controller action:@selector(clickExitBtn:) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:backBtn];
        
        CGRect snapBtnRect = CGRectMake(size.width - 40, (kTopBarHeight - 30) / 2, 30, 30);
        UIButton *snapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        snapBtn.alpha = 0.6;
        snapBtn.frame = snapBtnRect;
        snapBtn.tag = kSnapBtnTag;
        UIImage *screenshotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_snapshot_normal"];
        UIImage *screenshotImg_hl = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_snapshot_hl"];
        [snapBtn setImage:screenshotImg forState:UIControlStateNormal];
        [snapBtn setImage:screenshotImg_hl forState:UIControlStateHighlighted];
        [snapBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [snapBtn addTarget:_controller action:@selector(clickSnapBtn:) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:snapBtn];
        
        // **** cpu, memory
//        UILabel *cpuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 20)];
//        cpuLabel.backgroundColor = [UIColor clearColor];
//        cpuLabel.textColor = [UIColor whiteColor];
//        cpuLabel.tag = kCPULabel;
//        [self addSubview:cpuLabel];
//        
//        UILabel *memLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 480, 20)];
//        memLabel.backgroundColor = [UIColor clearColor];
//        memLabel.textColor = [UIColor whiteColor];
//        memLabel.tag = kMemLabel;
//        [self addSubview:memLabel];
    }
    return self;
}
- (void)updateSubviewsLocation {
    UIView *voiceBarView = [self viewWithTag:kVoiceViewTag];
    UIView *brightnessBarView = [self viewWithTag:kBrightnessViewTag];
    UIView *toolView = [self viewWithTag:kToolViewTag];
    UIView *lockView = [self viewWithTag:kLockViewTag];
    
    CGSize size = self.frame.size;
    [self updateProgressView];
    [self updateBarView];
    [self updateToolView];
    [self updateLockBtn];
    [self updateInfoLabel];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (size.height == screenSize.height / 2) {
        voiceBarView.hidden = YES;
        brightnessBarView.hidden = YES;
        toolView.hidden = YES;
        lockView.hidden = YES;
    }
    else {
        CGSize voiceBarViewSize = voiceBarView.frame.size;
        brightnessBarView.center = CGPointMake(kCoverBarLeftMargin + kCoverBarWidth / 2, (screenSize.width - voiceBarViewSize.width) / 2);
        voiceBarView.center = CGPointMake(screenSize.height - (kCoverBarRightMargin + kCoverBarWidth / 2), (screenSize.width - voiceBarViewSize.width) / 2);
        voiceBarView.hidden = NO;
        brightnessBarView.hidden = NO;
        toolView.hidden = NO;
        lockView.hidden = NO;
    }
}

- (void)updateLockBtn {
    UIButton *lockBtn = (UIButton *)[self viewWithTag:kLockViewTag];
    CGSize size = self.frame.size;
    if ((NSInteger)size.height == (NSInteger)[[UIScreen mainScreen] bounds].size.height) {
        CGFloat temp = size.width;
        size.width = size.height;
        size.height = temp;
    }
    lockBtn.frame = CGRectMake(kCoverLockViewLeftMargin, (size.height - size.height / 6) / 2, size.height / 6, size.height / 6);//CGRectMake(size.width / 2 - 150, (size.height - 50) / 2, 40, 40);
}

- (void)updateProgressView {
    UIView *progressView = [self viewWithTag:kProgressViewTag];
    CGSize size = self.frame.size;
    if ((NSInteger)size.height == (NSInteger)[[UIScreen mainScreen] bounds].size.height) {
        CGFloat temp = size.width;
        size.width = size.height;
        size.height = temp;
    }
    CGRect progressRect = CGRectMake((size.width - 150) / 2, (size.height - 50) / 2, 150, 50);
    progressView.frame = progressRect;
}

- (void)updateBarView {
    CGSize size = self.frame.size;
    BOOL isLandscape = NO;
    if ((NSInteger)size.height == (NSInteger)[[UIScreen mainScreen] bounds].size.height) {
        CGFloat temp = size.width;
        size.width = size.height;
        size.height = temp;
        isLandscape = YES;
    }
    
    UIView *barView = [self viewWithTag:kBarViewtag];
    UIView *barBgView = [self viewWithTag:kBarBgViewTag];
    UIButton *fullBtn = (UIButton *)[self viewWithTag:kFullScreenBtnTag];
    UISlider *slider = (UISlider *)[self viewWithTag:kProgressSliderTag];
    UILabel *startLabel = (UILabel *)[self viewWithTag:kProgressCurLabelTag];
    UILabel *endLabel = (UILabel *)[self viewWithTag:kProgressMaxLabelTag];
    UIButton *qualityBtn = (UIButton *)[self viewWithTag:kQualityBtnTag];
    UIButton *scaleBtn = (UIButton *)[self viewWithTag:kScaleBtnTag];
    UIButton *episodeBtn = (UIButton *)[self viewWithTag:kEpisodeBtnTag];
    CGRect barRect = CGRectMake(0, size.height - kBottomBarHeight, size.width, kBottomBarHeight);
    CGRect fullRect = CGRectMake(size.width - 40, 15, 30, 30);
    CGRect sliderRect = CGRectMake(0, -2, size.width, 10);
    CGRect startLabelRect = CGRectMake(45, 25, 55, 15);
    CGRect endLabelRect = CGRectMake(45 + 55, 25, 55, 15);
    CGRect qualityBtnRect = CGRectMake(size.width - 210, 20, 50, 25);
    CGRect scaleBtnRect = CGRectMake(size.width - 140, 20, 50, 25);
    CGRect episodeBtnRect = CGRectMake(size.width - 70, 20, 50, 25);
    if (isLandscape == YES) {
        fullBtn.hidden = YES;
        qualityBtn.hidden = NO;
        scaleBtn.hidden = NO;
        episodeBtn.hidden = NO;
    }
    else {
        fullBtn.hidden = NO;
        qualityBtn.hidden = YES;
        scaleBtn.hidden = YES;
        episodeBtn.hidden = YES;
    }
    barView.frame = barRect;
    fullBtn.frame = fullRect;
    slider.frame = sliderRect;
    startLabel.frame = startLabelRect;
    endLabel.frame = endLabelRect;
    qualityBtn.frame = qualityBtnRect;
    scaleBtn.frame = scaleBtnRect;
    episodeBtn.frame = episodeBtnRect;
    barBgView.frame = barView.bounds;
    UIImage *fullImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_fullscreen_normal"];
    [fullBtn setImage:fullImg forState:UIControlStateNormal];
    [scaleBtn setTitle:@"16:9" forState:UIControlStateNormal];
}

- (void)updateToolView {
    CGSize size = self.frame.size;
    
    if ((NSInteger)size.height == (NSInteger)[[UIScreen mainScreen] bounds].size.height) {
        CGFloat temp = size.width;
        size.width = size.height;
        size.height = temp;
    }
    
    UIView *toolView = [self viewWithTag:kToolViewTag];
    UIView *bgToolView = [toolView viewWithTag:kToolBgViewTag];
    UIButton *snapBtn = (UIButton *)[toolView viewWithTag:kSnapBtnTag];
    CGRect toolRect = CGRectMake(0, 0, size.width, kTopBarHeight);
    toolView.frame = toolRect;
    bgToolView.frame = toolView.bounds;
    CGRect snapBtnRect = CGRectMake(size.width - 40, (kTopBarHeight - 30) / 2, 30, 30);
    snapBtn.frame = snapBtnRect;
}

- (void)updateInfoLabel {
    CGSize size = self.frame.size;
    
    if ((NSInteger)size.height == (NSInteger)[[UIScreen mainScreen] bounds].size.height) {
        CGFloat temp = size.width;
        size.width = size.height;
        size.height = temp;
    }
    
    UILabel *cpuLabel = (UILabel *)[self viewWithTag:kCPULabel];
    UILabel *memLabel = (UILabel *)[self viewWithTag:kMemLabel];
    cpuLabel.frame = CGRectMake(0, 0, 480, 20);
    memLabel.frame = CGRectMake(0, 30, 480, 20);
}

@end
