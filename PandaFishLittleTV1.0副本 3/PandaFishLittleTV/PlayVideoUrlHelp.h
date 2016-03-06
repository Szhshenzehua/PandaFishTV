//
//  PlayVideoUrlHelp.h
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/29.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomKeyModel.h"
@interface PlayVideoUrlHelp : NSObject

/**
 *  通过房间号 得到 房间的具体信息
 *
 *  @param roomID 房间号
 *
 *  @return 返回包含RoomKey的模型
 */

+ (RoomKeyModel *)keepRoomIDToRoomKeyModel:(NSString *)roomID;




@end
