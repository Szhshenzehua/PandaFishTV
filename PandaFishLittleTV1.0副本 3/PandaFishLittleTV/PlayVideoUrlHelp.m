//
//  PlayVideoUrlHelp.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/29.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "PlayVideoUrlHelp.h"
#import <AFNetworking.h>
#import "ZHeaderHelp.h"
#import "RoomKeyModel.h"

@implementation PlayVideoUrlHelp

{
    RoomKeyModel  * _keyModel;

}
+ (RoomKeyModel *)keepRoomIDToRoomKeyModel:(NSString *)roomID {

//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    
//    NSTimeInterval a = [dat timeIntervalSince1970] * 1000.0000;
//    NSString *timeString = [NSString stringWithFormat:@"%f", a];
//    NSString *playURL = [NSString stringWithFormat:RoomIDKeyAPI,roomID,timeString];
//    
//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    //增加新的类型text/html
//    NSSet *currentAcceptSet = manager.responseSerializer.acceptableContentTypes;
//    NSMutableSet *mset = [NSMutableSet setWithSet:currentAcceptSet];
//    [mset addObject:@"text/html"];
//    [mset addObject:@"application/json"];
//    manager.responseSerializer.acceptableContentTypes = mset;
//    NSString *url = playURL;
//    
//    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        _keyModel = [[RoomKeyModel alloc] initWithDictionary:responseObject error:nil];
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        NSLog(@"由RoomID没有得到RoomKey%@",error);
//    }];
//
//
//    if (_keyModel) {
//        return _keyModel;
//    }
//
//
    return nil;
}


@end
