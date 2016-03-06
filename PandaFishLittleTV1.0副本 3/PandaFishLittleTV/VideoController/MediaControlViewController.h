//
//  MediaControlViewController.h
//  KS3PlayerDemo
//
//  Created by Blues on 15/3/18.
//  Copyright (c) 2015年 KSY. All rights reserved.
//

enum KSYVideoQuality {
    kKSYVideoNormal = 0, // **** default
    kKSYVideoHight,
    kKSYVideoSuper,
};

enum KSYVideoScale {
    kKSYVideo16W9H = 0, // **** default
    kKSYVideo4W3H,
};

enum KSYGestureType {
    kKSYUnknown = 0,
    kKSYBrightness,
    kKSYVoice,
    kKSYProgress,
};

typedef enum KSYVideoQuality KSYVideoQuality;
typedef enum KSYVideoScale KSYVideoScale;
typedef enum KSYGestureType KSYGestureType;

#import <UIKit/UIKit.h>
#import "KSYPlayer.h"

@protocol KSYMediaPlayDelegate <NSObject>

@required
- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)isPlaying;
- (void)shutdown;

- (void)seekProgress:(CGFloat)position;
- (void)setVideoQuality:(KSYVideoQuality)videoQuality;
- (void)setVideoScale:(KSYVideoScale)videoScale;
- (void)setAudioAmplify:(CGFloat)amplify;

@end

@class MediaControlViewController;
@protocol backAndExitDelegate <NSObject>

- (void)exit:(MediaControlViewController *)viewController;

@end
@interface MediaControlViewController : UIViewController <KSYMediaPlayerDelegate>

@property (nonatomic, weak) id<KSYMediaPlayDelegate> delegate;
@property (nonatomic, weak) id<backAndExitDelegate> exitDelegate;
- (void)clickPlayBtn:(id)sender;
- (void)clickQualityBtn:(id)sender;
- (void)clickHighlightBtn:(id)sender;
- (void)clickNormalBtn:(id)sender;
- (void)progressChanged:(id)sender;
- (void)progressDidBegin:(id)slider;
- (void)progressChangeEnd:(id)sender;
- (void)brightnessChanged:(id)sender;
- (void)brightnessDidBegin:(id)sender;
- (void)brightnessChangeEnd:(id)sender;
- (void)voiceChanged:(id)sender;
- (void)clickFullBtn:(id)sender;
- (void)clickExitBtn:(id)sender;
- (void)clickScaleBtn:(id)sender;
- (void)clickEpisodeBtn:(id)sender;
- (void)clickSnapBtn:(id)sender;
- (void)clickLockBtn:(id)sender;
- (void)clickSoundOff:(UITapGestureRecognizer *)tapGesture;
- (void)showLoading;
- (void)reSetLoadingViewFrame;

@end
