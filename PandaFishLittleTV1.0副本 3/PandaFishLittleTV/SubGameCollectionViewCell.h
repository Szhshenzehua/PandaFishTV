//
//  SubGameCollectionViewCell.h
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubGameCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *roomImage;
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UILabel *preceName;

@end
