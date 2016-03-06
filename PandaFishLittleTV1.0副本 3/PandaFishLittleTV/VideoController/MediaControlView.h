//
//  MediaControlView.h
//  KS3PlayerDemo
//
//  Created by Blues on 15/3/24.
//  Copyright (c) 2015年 KSY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MediaControlView : UIView

@property (nonatomic, weak) id controller;

- (void)updateSubviewsLocation;

@end
