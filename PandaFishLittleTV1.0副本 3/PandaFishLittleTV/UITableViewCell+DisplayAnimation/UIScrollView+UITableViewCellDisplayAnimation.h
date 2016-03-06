//
//  UIScrollView+UITableViewCellDisplayAnimation.h
//  TableViewCellAnimationDemo
//
//  Created by xietao on 15/7/17.
//  Copyright (c) 2015年 yeku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (UITableViewCellDisplayAnimation)
@property (assign, nonatomic) CGFloat scrollAmount;
@property (assign, nonatomic) CGFloat previousScrollOffset;

/**
 *  获取当前Offset(当使用startCellDelayDisplayAnimationWithTableView动画时 需要在scrollViewDidScroll中加入该方法)
 *
 *  @param scrollView 
 */
- (void)offsetWithScrollView;
@end
