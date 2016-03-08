//
//  PlayViewController.h
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/3/3.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShouCangModel.h"
@interface PlayViewController : UIViewController

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) ShouCangModel *model;

@property (nonatomic, copy) NSString *roomImageURl;
@property (nonatomic, copy) NSString * playURL;
@property (nonatomic, copy) NSString *xiangqing;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *roomID;

@property (nonatomic, copy) NSString *imageURl;

@property (nonatomic, copy) NSString *roomKey;

@property  (nonatomic, copy) NSString *pinFen;




@end
