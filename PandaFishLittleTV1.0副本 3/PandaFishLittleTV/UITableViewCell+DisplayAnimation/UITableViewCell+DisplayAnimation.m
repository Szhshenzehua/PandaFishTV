//
//  UITableViewCell+DisplayAnimation.m
//  TableViewCellAnimationDemo
//
//  Created by xietao on 15/7/17.
//  Copyright (c) 2015年 yeku. All rights reserved.
//

#import "UITableViewCell+DisplayAnimation.h"

@implementation UITableViewCell (DisplayAnimation)
#pragma mark - 延迟动画
/**
 *  延迟动画 计算
 *
 *  @param tableView
 */
- (void)startCellDelayDisplayAnimationWithTableView:(UITableView *)tableView{
    CGFloat offset = 0;
    CGFloat baseRowHeight = 320 / 4;
    if (tableView.scrollAmount > 0 && tableView.contentOffset.y > baseRowHeight) {
        offset = baseRowHeight*4;
    } else if (tableView.scrollAmount < 0) {
        offset = -baseRowHeight*4;
    }

    if (offset != 0){
        [self startAnimationWithOffset:offset];
    }
}

/**
 *  开始动画
 *
 *  @param offset
 */
- (void)startAnimationWithOffset:(CGFloat)offset
{
    [self startAnimationWithOffset:offset delay:0];
}

- (void)startAnimationWithOffset:(CGFloat)offset delay:(CGFloat)delay
{
    self.layer.hidden = YES;
    
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.delegate = self;
    if (delay > 0) animation.beginTime = CACurrentMediaTime() + delay;
    animation.duration = 0.4;
    animation.fromValue = @(offset);
    animation.toValue = @(0);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.layer addAnimation:animation forKey:@"transform.translation.y"];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    if ([anim isKindOfClass:[CABasicAnimation class]] &&
        [[(CABasicAnimation *)anim keyPath] isEqualToString:@"transform.translation.y"])
    {
        self.layer.hidden = NO;
    }else if ([anim isKindOfClass:[CABasicAnimation class]] &&
        [[(CABasicAnimation *)anim keyPath] isEqualToString:@"transform.scale"]){
        self.layer.hidden = NO;
    }
}


#pragma mark - 放大动画
/**
 *  放大动画
 */
- (void)startCellScaleAnimation{
    self.layer.hidden = YES;

    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.delegate = self;
    animation.duration = 0.4;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.layer addAnimation:animation forKey:@"transform.scale"];
}

@end
