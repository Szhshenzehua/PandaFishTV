//
//  AllLiveModel.h
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol AllLiveItems <NSObject>


@end

@class AllLiveData,AllLiveItems,AllLiveUserinfo,AllLivePictures;
@interface AllLiveModel : JSONModel

@property (nonatomic, assign) NSInteger err;

@property (nonatomic, strong) AllLiveData *data;

@property (nonatomic, copy) NSString *errmsg;

@property (nonatomic, copy) NSString *authseq;


@end

@interface AllLiveData : JSONModel

@property (nonatomic, strong) NSArray<AllLiveItems > *items;
@property (nonatomic, copy) NSString *total;

@end

@interface AllLiveItems : JSONModel

@property (nonatomic, copy) NSString *person_num;

@property (nonatomic, copy) NSString *fans;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *reduce_ratio;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *remind_switch;

@property (nonatomic, copy) NSString *ratio;

@property (nonatomic, copy) NSString *createtime;

@property (nonatomic, copy) NSString *duration;

@property (nonatomic, copy) NSString *unlock_time;

@property (nonatomic, copy) NSString *person_switch;

@property (nonatomic, strong) AllLivePictures *pictures;

@property (nonatomic, copy) NSString *classify_switch;

@property (nonatomic, copy) NSString *classification;

@property (nonatomic, copy) NSString *stream_status;

@property (nonatomic, copy) NSString *reliable;

@property (nonatomic, copy) NSString *schedule;

@property (nonatomic, copy) NSString *watermark_loc;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) AllLiveUserinfo *userinfo;

@property (nonatomic, copy) NSString *speak_interval;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *room_key;

@property (nonatomic, copy) NSString *person_num_thres;

@property (nonatomic, copy) NSString *hostid;

@property (nonatomic, copy) NSString *announcement;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *remind_content;

@property (nonatomic, copy) NSString *watermark_switch;

@property (nonatomic, copy) NSString *ver;

@property (nonatomic, copy) NSString *banned_reason;

@property (nonatomic, copy) NSString *updatetime;

@end

@interface AllLiveUserinfo : JSONModel

@property (nonatomic, assign) NSInteger rid;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *avatar;

@end

@interface AllLivePictures : JSONModel

@property (nonatomic, copy) NSString *img;

@end

