//
//  MediaVoiceView.m
//  KSYVideoDemo
//
//  Created by Blues on 15/6/2.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#define kItemNum 20
#define kColor [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2]

#import "MediaVoiceView.h"

@interface MediaVoiceView () {
    UIColor *_fillColor;
}

@end

@implementation MediaVoiceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self loadMarks];
    }
    return self;
}

- (void)loadMarks {
    CGFloat W = self.frame.size.width;
    CGFloat H = self.frame.size.height;
    for (NSInteger i = 0; i < kItemNum; i ++) {
        CGFloat X = 1.0 / (kItemNum * 2) * i * W;
        CGFloat Y = 1.0 / (kItemNum * 2) * (2 * i) * H;
        CGRect rect = CGRectMake(X, Y, W - 2 * X, H / (kItemNum * 2));
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.tag = kItemNum - i;
        view.backgroundColor = kColor;
        [self addSubview:view];
    }
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
}

- (void)setIVoice:(CGFloat)iVoice {
    NSInteger level = iVoice * 100 / 5;
    for (NSInteger i = 0; i < kItemNum; i ++) {
        UIView *view = [self viewWithTag:i + 1];
        view.backgroundColor = kColor;
        if (i < level) {
            view.backgroundColor = _fillColor;
        }
    }
}

@end
