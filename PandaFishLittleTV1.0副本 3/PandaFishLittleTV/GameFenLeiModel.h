//
//  GameFenLeiModel.h
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/29.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import <JSONModel/JSONModel.h>

// 虽然这里的class GameData 是以类的方式出现的，但
@class GameData;

@protocol GameData <NSObject>

@end
@interface GameFenLeiModel : JSONModel

@property (nonatomic, assign) NSInteger err;

@property (nonatomic, strong) NSArray<GameData > *data;

@property (nonatomic, copy) NSString *errmsg;

@property (nonatomic, copy) NSString *authseq;

@end

@interface GameData : JSONModel

@property (nonatomic, copy) NSString *ext;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *ename;

@property (nonatomic, copy) NSString *cname;

@end

