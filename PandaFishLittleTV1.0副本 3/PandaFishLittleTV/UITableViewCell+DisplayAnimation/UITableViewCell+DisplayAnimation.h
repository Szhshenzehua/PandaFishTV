//
//  UITableViewCell+DisplayAnimation.h
//  TableViewCellAnimationDemo
//
//  Created by xietao on 15/7/17.
//  Copyright (c) 2015年 yeku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+UITableViewCellDisplayAnimation.h"

@interface UITableViewCell (DisplayAnimation)

/**
 *  延迟出现动画
 *
 *  @param tableView
 */
- (void)startCellDelayDisplayAnimationWithTableView:(UITableView *)tableView;

/**
 *  放大动画
 */
- (void)startCellScaleAnimation;


@end
