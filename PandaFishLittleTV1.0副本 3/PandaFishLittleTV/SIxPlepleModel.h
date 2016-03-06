
//
//  SIxPlepleModel.h
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/27.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class Pictures;

@interface SIxPlepleModel : JSONModel


@property (nonatomic, copy) NSString *person_num;

@property (nonatomic, copy) NSString *fans;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *reduce_ratio;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *remind_switch;

@property (nonatomic, copy) NSString *notice;

@property (nonatomic, copy) NSString *createtime;

@property (nonatomic, copy) NSString *duration;

@property (nonatomic, copy) NSString *unlock_time;

@property (nonatomic, copy) NSString *person_switch;

//@property (nonatomic, strong) Pictures *pictures;

@property (nonatomic, copy) NSString *classify_switch;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *details;

@property (nonatomic, copy) NSString *classification;

@property (nonatomic, copy) NSString *stream_status;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *reliable;

@property (nonatomic, copy) NSString *schedule;

@property (nonatomic, copy) NSString *watermark_loc;

@property (nonatomic, copy) NSString *roomid;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *speak_interval;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *order;

@property (nonatomic, copy) NSString *person_num_thres;

@property (nonatomic, copy) NSString *hostid;

@property (nonatomic, copy) NSString *announcement;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *remind_content;

@property (nonatomic, copy) NSString *watermark_switch;

@property (nonatomic, copy) NSString *ver;

@property (nonatomic, copy) NSString *banned_reason;

@property (nonatomic, copy) NSString *updatetime;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *bigimg;


+ (NSMutableArray *)arrayOfDictionariesFromModels:(id)resond;




@end
@interface Pictures : NSObject

@property (nonatomic, copy) NSString *img;

@end

