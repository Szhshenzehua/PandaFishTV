

//
//  HeadImageArrayModel.h
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/27.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import <JSONModel/JSONModel.h>





@interface HeadImageArrayModel : JSONModel

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *room_key;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *stream_status;

@property (nonatomic, copy) NSString *person_num;

@property (nonatomic, copy) NSString *schedule;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *roomid;

@property (nonatomic, copy) NSString *details;

@property (nonatomic, copy) NSString *bigimg;

@property (nonatomic, copy) NSString *qcm_img;

@property (nonatomic, copy) NSString *notice;

@property (nonatomic, copy) NSString *qcmsint1;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *classification;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, copy) NSString *order;

@property (nonatomic, copy) NSString *qcms_img_pad;


+ (NSMutableArray *)arrayOfDictionariesFromModels:(id)resond;

@end

