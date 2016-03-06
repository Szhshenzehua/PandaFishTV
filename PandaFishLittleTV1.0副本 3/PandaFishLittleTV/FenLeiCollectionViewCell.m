//
//  FenLeiCollectionViewCell.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "FenLeiCollectionViewCell.h"
#import <UIImageView+WebCache.h>
@implementation FenLeiCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)config:(GameData *)model {

    _gameName.text = model.cname;
    
    [_gameImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"clean"]];

}

@end
