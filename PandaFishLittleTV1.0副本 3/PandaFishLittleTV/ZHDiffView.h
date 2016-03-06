//
//  ZHDiffView.h
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/26.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^click) (int i);

@interface ZHDiffView : UIView

// imageNames 和images 二选一
//图片名数组
@property(nonatomic,weak)NSArray *imageNames;
//图片数组
@property(nonatomic,weak)NSArray *images;

//回调单击方法
@property(nonatomic,strong)click click;



@end
