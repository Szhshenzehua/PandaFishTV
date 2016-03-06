//
//  ZHeaderHelp.h
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/24.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#ifndef ZHeaderHelp_h
#define ZHeaderHelp_h

#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define kWindowWidth                        ([[UIScreen mainScreen] bounds].size.width)

#define kWindowHeight                       ([[UIScreen mainScreen] bounds].size.height)

#define KWindowBounds  [UIScreen mainScreen].bounds

#define AllLiveAPI @"http://api.m.panda.tv/ajax_live_lists?__version=1.0.0.1140&__plat=ios&pageno=%d&pagenum=10&status=2&order=person_num&ts=%@"

#define SubGameAPI @"http://api.m.panda.tv/ajax_get_live_list_by_cate?__version=1.0.0.1140&__plat=ios&cate=%@&pageno=1&pagenum=%d"

#define GameAPI @"http://api.m.panda.tv/ajax_get_all_subcate?__plat=ios&__version=1.0.0.1140&ts=%@"

#define PandaSlideAPI @"http://api.m.panda.tv/ajax_rmd_ads_get?__version=1.0.0.1140&__plat=ios&ts=%@"

#define PandaRoomAPI @"http://api.m.panda.tv/ajax_rmd_hotlives_get?__version=1.0.0.1140&__plat=android&ts=%@"

#define RoomIDKeyAPI @"http://api.m.panda.tv/ajax_room?roomid=%@&type=json&__version=1.0.0.1140&__plat=ios&ts=%@"

// 超清    高清  _mid.flv
#define PlayVideoAPI @"http://pl3.live.panda.tv/live_panda/%@.flv"
#define PlayVieeoAPI1 @"http://pl8.live.panda.tv/live_panda/%@.flv"


#define KTopViewHight 50

#endif /* ZHeaderHelp_h */
