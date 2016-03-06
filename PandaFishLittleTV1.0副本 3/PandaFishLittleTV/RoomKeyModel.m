//
//  RoomKeyModel.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/29.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "RoomKeyModel.h"

@implementation RoomKeyModel


+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    
    return YES;
}

// Model 中得数据类型与系统冲突

+ (JSONKeyMapper *)keyMapper {
    
    NSDictionary * dic = @{@"errno":@"err"};
    
    return [[JSONKeyMapper alloc] initWithDictionary:dic];
    
}


@end
@implementation Data

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    
    return YES;
}

@end


@implementation Info

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    
    return YES;
}

@end


@implementation Roominfo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end


@implementation Hostinfo
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    
    return YES;
}

@end


@implementation Videoinfo
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    
    return YES;
}

@end


@implementation Stream_Addr
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    
    return YES;
}

@end


@implementation Chatinfo
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    
    return YES;
}

@end


@implementation Userinfo
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    
    return YES;
}

@end


