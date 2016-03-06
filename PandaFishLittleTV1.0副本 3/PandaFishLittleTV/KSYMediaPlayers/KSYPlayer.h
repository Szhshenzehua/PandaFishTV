//
//  KSYPlayer.h
//  KSYMediaPlayer
//
//  Created by JackWong on 15/3/23.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSYMediaPlayback.h"
#import "KSYFFOptions.h"
#import "DrmRelativeModel.h"
#import "DrmRelativeAllModel.h"

#define kk_KSYM_VAL_TYPE__UNKNOWN  @"unknown"

#define kk_KSYM_KEY_STREAMS       @"streams"

typedef NS_ENUM(NSInteger, KSYPlayerState)
{
    KSYPlayerStateError,          //< Player has generated an error
    KSYPlayerStateIdle,
    KSYPlayerStateInitialized,
    KSYPlayerStatePreparing,
    KSYPlayerStatePrepared,
    KSYPlayerStatePlaying,        //< Stream is playing
    KSYPlayerStatePaused,         //< Stream is paused
    KSYPlayerStateCompleted,
    KSYPlayerStateStopped,        //< Player has stopped
    KSYPlayerStateSeekingForward
};

typedef NS_ENUM(NSInteger, KSYBufferingState)
{
    KSYPlayerBufferingStart,
    KSYPlayerBufferingEnd
};

@protocol KSYMediaPlayerDelegate;

extern NSString *const KSYMediaPlayerStateChanged;

extern NSString *const KSYMediaPlayerWithError;

@interface KSYPlayer : NSObject <KSYMediaPlayback>

@property (NS_NONATOMIC_IOSONLY, readonly)  UIView *videoView;

@property (NS_NONATOMIC_IOSONLY, weak) id<KSYMediaPlayerDelegate> delegate;

@property (NS_NONATOMIC_IOSONLY) NSTimeInterval currentPlaybackTime;

@property (NS_NONATOMIC_IOSONLY, readonly) NSTimeInterval duration;

@property (NS_NONATOMIC_IOSONLY, readonly) NSTimeInterval playableDuration;

@property (NS_NONATOMIC_IOSONLY, readonly) NSInteger bufferingProgress;

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL isPreparedToPlay;

@property (NS_NONATOMIC_IOSONLY, readonly) KSYPlayerState state;

@property (NS_NONATOMIC_IOSONLY, readonly) NSDictionary *mediaMeta;

@property (NS_NONATOMIC_IOSONLY, readonly) MPMovieLoadState loadState;

@property (NS_NONATOMIC_IOSONLY, readonly) int64_t numberOfBytesTransferred;

@property (NS_NONATOMIC_IOSONLY, readonly) NSInteger videoWidth;

@property (NS_NONATOMIC_IOSONLY, readonly) NSInteger videoHeight;

@property (NS_NONATOMIC_IOSONLY) MPMovieControlStyle controlStyle;

@property (NS_NONATOMIC_IOSONLY) MPMovieScalingMode scalingMode;

@property (NS_NONATOMIC_IOSONLY) BOOL shouldAutoplay;

@property (NS_NONATOMIC_IOSONLY, readonly) CGFloat fpsInMeta;

@property (NS_NONATOMIC_IOSONLY, readonly) CGFloat fpsAtOutput;


- (id)initWithMURL:(NSURL *)mUrl withOptions:(KSYFFOptions *)options;

#pragma mark ---mark PlayerControl

- (void)play;

- (void)pause;

- (void)stop;

- (BOOL)isPlaying;

- (void)reset;

- (void)shutdown;

- (void)prepareToPlay;

- (void)seekTo:(long)msec;

- (void)setKSYPlayerVolume:(float)volume;

- (void)setKSYPlayerBrightness:(float)brightness;
/**
 *  The interception of the current video frame
 *
 *  @return a image
 */
- (UIImage *)thumbnailImageAtCurrentTime;
/**
 *  设置音频放大
 *
 *  @param amplify 音频放大比率
 */
- (void)setAudioAmplify:(float)amplify;
/**
 *  设置速率快放倍数
 *
 *  @param value 
 */
- (void)setRate:(float)value;

- (void)setAnalyzeduration:(int)duration;
/**
 *  <#Description#>
 *
 *  @param size <#size description#>
 */
- (void)setPlayerBuffersize:(int)size;
/**
 *  <#Description#>
 *
 *  @param localpath <#localpath description#>
 */
- (void)saveVideoLocalPath:(NSString *)localpath;

- (void)setDrmKey:(NSString *)drmVersion cek:(NSString *)cek;

- (void)setRelativeFullURL:(DrmRelativeAllModel *)drmRelativeAllModel;

- (void)setRelativeFullURLWithAccessKey:(NSString *)accessKey
                              secretKey:(NSString *)secretKey drmRelativeModel:(DrmRelativeModel *)drmRelativeModel;

@end
/**
 *  KSYMediaPlayerDelegate
 */
@protocol KSYMediaPlayerDelegate <NSObject>

@optional

- (void)mediaPlayerStateChanged:(KSYPlayerState)PlayerState;

- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification;

- (void)mediaPlayerWithError:(NSError *)error;

- (void)mediaPlayerCompleted:(KSYPlayer *)player;

- (void)mediaPlayerBuffing:(KSYBufferingState)bufferingState;

- (void)mediaPlayerSeekCompleted:(KSYPlayer *)player;

- (void)retiveDrmKey:(NSString *)drmVersion player:(KSYPlayer *)player;

@end

