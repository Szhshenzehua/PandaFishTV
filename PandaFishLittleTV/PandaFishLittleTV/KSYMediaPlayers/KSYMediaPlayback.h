/*
 * KSYMediaPlayback.h
 *
 * Copyright (c) 2013 
 *
 * This file is part of ksyPlayer.
 *
 * ksyPlayer is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * ksyPlayer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with ksyPlayer; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@protocol KSYMediaPlayback;


#pragma mark KSYMediaPlayback

@protocol KSYMediaPlayback <NSObject>


#pragma mark Notifications

#ifdef __cplusplus
#define KSY_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define KSY_EXTERN extern __attribute__((visibility ("default")))
#endif

//KSY_EXTERN NSString *const KSYMediaPlaybackIsPreparedToPlayDidChangeNotification;
//KSY_EXTERN NSString *const KSYMoviePlayerLoadStateDidChangeNotification;
//KSY_EXTERN NSString *const KSYMoviePlayerPlaybackDidFinishNotification;
//KSY_EXTERN NSString *const KSYMoviePlayerPlaybackStateDidChangeNotification;

@end

#pragma mark KSYMediaResource

@protocol KSYMediaSegmentResolver <NSObject>

- (NSString *)urlOfSegment:(int)segmentPosition;

@end
