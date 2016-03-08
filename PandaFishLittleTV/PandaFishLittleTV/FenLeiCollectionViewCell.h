//
//  FenLeiCollectionViewCell.h
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameFenLeiModel.h"
@interface FenLeiCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *gameImage;
@property (weak, nonatomic) IBOutlet UILabel *gameName;


- (void)config:(GameData *)model;

@end
