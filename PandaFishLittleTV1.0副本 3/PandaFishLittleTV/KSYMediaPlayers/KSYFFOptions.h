//
//  KSYFFOptions.h
//  KSYMediaPlayer
//
//  Created by  on 13-10-17.
//  Copyright (c) 2013年 bilibili. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum KSYAVDiscard{
    /* We leave some space between them for extensions (drop some
     * keyframes for intra-only or drop just some bidir frames). */
    KSY_AVDISCARD_NONE    =-16, ///< discard nothing
    KSY_AVDISCARD_DEFAULT =  0, ///< discard useless packets like 0 size packets in avi
    KSY_AVDISCARD_NONREF  =  8, ///< discard all non reference
    KSY_AVDISCARD_BIDIR   = 16, ///< discard all bidirectional frames
    KSY_AVDISCARD_NONKEY  = 32, ///< discard all frames except keyframes
    KSY_AVDISCARD_ALL     = 48, ///< discard all
} KSYAVDiscard;

typedef struct KSYMediaPlayer KSYMediaPlayer;

@interface KSYFFOptions : NSObject

+ (KSYFFOptions *)optionsByDefault;

- (void)applyTo:(KSYMediaPlayer *)mediaPlayer;

@property(nonatomic) KSYAVDiscard skipLoopFilter;

@property(nonatomic) KSYAVDiscard skipFrame;

@property(nonatomic) int frameBufferCount;

@property(nonatomic) int maxFps;

@property(nonatomic) int frameDrop;

@property(nonatomic) BOOL pauseInBackground;

@property(nonatomic, strong) NSString* userAgent;

@property(nonatomic) int64_t timeout; ///< read/write timeout, -1 for infinite, in microseconds

@end
