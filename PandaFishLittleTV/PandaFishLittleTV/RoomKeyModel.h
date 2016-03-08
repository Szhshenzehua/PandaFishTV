

//
//  RoomKeyModel.h
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/29.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class Data,Info,Roominfo,Hostinfo,Videoinfo,Stream_Addr,Chatinfo,Userinfo;
@interface RoomKeyModel : JSONModel


@property (nonatomic, assign) NSInteger err;

@property (nonatomic, strong) Data *data;

@property (nonatomic, copy) NSString *errmsg;

@property (nonatomic, copy) NSString *authseq;


@end
@interface Data : JSONModel

@property (nonatomic, strong) Info *info;

@end

@interface Info : JSONModel

@property (nonatomic, strong) Roominfo *roominfo;

@property (nonatomic, strong) Hostinfo *hostinfo;

@property (nonatomic, strong) Videoinfo *videoinfo;

@property (nonatomic, strong) Chatinfo *chatinfo;

@property (nonatomic, strong) Userinfo *userinfo;

@end

@interface Roominfo : JSONModel

@property (nonatomic, copy) NSString *bulletin;

@property (nonatomic, copy) NSString *details;

@property (nonatomic, copy) NSString *remind_content;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *remind_time;

@property (nonatomic, copy) NSString *person_num;

@property (nonatomic, copy) NSString *remind_status;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *fans;

@property (nonatomic, copy) NSString *name;

@end

@interface Hostinfo : JSONModel

@property (nonatomic, assign) NSInteger rid;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *bamboos;

@property (nonatomic, copy) NSString *avatar;

@end

@interface Videoinfo : JSONModel

@property (nonatomic, strong) Stream_Addr *stream_addr;

@property (nonatomic, copy) NSString *room_key;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *plflag;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *ts;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, copy) NSString *name;

@end

@interface Stream_Addr : JSONModel

@property (nonatomic, copy) NSString *OD;

@property (nonatomic, copy) NSString *SD;

@property (nonatomic, copy) NSString *HD;

@end

@interface Chatinfo : JSONModel

@property (nonatomic, assign) NSInteger rid;

@property (nonatomic, copy) NSString *ts;

@property (nonatomic, copy) NSString *appid;

@property (nonatomic, strong) NSArray<NSString *> *chat_addr_list;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, copy) NSString *authtype;

@end

@interface Userinfo : JSONModel

@property (nonatomic, assign) NSInteger rid;

@property (nonatomic, copy) NSString *identity;

@property (nonatomic, copy) NSString *sp_identity;

@property (nonatomic, copy) NSString *is_followed;

@end

